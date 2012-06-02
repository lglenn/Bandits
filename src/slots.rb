require 'bandit'
require 'kitty'

@chances = { 'a' => 0.02, 'b' => 0.0802 }
@bandits = Bandits.new
@rounds = 1000000
@cost = 25
@ab_kitty = Kitty.new(@rounds * @cost * @bandits.size)
@bandit_kitty = Kitty.new(@rounds * @cost * @bandits.size)

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

puts "Doing an A/B test, you've found that the scores are: [#{@bandits.scores}]. And, the test cost you $#{sprintf("%0.2f",@ab_kitty.loss / 100.0)}!"

@bandits.reset

(@rounds * @bandits.size).times do |i|
  bandit = rand < 0.1 ? @bandits.random : @bandits.best
  @bandit_kitty += bandit.pull
  #if i % (@bandits.size * 1000) == 0
      #print "#{i}\t"
      #puts @bandits.scores.collect { |s| sprintf("%0.5f",s) }.join("\t")
  #end
end

puts "Using a bandit algorithm, you've found that the scores are: [#{@bandits.scores}]. And, the test cost you $#{sprintf("%0.2f",@bandit_kitty.loss / 100.0)}!"

diff = (@ab_kitty.balance - @bandit_kitty.balance)/@ab_kitty.balance.to_f

puts "Your savings were #{sprintf("%0.1f",diff * 100)}%."
