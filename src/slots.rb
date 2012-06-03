require 'bandit'
require 'kitty'

@chances = { 'a' => 0.02, 'b' => 0.0203 }
@bandits = Bandits.new
@trials = 8000001
@print_interval = 100000

def summarize(name)
  puts "Doing a #{name} test, you've found that #{@bandits.best.name} is the best machine, with a score of #{sprintf("%0.5f",@bandits.best.score)}."
  puts "The winning bandit was pulled #{@bandits.best.pulls} times out of #{@trials} trials, or #{sprintf("%.0f",(@bandits.best.pulls.to_f/@trials.to_f)*100.0)}% of the time."
  puts
end

def writestats(i,report)
  tuple = [i]
  @bandits.each do |b|
    tuple << sprintf("%0.6f",b.score)
    tuple << b.pulls
  end
  report.write(tuple.join("\t"))
  report.write("\n")
end

@chances.each do |name,chance|
  @bandits << Bandit.new(name,chance)
end

report = File.open("./ab.dat","w")
i = 0
while i < @trials
  @bandits.each do |bandit|
    bandit.pull
    i += 1
  end
  if i % @print_interval == 0
    writestats(i,report)
  end
end

summarize "A/B"

@bandits.reset
i = 0
report = File.open("./bandit.dat","w")

while i < @trials
  bandit = rand < 0.1 ? @bandits.random : @bandits.best
  bandit.pull
  i += 1
  if i % @print_interval == 0
    writestats(i,report)
  end
end

summarize "Bandit"
