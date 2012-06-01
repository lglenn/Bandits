require 'spec_helper'
require 'kitty'

describe Kitty do

  before(:each) do
    @start = 1000
    @kitty = Kitty.new(@start)
  end

  subject { @kitty }

  its('balance') { should eq @start }

  describe "winning" do
    before do
      @kitty.win 10
    end
    its('balance') { should eq @start + 10 }
  end

  describe "losing" do
    before do
      @kitty.lose 10
    end
    its('balance') { should eq @start - 10 }
  end

end
