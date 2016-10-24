# This is the repair part class which contains the
# title, quantity, prime_price and client_price of the used part
class RepairPart
  attr_reader :title, :quantity, :prime_price, :client_price

  def initialize(title, quantity, prime_price, client_price)
    @title = title
    @quantity = quantity
    @prime_price = prime_price
    @client_price = client_price
  end

  def total_prime_price
    @quantity * @prime_price
  end

  def total_price
    @quantity * @client_price
  end
end
