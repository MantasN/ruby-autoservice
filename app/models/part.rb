# This is the repair part class which contains the
# title, quantity, prime_price and client_price of the used part
class Part < ApplicationRecord
  belongs_to :report
  validates :title, presence: true
  validates :prime_price, :client_price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def total_prime_price
    self.quantity * self.prime_price
  end

  def total_price
    self.quantity * self.client_price
  end
end
