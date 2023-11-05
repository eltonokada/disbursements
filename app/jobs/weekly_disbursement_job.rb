# frozen_string_literal: true

# app/jobs/weekly_disbursement_job.rb
class WeeklyDisbursementJob < ApplicationJob
  queue_as :default

  def perform(current_date)
    Rails.logger.info("Calculating weekly disbursement for #{current_date}")
    Merchant.weekly_disbursement.live_on_weekday_match(current_date.wday).each do |merchant|
      orders = merchant.past_week_undisbursed_orders(current_date)
      next if orders.count.zero?

      OrderDisbursementJob.perform_later(current_date, merchant.id,
                                         orders.pluck(:id))
    end
  rescue StandardError => e
    Rails.logger.error("Error while calculating daily disbursement: #{e.message}")
  end
end
