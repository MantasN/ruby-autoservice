# This is the repair report class which contains all the information
# about the completed job and provide methods
# to calculate total price, apply discount and so on
class Report < ApplicationRecord
  belongs_to :order
  has_many :jobs, dependent: :destroy
  has_many :parts, dependent: :destroy

  def completed_jobs_count
    self.jobs.length
  end

  def used_parts_count
    self.parts.map(&:quantity).reduce(0, &:+)
  end

  def foreach_completed_job
    self.jobs.each { |job| yield(job) }
  end

  def foreach_used_part
    self.parts.each { |part| yield(part) }
  end

  def add_completed_job(job)
    self.jobs.concat(job)
  end

  def add_used_part(part)
    self.parts.concat(part)
  end

  def remove_job(job)
    self.jobs.delete(job)
  end

  def remove_part(part)
    self.parts.delete(part)
  end

  def parts_total_prime_price
    self.parts.map(&:total_prime_price).reduce(0, &:+)
  end

  def total_price
    self.jobs.map(&:price).reduce(0, &:+) +
        self.parts.map(&:total_price).reduce(0, &:+)
  end

  def bill(&discount_block)
    jobs_bill = self.jobs.map do |job|
      [job.title, apply_discount(job.price, &discount_block)]
    end.to_h

    parts_bill = self.parts.map do |part|
      [part.title, apply_discount(part.total_price, &discount_block)]
    end.to_h

    jobs_bill.merge(parts_bill)
  end

  def car_mileage=(car_mileage)
    super(car_mileage) if car_mileage >= 0
  end

  def comment=(comment)
    super(comment) unless comment.empty?
  end

  private

  def apply_discount(price)
    return yield price if block_given?
    price
  end
end
