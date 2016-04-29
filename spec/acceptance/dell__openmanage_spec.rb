require 'spec_helper_acceptance'

describe 'dell::openmanage' do

  context 'when running puppet code' do
    pp = "include ::dell include ::dell::openmanage"

    it 'should apply with no errors' do
      apply_manifest(pp, :catch_failures => true)
    end

    it 'should converge on the first run' do
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
