require 'spec_helper'

describe Bandits do

  before(:each) do
    @bandits = Bandits.new
    @bandit_params = { 'a' => 0.1, 'b' => 0.1, 'c' => 0.2, 'd' => 0.3 }
    @mybandits = []
    @bandit_params.each do |name,chance|
      @mybandits << Bandit.new(name,chance)
      @bandits << @mybandits.last
    end
  end

  subject { @bandits }

  describe "each" do
    it "returns each of the bandits" do 
      all = []
      @bandits.each do |b|
        all << b
      end
      all.should include(*@mybandits)
      all.size.should eq @bandits.size
    end
  end

  its('size') { should be @mybandits.size }
  its('names') { should include(*@bandit_params.keys) }
  its('random') { should be_a_kind_of Bandit }

  describe "best" do
    before do
      @mybandits[3].reward
    end
    its('best') { should be @mybandits[3] }
  end

  describe "<<" do
    it "adds a Bandit" do 
      @bandits << Bandit.new('a',0.1)
      @bandits.size.should be 1 + @mybandits.size
    end

  end

end


