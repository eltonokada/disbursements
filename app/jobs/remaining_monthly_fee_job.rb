# frozen_string_literal: true

# app/jobs/order_disbursement_job.rb
class RemainingMonthlyFeeJob < ApplicationJob
  queue_as :default

  def perform
    Merchant.all.each do |merchant|
      RemainingMonthlyFeeService.new(merchant).calculate
    end
  rescue StandardError => e
    Rails.logger.error("Error while calculating remaining monthly fees: #{e.message}")
  end

  def after_perform
    Merchant.all.each do |merchant|
      OrderDisbursementJob.perform(merchant.id, merchant.undisbursed_orders(current_date).pluck(:id))
    end
  end
end
