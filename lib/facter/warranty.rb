check_script = '/usr/local/sbin/check_dell_warranty.py'

if Facter.value(:id) == 'root' and
   Facter.value(:is_virtual) == 'false' and
   !Facter.value(:manufacturer).nil? and
   Facter.value(:manufacturer).match(/dell/i) and
   File.exist?(check_script)
  
  tag = Facter.value(:serialnumber)
  cache = "/var/tmp/dell-warranty-#{tag}.fact"
  output = nil

  if File.exists?(cache) and File.size(cache) > 1 and Time.now < File.stat(cache).mtime + 86400
    file = File.new(cache, "r")
    output = file.read
    file.close
  else
    cmd = IO.popen("#{check_script} -s #{tag}")
    output = cmd.read
    cmd.close
    if $?.exitstatus.to_i == 0
      file = File.new(cache, "w")
      file.puts output
      file.close
    end
  end
  
  regex = Regexp.new('Start:\s(\d{4}-\d{2}-\d{2}),\sEnd:\s(\d{4}-\d{2}-\d{2}),\sDays left:\s(-?\d+)')
  warranty = output.match(regex)
  
  if warranty and warranty.length == 4

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
