Facter.add(:openmanagesupported) do
    setcode do
        unless defined?(@@systemid)
            type = nil
            @@systemid = Facter::Util::Resolution.exec('getSystemId')
        end

        if %r{^System ID:\t(.*)$}.match(@@systemid)
            $1
        else
            nil
        end
    end

    confine :operatingsystem => %w{RedHat CentOS SuSE Fedora}
end
