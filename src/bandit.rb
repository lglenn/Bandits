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
    @pulls = 1.0
    @rewards = 1.0
  end

  def to_s
    @name
  end

  def name
    @name
  end

  def pull
    @pulls += 1
    if rand < @chance
      reward
      return true
    else
      return false
    end
  end

  def reward
    @rewards += 1
  end

  def score
    @rewards / @pulls
  end

end

