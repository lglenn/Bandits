class Bandits

  def initialize
    @bandits = []
  end

  def <<(bandit)
    @bandits << bandit
  end

  def each
    @bandits.each do |b|
      yield b
    end
  end

  def size
    @bandits.size
  end

  def names
    @bandits.collect { |b| b.name }
  end

  def random
    @bandits[rand(@bandits.size)]
  end

  def best
    @bandits.reduce { |best,bandit| best = bandit.score > best.score ? bandit : best }
  end

end

class Bandit

  def initialize(name,chance)
    @name = name
    @chance = chance
    reset
  end

  def reset
    @pulls = 0
    @rewards = 0
  end

  def to_s
    @name
  end

  def name
    @name
  end

  def pulls
    @pulls
  end

  def wins
    @rewards
  end

  def pull
    @pulls += 1
    if rand < @chance
      @rewards += 1
      return true
    else
      return false
    end
  end

  def score
    @pulls == 0 ? 0 : @rewards.to_f / @pulls.to_f
  end

end

