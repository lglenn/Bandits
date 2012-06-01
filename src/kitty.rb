class Kitty

  attr_reader :balance

  def initialize(balance)
    @balance = balance
    @starting_balance = @balance
  end

  def win(amount)
    @balance += amount
  end

  def lose(amount)
    @balance -= amount
  end

  def loss
    @starting_balance - @balance
  end

end
