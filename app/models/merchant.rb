# frozen_string_literal: true

# app/models/merchant.rb
class Merchant < ApplicationRecord
  has_many :orders
  has_many :disbursements

  scope :daily_disbursement, -> { where(disbursement_frequency: 'DAILY') }
  scope :weekly_disbursement, -> { where(disbursement_frequency: 'WEEKLY') }
  scope :live_on_weekday_match, ->(day_of_week) { where('EXTRACT(DOW FROM live_on) = ?', day_of_week) }

  def past_day_undisbursed_orders(current_date)
    orders.undisbursed.where(created_at: (current_date - 1.day).all_day)
  end

  def past_week_undisbursed_orders(current_date)
    start_date = current_date - 7.days
    end_date = current_date - 1.day

    orders.undisbursed.where('orders.created_at BETWEEN ? AND ?', start_date.beginning_of_day, end_date.end_of_day)
  end
end
