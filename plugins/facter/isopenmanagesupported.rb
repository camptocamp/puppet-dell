#
# As we don't want to query dell's website each run to know if the system is
# supported by openmanage, we have to maintain a static list.
# 
# Fetch the list of known systems:
# elinks -dump -no-references http://linux.dell.com/repo/hardware/latest/ | grep 'ven_0x1028' | sed 's/.*0x1028\.dev_\([0-9a-z]\+\)\/.*/\1/'
# 
# Loop through the list to find which ones have a srvadmin directory:
# for i in 0x009a [...]; do
#   if HEAD http://linux.dell.com/repo/hardware/latest/system.ven_0x1028.dev_$i/rh50/srvadmin/ | egrep "^200 OK$" > /dev/null; then
#       echo -n "$i, "
#   fi
# done
# 
# Finally, copy-paste the result in the "supported" array below.
#
# You can also add the output of "getSystemId | grep 'System ID:'" to the list
# for known working systems
#


supported = ["0x01b1", "0x01b2", "0x01b3", "0x01b6", "0x01b7", "0x01b8", "0x01bb", "0x01e6", "0x01e7", "0x01ea", "0x01f0", "0x010a", "0x0106", "0x0109", "0x011b", "0x0121", "0x0123", "0x0124", "0x0134", "0x0135", "0x014a", "0x0141", "0x016c", "0x016d", "0x016e", "0x016f", "0x0165", "0x0167", "0x0170", "0x018a", "0x0183", "0x0185", "0x020c", "0x020f", "0x0205", "0x0208", "0x0210", "0x023c", "0x023f", "0x0240", "0x027c", "0x0280"]

Facter.add("isopenmanagesupported") do
    setcode do

        if FileTest.exists?("/usr/sbin/smbios-sys-info-lite")
            output = %x{/usr/sbin/smbios-sys-info-lite}
            systemid = /^System ID:\s+(.*)$/.match(output)

            if systemid.nil? or systemid.length != 2
                "no"
            elsif output =~ /^Is Dell:\s+1$/ and supported.include?(systemid[1].downcase)
                "yes"
            else
                "no"
            end
        else
            nil
        end

    end
end

