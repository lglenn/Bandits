require 'spec_helper'
require 'bandit'

shared_examples "a new machine" do
  its('score') { should eq 0 }
  its('pulls') { should eq 0 }
  its('wins') { should eq 0 }
end

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

  it "does a collect" do
    @bandits.collect { |b| b.name }.should include(*@bandit_params.keys)
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

  describe "reset" do
    before do
      1000.times { @bandits.each { |b| b.pull } }
      @bandits.reset
    end
    it "resets the score on each bandit" do
      @bandits.each { |b| b.score.should eq 0 }
    end
  end

  describe "scores" do
    before do
      1000.times { @bandits.each { |b| b.pull } }
    end
    it "is an array of floats" do
      @bandits.scores.each do |s|
        s.should be_a_kind_of Float
      end
    end
  end

end

describe Bandit do

  before(:each) do
    @name = 'myname'
    @chance = 0.2
    @cost = 25
    @payout = 50
    @bandit = Bandit.new(@name,@chance)
  end

  subject { @bandit }

  its('name') { should eq @name }
  its('to_s') { should eq @name }
  it "should have a default cost of 25" do
    subject.cost.should eq 25
  end
  it "should have a default payout of 50" do
    subject.payout.should eq 50
  end

  it_should_behave_like "a new machine"
  
  describe "with custom cost and payout" do
    before do
      @bandit = Bandit.new(@name,@chance,100,200)
    end
    its('cost') { should eq 100 }
    its('payout') { should eq 200 }
  end

  describe "when it loses" do
    before do
      @bandit = Bandit.new(@name,0.0)
    end
    its('pull') { should be @cost * -1 }
  end

  describe "when it wins" do
    before do
      @bandit = Bandit.new(@name,1.0)
    end
    its('pull') { should be @payout }
  end

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
