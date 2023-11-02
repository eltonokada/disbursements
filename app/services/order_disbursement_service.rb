# frozen_string_literal: true

# app/services/order_disbursement_service.rb
class OrderDisbursementService < BaseService
  def initialize(merchant_id, orders)
    @orders = orders
    @merchant_id = merchant_id
  end

  def disburse
    ActiveRecord::Base.transaction do
      @disbursement = Disbursement.create!(merchant_id: @merchant_id, net_amount: @orders.sum(&:net_amount).round(2),
                                           collected_fee: @orders.sum(&:fee).round(2), reference: generate_reference)
      @orders.each do |order|
        @disbursement.orders << order
        order.update!(disbursed: true, disbursed_amount: order.net_amount, collected_fee: order.fee)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error while creating disbursement: #{e.message}")
  end

  private

  def generate_reference
    "#{Date.current.strftime('%Y%m%d')}_#{SecureRandom.hex(4)}"
  end
end
