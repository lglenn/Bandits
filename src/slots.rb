@chances = { 'a' => 0.01, 'b' => 0.01, 'c' => 0.01, 'd' => 0.02 }
@bandits = []
@kitty = 20000 * 25 * @chances.size
@initial_kitty = @kitty

@chances.each do |name,chance|
  @bandits << Bandit.new(name,chance)
end

20000.times do |i|
  @bandits.each do |bandit|
    @kitty -= 25
    if bandit.pull
      @kitty += 50
    end
  end
end

def scores
  @bandits.collect { |bandit| "#{bandit}: #{sprintf("%0.3f",bandit.score)}" }.join(' ')
end

@loss = @initial_kitty - @kitty

puts "Doing an A/B test, you've found that the scores are: [#{scores}]. And, the test cost you $#{sprintf("%0.2f",@loss / 100.0)}!"

@bandits.each { |b| b.reset }

def pick_bandit
  max = -1
  ret = nil
  @bandits.each do |bandit|
    if bandit.score > max
      max = bandit.score
      ret = bandit
    end
  end
  return ret
end

@kitty = 20000 * 25 * @chances.size

80000.times do |i|
  bandit = rand < 0.1 ? @bandits[rand(4)] : pick_bandit
  @kitty -= 25
  if bandit.pull
    @kitty += 50
  end
end

@loss = @initial_kitty - @kitty

puts "Using a bandit algorithm, you've found that the scores are: [#{scores}]. And, the test cost you $#{sprintf("%0.2f",@loss / 100.0)}!"
