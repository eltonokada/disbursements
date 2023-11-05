# frozen_string_literal: true

# app/jobs/order_disbursement_job.rb
class RemainingMonthlyFeeJob < ApplicationJob
  queue_as :default

  def perform(current_date)
    Rails.logger.info("Calculating remaining monthly fees for #{current_date}")
    Merchant.all.each do |merchant|
      RemainingMonthlyFeeService.new(current_date, merchant).calculate
    end
  rescue StandardError => e
    Rails.logger.error("Error while calculating remaining monthly fees: #{e.message}")
  end

  def after_perform
    DailyDisbursementJob.perform(current_date)
    WeeklyDisbursementJob.perform(current_date)
  end
end
