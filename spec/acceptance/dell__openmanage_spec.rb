require 'spec_helper_acceptance'

describe 'dell::openmanage' do

  context 'when running puppet code' do
    pp = "include ::dell
    # dataeng cannot start on a non-Dell machine...
    # see http://vmhacks.com/dell-openmanage-system-administrator-startup-error-dsm-sa-shared-services-cannot-start-on-an-unsupported-system/
    class { '::dell::openmanage':
      service_ensure => 'stopped',
    }"

    it 'should apply with no errors' do
      apply_manifest(pp, :catch_failures => true)
    end

    it 'should converge on the first run' do
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
