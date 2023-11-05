# frozen_string_literal: true

# app/services/order_disbursement_service.rb
class OrderDisbursementService < BaseService
  def initialize(current_date, merchant_id, order_ids)
    @order_ids = order_ids
    @merchant_id = merchant_id
    @current_date = current_date
  end

  def disburse
    Rails.logger.info("Disburse method for #{@order_ids.count} orders and merchant #{@merchant_id}")

    ActiveRecord::Base.transaction do
      @orders = Order.where(id: @order_ids)
      @disbursement = Disbursement.create!(merchant_id: @merchant_id, net_amount: @orders.sum(&:net_amount).round(2),
                                           collected_fee: @orders.sum(&:fee).round(2), reference: generate_reference,
                                           created_at: @current_date)
      disburse_orders
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error while creating disbursement: #{e.message}")
  end

  private

  def disburse_orders
    Order.where(id: @orders.map(&:id)).update_all(disbursed: true, disbursement_id: @disbursement.id)
  end

  def generate_reference
    "#{Date.current.strftime('%Y%m%d')}_#{SecureRandom.hex(4)}"
  end
end
