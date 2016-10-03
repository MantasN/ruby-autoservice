# This is the repair report class which contains all the information
# about the completed job and provide methods
# to calculate total price, apply discount and so on
class RepairReport
  attr_reader :car_mileage, :comment

  def initialize
    @completed_jobs = []
    @used_parts = []
  end

  def completed_jobs_count
    @completed_jobs.length
  end

  def used_parts_count
    @used_parts.map(&:quantity).reduce(0, &:+)
  end

  def foreach_completed_job
    @completed_jobs.each { |job| yield(job) }
  end

  def foreach_used_part
    @used_parts.each { |part| yield(part) }
  end

  def add_completed_job(job)
    @completed_jobs.push(job)
  end

  def add_used_part(part)
    @used_parts.push(part)
  end

  def remove_job_at_position(position)
    @completed_jobs.delete_at(position)
  end

  def remove_part_at_position(position)
    @used_parts.delete_at(position)
  end

  def parts_total_prime_price
    @used_parts.map(&:total_prime_price).reduce(0, &:+)
  end

  def total_price
    @completed_jobs.map(&:price).reduce(0, &:+) +
      @used_parts.map(&:total_price).reduce(0, &:+)
  end

  def bill(&discount_block)
    jobs_bill = @completed_jobs.map do |job|
      [job.title, apply_discount(job.price, &discount_block)]
    end.to_h

    parts_bill = @used_parts.map do |part|
      [part.title, apply_discount(part.total_price, &discount_block)]
    end.to_h

    jobs_bill.merge(parts_bill)
  end

  def car_mileage=(car_mileage)
    @car_mileage = car_mileage if car_mileage >= 0
  end

  def comment=(comment)
    @comment = comment unless comment.empty?
  end

  private

  def apply_discount(price)
    return yield price if block_given?
    price
  end
end
