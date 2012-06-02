class Kitty

  attr_reader :balance

  def initialize(balance)
    @balance = balance
    @starting_balance = @balance
  end

  def +(amount)
    @balance += amount
    self
  end

  def -(amount)
    @balance -= amount
    self
  end

  def loss
    @starting_balance - @balance
  end

  def reset
      @balance = @starting_balance
  end

end
