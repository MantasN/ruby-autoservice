# This is the repair report class which contains all the information
# about the completed job and provide methods
# to calculate total price, apply discount and so on
class Report < ApplicationRecord
  belongs_to :order, inverse_of: :report
  has_many :jobs, dependent: :destroy
  has_many :parts, dependent: :destroy
  after_initialize :show_prime_for_new
  validates :car_mileage,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :hide_prime, inclusion: { in: [true, false] }
  validates :hide_prime, exclusion: { in: [nil] }

  def hide_prime_prices
    self.hide_prime = true
  end

  def show_prime_prices
    self.hide_prime = false
  end

  def completed_jobs_count
    jobs.length
  end

  def used_parts_count
    parts.map(&:quantity).reduce(0, &:+)
  end

  def foreach_completed_job
    jobs.each { |job| yield(job) }
  end

  def foreach_used_part
    parts.each { |part| yield(part) }
  end

  def add_completed_job(job)
    jobs.concat(job)
  end

  def add_used_part(part)
    parts.concat(part)
  end

  def remove_job(job)
    jobs.delete(job)
  end

  def remove_part(part)
    parts.delete(part)
  end

  def parts_total_prime_price
    if !hide_prime
      parts.map(&:total_prime_price).reduce(0, &:+)
    else
      parts.map(&:total_price).reduce(0, &:+)
    end
  end

  def total_price
    jobs.map(&:price).reduce(0, &:+) +
      parts.map(&:total_price).reduce(0, &:+)
  end

  def bill(&discount_block)
    jobs_bill = jobs.map do |job|
      [job.title, apply_discount(job.price, &discount_block)]
    end.to_h

    parts_bill = parts.map do |part|
      [part.title, apply_discount(part.total_price, &discount_block)]
    end.to_h

    jobs_bill.merge(parts_bill)
  end

  private

  def apply_discount(price)
    return yield price if block_given?
    price
  end

  def show_prime_for_new
    self.hide_prime = false if new_record?
  end
end
