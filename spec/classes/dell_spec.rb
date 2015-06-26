require 'spec_helper'

describe 'dell' do

  let(:facts) {{
    :lsbdistcodename => 'wheezy',
    :osfamily        => 'Debian',
    :productname     => 'foo',
  }}

  it { should compile.with_all_deps }

  let(:facts) {{
    :lsbdistcodename => 'trusty',
    :osfamily        => 'Debian',
    :operatingsystem => 'Ubuntu',
    :productname     => 'foo',
  }}

  it { should compile.with_all_deps }

  let(:facts) {{
    :lsbdistcodename           => nil,
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemmajrelease => '5',
    :productname               => 'foo',
  }}

  it { should compile.with_all_deps }

  let(:facts) {{
    :lsbdistcodename           => nil,
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemmajrelease => '6',
    :productname               => 'foo',
  }}

  it { should compile.with_all_deps }

  let(:facts) {{
    :lsbdistcodename           => nil,
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemmajrelease => '7',
    :productname               => 'foo',
  }}

  it { should compile.with_all_deps }

end
