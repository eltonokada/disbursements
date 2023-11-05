# frozen_string_literal: true

# app/jobs/order_disbursement_job.rb
class OrderDisbursementJob < ApplicationJob
  queue_as :default

  def perform(current_date, merchant_id, order_ids)
    Rails.logger.info("Calculating disbursement for #{order_ids.count} orders and merchant #{merchant_id}")

    OrderDisbursementService.new(current_date, merchant_id, order_ids).disburse
  rescue StandardError => e
    Rails.logger.error("Error while calculating daily disbursement: #{e.message}")
  end
end
