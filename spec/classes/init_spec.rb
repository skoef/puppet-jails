require 'spec_helper'
describe 'jails' do

  context 'with defaults for all parameters' do
    it { should contain_class('jails') }
  end
end
