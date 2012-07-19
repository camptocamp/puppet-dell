#
# As we don't want to query dell's website each run to know if the system is
# supported by openmanage, we have to maintain a static list.
#
# The script in files/supported-systems.sh should output a list that can be
# copied in the "supported" array below.
#
# You can also add the output of "getSystemId | grep 'System ID:'" to the list
# for known working systems
#

supported = ["0x014a", "0x01b1", "0x01b2", "0x01b3", "0x01b6", "0x01b7", "0x01b8", "0x01bb", "0x01e6", "0x01e7", "0x01ea", "0x01f0", "0x016c", "0x016d", "0x016e", "0x016f", "0x0170", "0x018a", "0x0183", "0x0185", "0x020b", "0x020c", "0x020f", "0x0205", "0x0208", "0x0210", "0x0221", "0x0223", "0x023c", "0x023e", "0x0235", "0x0236", "0x0237", "0x025c", "0x027b", "0x028c", "0x028d", "0x0287", "0x029b", "0x029c", "0x0290", "0x0295", "0x02f1"]

Facter.add("isopenmanagesupported") do
    setcode do

        if FileTest.exists?("/usr/sbin/getSystemId")
            output = %x{/usr/sbin/getSystemId 2>/dev/null}
            systemid = /^System ID:\s+(.*)$/.match(output)

            if systemid.nil? or systemid.length != 2
                "no"
            elsif output =~ /^Vendor:.*Dell.*$/i and supported.include?(systemid[1].downcase)
                "yes"
            else
                "no"
            end
        else
            nil
        end

    end
end

