require 'net/https'
require 'yaml'
require 'open-uri'
require 'rexml/document'
require 'json'

# Hack to allow wrapping hash with array, but keeping arrays as-is:
class Object; def ensure_array; [self] end end
class Array; def ensure_array; to_a end end
class NilClass; def ensure_array; to_a end end

def create_dell_warranty_cache(cache)

  warranty        = false
  expiration_date = Time.parse('1901-01-01T00:00:00')
  orig_exp_date   = expiration_date
  start_date      = Time.now() # Push start time back and expiration forward
  servicetag      = Facter.value('serialnumber')

  # Dell v5 API requires OAuth2 setup before the call, but this just adds one minor step
  # (ends up with the same data in the response, in a very similar format to v4 responses!)

  begin
    dell_client_id     = File.read("/etc/dell_client_id")     # API v5 client_id needs to be grabbed from a file
    dell_client_secret = File.read("/etc/dell_client_secret") # API v5 client_secret needs to be grabbed from a file

    # Examples using curl:
    # 1) OAuth2 POST to get bearer token
    #   curl -X POST --data 'grant_type=client_credentials' --data 'client_id=<id>' --data 'client_secret=<secret>'  https://apigtwb2c.us.dell.com/auth/oauth/v2/token
    # 2) API v5 GET passing returned token to get JSON warranty info as before
    #   curl -X GET https://apigtwb2c.us.dell.com/PROD/sbil/eapi/v5/asset-entitlements?servicetags=BR8P7J2 --header 'Authorization: Bearer <token_returned_by_first_call>'

    oauth_post_uri   = URI.parse("https://apigtwb2c.us.dell.com/auth/oauth/v2/token")
    oauth_params     = {
      :grant_type    => 'client_credentials',
      :client_id     => dell_client_id,
      :client_secret => dell_client_secret,
    }
    # TODO : Ensure SSL verified!
    oauth_res        = Net::HTTP.post_form oauth_post_uri, oauth_params
    oauth_r          = JSON.parse(oauth_res.body)
    bearer_token     = oauth_r['access_token']

    # TODO : Fail if no result or token not found

    # Use returned token in headers to make GET request against Dell API server
    headers = {
      'Authorization' => "Bearer #{bearer_token}"
    }
    uri              = URI.parse("https://apigtwb2c.us.dell.com/PROD/sbil/eapi/v5/asset-entitlements?servicetags=#{servicetag}")
    http             = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl     = true
    # HACK : Currently we do no SSL verification:
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # TODO : Reject SSL failures by setting these:
    #        (but the CA file path is different per distro...)
    # Or get cacert.pem from curl devs : https://curl.haxx.se/docs/caextract.html
    # (thanks go to https://www.theguild.nl/ruby-and-ssl-certificate-validation/)
    #http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    #http.ca_file     = File.join(File.dirname(__FILE__), "cacert.pem")
    request          = Net::HTTP::Get.new(uri.request_uri, headers)
    response         = http.request(request)
    r                = JSON.parse(response.body)
  rescue # ...in case dell.com is down or other failures occur
  end

  begin
    w = r[0]['entitlements']
    w2 = w.ensure_array

    w2.each do |h|
      # Only allow ServiceLevelGroup 5 for support rather than "Dell Digital Delivery" or others?
      # TODO : Need a list of the ServiceLevelGroups and what they mean!
      if h['serviceLevelGroup'] != 5
        Facter.debug("Dell API v5 : ...skipping warranty array elem as doesn't match ServiceLevelGroup 5")
        next
      end

      new_expiration_date = Time.parse(h['endDate'])
      if expiration_date < new_expiration_date
        expiration_date = new_expiration_date
      end

      # We also want the start date for reporting purposes
      new_start_date = Time.parse(h['startDate'])
      if new_start_date < start_date
        start_date = new_start_date
      end
    end
  rescue
  end

  warranty = true if expiration_date > Time.now()

  # Skip writing warranty if cache file already exists and we haven't got info this time..
  # This avoids clobbering the cache with invalid info when we get an invalid response
  if File.file?(cache) && expiration_date == orig_exp_date
    Facter.debug('Dell API v5 : warranty cache: invalid data received from Dell API, not updating.')
  else
    File.open(cache, 'w') do |file|
      YAML.dump({'warranty_status' => warranty,
                 'start_date'      => start_date.strftime("%Y-%m-%d"),
                 'expiration_date' => expiration_date.strftime("%Y-%m-%d")},
                file)
    end
  end
end


def create_lenovo_warranty_cache(cache)
  # Setup HTTP connection
  uri              = URI.parse('http://support.lenovo.com/templatedata/Web%20Content/JSP/warrantyLookup.jsp')
  http             = Net::HTTP.new(uri.host, uri.port)
  request          = Net::HTTP::Post.new(uri.request_uri)

  # Prepare POST data
  request.set_form_data({ 'sysSerial' => Facter.value('serialnumber') })

  # POST data and get the response
  response      = http.request(request)
  response_data = response.body
  warranty = false
  if /Active/.match(response_data)
    warranty = true
  end

  warranty_expiration = /\d{4}-\d{2}-\d{2}/.match(response_data)
  warranty_start = 'Unknown'

  # TODO : Read start date for Lenovo warranty too...

  File.open(cache, 'w') do |file|
    YAML.dump({'warranty_status' => warranty,
               'start_date'      => warranty_start,
               'expiration_date' => warranty_expiration.to_s},
              file)
  end
end

Facter.add('warranty') do
  confine :kernel => ['Linux', 'Windows']
  setcode do
    # Just support for dell/lenovo so far... Contribute *hint*
    next if Facter.value('manufacturer').nil?
    next if Facter.value('manufacturer').downcase !~ /(dell.*|lenovo)/
    next if !Facter.value('serialnumber')

    if Facter.value('operatingsystem') == 'windows'
      cache_file = 'C:\ProgramData\PuppetLabs\puppet\var\facts\facter_warranty.fact'
    else
      cache_file = '/var/cache/.facter_warranty.fact'
    end

    # refresh cache daily
    if File.exists?(cache_file) and Time.now < File.stat(cache_file).mtime + 86400 * 1
      Facter.debug('warranty cache: Valid')
    else
      Facter.debug('warranty cache: Outdated, recreating')

      if Facter.value('manufacturer').downcase =~ /dell.*/
        create_dell_warranty_cache cache_file
      else
        create_lenovo_warranty_cache cache_file
      end
    end

    cache = YAML::load_file cache_file
    cache['warranty_status']
  end
end

Facter.add('warranty_expiration') do
  setcode do
    confine :kernel => ['Linux', 'Windows']
    cache = ''
    cache_file = ''

    case Facter.value('kernel')
    when 'Linux'
      cache_file = '/var/cache/.facter_warranty.fact'
    when 'windows'
      cache_file = 'C:\ProgramData\PuppetLabs\puppet\var\facts\facter_warranty.fact'
    end

    if !File.exists?(cache_file)
      next false
    end

    cache = YAML::load_file cache_file
    cache['expiration_date']
  end
end

Facter.add('warranty_start') do
  setcode do
    confine :kernel => ['Linux', 'Windows']
    cache = ''
    cache_file = ''

    case Facter.value('kernel')
    when 'Linux'
      cache_file = '/var/cache/.facter_warranty.fact'
    when 'windows'
      cache_file = 'C:\ProgramData\PuppetLabs\puppet\var\facts\facter_warranty.fact'
    end

    if !File.exists?(cache_file)
      next false
    end

    cache = YAML::load_file cache_file
    cache['start_date']
  end
end
