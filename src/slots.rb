require 'bandit'
require 'kitty'

@chances = { 'a' => 0.02, 'b' => 0.03, 'c' => 0.018, 'd' => 0.032 }
@bandits = Bandits.new
@rounds = 1000000
@cost = 25
@ab_kitty = Kitty.new(@rounds * @cost * @bandits.size)
@bandit_kitty = Kitty.new(@rounds * @cost * @bandits.size)

def summarize(name)
    puts "Doing a #{name} test, you've found that #{@bandits.best.name} is the best machine, with a score of #{sprintf("%0.5f",@bandits.best.score)}."
    puts "The winning bandit was pulled #{@bandits.best.pulls} times out of #{@rounds * @bandits.size} trials, or #{sprintf("%.0f",(@bandits.best.pulls.to_f/(@rounds * @bandits.size).to_f)*100.0)}% of the time."
    puts
end

@chances.each do |name,chance|
  @bandits << Bandit.new(name,chance,@cost,@cost*3)
end

@rounds.times do |i|
  @bandits.each do |bandit|
    @ab_kitty += bandit.pull
  end
  #if i % 1000 == 0
      #print "#{i}\t"
      #puts @bandits.scores.collect { |s| sprintf("%0.5f",s) }.join("\t")
  #end
end

summarize "A/B"

@bandits.reset

(@rounds * @bandits.size).times do |i|
  bandit = rand < 0.1 ? @bandits.random : @bandits.best
  @bandit_kitty += bandit.pull
  #if i % (@bandits.size * 1000) == 0
      #print "#{i}\t"
      #puts @bandits.scores.collect { |s| sprintf("%0.5f",s) }.join("\t")
  #end
end

summarize "Bandit"
