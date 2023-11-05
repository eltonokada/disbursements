# frozen_string_literal: true

# app/jobs/order_disbursement_job.rb
class DailyDisbursementJob < ApplicationJob
  queue_as :default

  def perform(current_date)
    Rails.logger.info("Calculating daily disbursement for #{current_date}")
    Merchant.daily_disbursement.each do |merchant|
      orders = merchant.past_day_undisbursed_orders(current_date)
      next if orders.count.zero?

      OrderDisbursementJob.perform_later(current_date, merchant.id, orders.pluck(:id))
    end
  rescue StandardError => e
    Rails.logger.error("Error while calculating daily disbursement: #{e.message}")
  end
end
