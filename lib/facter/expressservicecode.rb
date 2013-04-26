if Facter.value(:id) == 'root' and
   Facter.value(:is_virtual) == 'false' and
   !Facter.value(:manufacturer).nil? and
   Facter.value(:manufacturer).match(/dell/i)

   if Facter.value(:serialnumber) and ( Facter.value(:serialnumber).length == 5 or Facter.value(:serialnumber).length == 7 )

      Facter.add('expressservicecode') do
         setcode do
            Facter.value(:serialnumber).to_i(36)
         end
      end
   end
end
