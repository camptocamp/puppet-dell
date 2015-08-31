# Based on https://github.com/kwolf/dell_info/blob/master/lib/facter/dell_info.rb

require 'facter/util/warranty'


Facter.add(:is_dell_machine) do
  confine :kernel => :linux
  confine :is_virtual => [:false, false]

  setcode { !!(Facter.value(:serialnumber) && Facter.value(:manufacturer) =~ /dell/i) }
end

Facter.add(:warranty_start) do
  confine :is_dell_machine => true

  setcode { Facter::Util::Warranty.purchase_date.to_s }
end

Facter.add(:warranty_end) do
  confine :is_dell_machine => true

  setcode do
    enddate = Date.parse(Time.at(0).to_s)
    Facter::Util::Warranty.warranties.each do |warranty|
      if Date.parse(warranty['EndDate']) > enddate
        enddate = Date.parse(warranty['EndDate'])
      end
    end
    enddate.to_s
  end
end

Facter.add(:warranty_days_left) do
  confine :is_dell_machine => true

  setcode do
    today = Date.parse(Time.now.to_s)
    enddate = Date.parse(Facter.value(:warranty_end))
    (enddate - today).to_i
  end
end

# We don't need all these facts for now
# but they're coded (and they work)

#Facter.add(:server_age) do
#  confine :is_dell_machine => true
#
#  setcode do
#    age = ((Date.today - Facter::Util::Warranty.purchase_date).to_i / 365.0)
#    "%.2f years" % [age]
#  end 
#end
#
#Facter::Util::Warranty.warranties.each_with_index do |warranty, index|
#  Facter.add("warranty#{index}_expires") do
#    confine :is_dell_machine => true
#
#    setcode { Date.parse(warranty['EndDate']).to_s }
#  end
#
#  Facter.add("warranty#{index}_type") do
#    confine :is_dell_machine => true
#
#    setcode { warranty['EntitlementType'] }
#  end
#
#  Facter.add("warranty#{index}_desc") do
#    confine :is_dell_machine => true
#
#    setcode { warranty['ServiceLevelDescription'] }
#  end
#end
#
#Facter.add(:warranty) do
#  confine :is_dell_machine => true
#
#  setcode do
#    covered = false
#    Facter::Util::Warranty.warranties.each do |warranty|
#      covered = (Date.parse(warranty['EndDate']) > Date.parse(Time.now.to_s)) if covered == false
#    end
#    covered
#  end
#end
