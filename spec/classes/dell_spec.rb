require 'spec_helper'

describe 'dell' do

  let(:facts) {{
    :lsbdistcodename => 'wheezy',
    :osfamily        => 'Debian',
    :productname     => 'foo',
  }}

  it { should compile.with_all_deps }

end
