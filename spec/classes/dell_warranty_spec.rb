require 'spec_helper'

describe 'dell::warranty' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:pre_condition) {
        'include ::dell'
      }

      it { should compile }
    end
  end
end
