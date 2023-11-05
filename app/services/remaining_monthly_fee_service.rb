# frozen_string_literal: true

# app/services/remaining_monthly_fee_service.rb
class RemainingMonthlyFeeService < BaseService
  def initialize(current_date, merchant)
    @merchant = merchant
    @current_date = current_date
  end

  def calculate
    remaining_monthly_fees = @merchant.remaining_monthly_fees
    return unless remaining_monthly_fees.positive?

    RemainingMonthlyFee.create(created_at: @current_date, merchant_id: @merchant.id, fee: remaining_monthly_fees)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error while creating remaining monthly fee: #{e.message}")
  end
end
