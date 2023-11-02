# frozen_string_literal: true

# app/jobs/order_disbursement_job.rb
class OrderDisbursementJob < ApplicationJob
  def perform(merchant_id, orders)
    Rails.logger.info("Calculating daily disbursement for #{orders.count} orders and merchant #{merchant_id}")
    begin
      OrderDisbursementService.new(merchant_id, orders).disburse
    rescue StandardError => e
      Rails.logger.error("Error while calculating daily disbursement: #{e.message}")
    end
    Rails.logger.info('Daily disbursement calculation finished')
  end
end
