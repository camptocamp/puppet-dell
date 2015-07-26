Facter.add('dell_express_service_code') do
  confine :id => 'root'
  confine :is_virtual => [:false, 'false']
  if !Facter.value(:manufacturer).nil? and Facter.value(:manufacturer).match(/dell/i)
    if Facter.value(:serialnumber) and ( Facter.value(:serialnumber).length == 5 or Facter.value(:serialnumber).length == 7 )
      setcode do
        Facter.value(:serialnumber).to_i(36)
      end
    end
  end
end
