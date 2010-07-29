require 'net/http'

def fetch_page(tag)

  url_host = 'support.dell.com'
  url_path = '/support/topics/global.aspx/support/my_systems_info/details?c=us&l=en&s=gen&ServiceTag=' + tag
  cache = "/var/tmp/dell-warranty-#{tag}.fact"
  html = nil

  # fetch from cache if newer than 24h
  if File.exists?(cache) and Time.now < File.stat(cache).mtime + 86400
    file = File.new(cache, "r")
    html = file.read
    file.close
  else

    begin
      Net::HTTP.start(url_host) do |http|
        response = http.get(url_path)
        if response.code == '200'
          html = response.body
        end
      end

    rescue StandardError => error
      $stderr.print "%s in %s\n" % [error, __FILE__]
    end

    # if page got downloaded successfully
    if html and not html.empty?
      # store html in cache
      file = File.new(cache, "w")
      file.puts html
      file.close
    end
  end

  html
end

if Facter.value(:id) == 'root' and Facter.value(:manufacturer).match(/dell/i)

  tag = Facter.value(:serialnumber)

  # RE stolen from check_dell_warranty.py...
  # We want to match the following string:
  # </td><td class="contract_oddrow">7/3/2007</td><td class="contract_oddrow">7/3/2012</td><td class="contract_oddrow">707</td></tr></table>
  pattern = Regexp.new(
    '>' +                            # Match >
    '(\d{1,2}/\d{1,2}/\d{4})<' +     # Match North American style date
    '.*?>(\d{1,2}/\d{1,2}/\d{4})<' + # Match date, good for 8000 years
    '.*?>' +                         # Match anything up to >
    '(\d+)' +                        # Match number of days
    '<' )                            # Match <

  warranty = fetch_page(tag).match(pattern)

  if warranty.is_a?(MatchData) and warranty.length == 4

    Facter.add('warranty_start') do
      setcode do
        warranty[1]
      end
    end

    Facter.add('warranty_end') do
      setcode do
        warranty[2]
      end
    end

    Facter.add('warranty_days_left') do
      setcode do
        warranty[3]
      end
    end

  end
end
