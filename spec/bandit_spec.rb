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
      1000.times do
        @mybandits[3].pull
      end
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

shared_examples "a new machine" do
  its('score') { should eq 0 }
  its('pulls') { should eq 0 }
  its('wins') { should eq 0 }
end

describe Bandit do

  before(:each) do
    @name = 'myname'
    @chance = 0.2
    @bandit = Bandit.new(@name,@chance)
  end

  subject { @bandit }

  its('name') { should eq @name }
  its('to_s') { should eq @name }
  it_should_behave_like "a new machine"
  
  describe "after a few pulls" do

    before do
      1000.times do
        @bandit.pull
      end
    end

    its('pulls') { should eq 1000 }
    its('wins') { should be > 0 }
    its('score') { should be > 0 }
    its('score') { should be <= 1 }

    describe "and a reset" do
      before do
        @bandit.reset
      end
      it_should_behave_like "a new machine"
    end

  end

end
