require 'spec_helper'

describe 'dell::hwtools' do

  let(:pre_condition) do
    "class { '::dell': }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile.with_all_deps }
    end
  end
end
