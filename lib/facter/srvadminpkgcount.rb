# Return the package count of installed srvadmin (openmanage) RPMs.

Facter.add("srvadminpkgcount") do
  confine :operatingsystem => %w{Fedora RedHat CentOS}
  setcode do
    %x{rpm -qa srvadmin-*}.split("\n").length
  end
end
