require 'puppet'
require 'date'
require 'time'

module Facter::Util::Warranty
  def self.url
    'https://api.dell.com/support/v2/assetinfo/warranty/tags.json?apikey=%s&svctags=%s'
  end

  def self.apikey
    '849e027f476027a394edd656eaef4842'
  end

  def self.cache_file
    "/var/tmp/dell-warranty-#{Facter.value('serialnumber')}.json"
  end

  def self.cache_ttl
    604800
  end

  def self.get_cache
    dell_cache = nil
    cache_time = Time.at(0)
    Facter.debug("cache_file=#{cache_file}")
    if File::exists?(cache_file)
      begin
        File.open(cache_file, "r") do |f|
          dell_cache = PSON.load(f)
        end
        cache_time = File.mtime(cache_file)
      rescue Exception => e
        cache_time = Time.at(0)
        Facter.debug("#{e.backtrace[0]}: #{$!}.")
      end
    else
      Facter.debug("Cache file not found.")
    end
    return dell_cache, cache_time
  end

  def self.write_cache(content)
    Facter.debug("Writing to #{cache_file}")
    File.open(cache_file, 'w') do |out|
      out.write(PSON.pretty_generate(content))
    end
  end

  def self.cache_expired?(content, cache_time)
    Facter.debug("content=#{content}")
    Facter.debug("cache_time=#{cache_time}")
    content.nil? || (Time.now - cache_time) > cache_ttl
  end

  def self.get_data
    dell_cache, cache_time = get_cache
    json = nil
    if cache_expired?(dell_cache, cache_time)
      Facter.debug('Cache expired')
      api_url = url % [apikey, Facter.value('serialnumber')]
      begin
        response = nil
        Timeout::timeout(30) {
          Facter.debug('Getting api.dell.com')
          Facter.debug("url=#{api_url}")
          response = Facter::Util::Resolution.exec("/usr/bin/curl -ks '#{api_url}'")
        }

        json = PSON.parse(response) if response
      rescue Exception => e
        Facter.debug("#{e.backtrace[0]}: #{$!}.")
      end
      # Write cache
      Facter.debug('Writing cache')
      write_cache(json)
      json
    else
      Facter.debug('Using cached data')
      if (dell_cache)
        dell_cache
      else
        Facter.debug('Error getting response from api.dell.com')
      end
    end
  end

  def self.purchase_date
    Facter.debug('Getting purchase date')
    json = get_data
    if defined?(json)
      pd = json['GetAssetWarrantyResponse']['GetAssetWarrantyResult']['Response']['DellAsset']['ShipDate']
      Date.parse(pd)
    end
  end

  def self.warranties
    Facter.debug('Getting warranties')
    json = get_data
    json['GetAssetWarrantyResponse']['GetAssetWarrantyResult']['Response']['DellAsset']['Warranties']['Warranty'] if defined?(json)
  end
end
