# frozen_string_literal: true

# app/services/remaining_monthly_fee_service.rb
class RemainingMonthlyFeeService < BaseService
  def initialize(merchant)
    @merchant = merchant
  end

  def calculate
    return unless remaining_monthly_fees.positive?

    RemainingMonthlyFee.create(merchant_id: @merchant.id, fee: remaining_monthly_fees)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error while creating remaining monthly fee: #{e.message}")
  end

  private

  def remaining_monthly_fees
    start_date = Date.today.prev_month.beginning_of_month
    end_date = Date.today.prev_month.end_of_month

    collected_fee = @merchant.orders.where('created_at BETWEEN ? AND ?', start_date, end_date).sum(:collected_fee)
    (@merchant.minimum_monthly_fee - collected_fee).round(2)
  end
end
