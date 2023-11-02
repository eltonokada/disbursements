# frozen_string_literal: true

# app/models/merchant.rb
class Merchant < ApplicationRecord
  has_many :orders
  has_many :disbursements

  scope :daily_disbursement, -> { where(disbursement_frequency: 'DAILY') }
  scope :weekly_disbursement, -> { where(disbursement_frequency: 'WEEKLY') }

  scope :live_on_weekday_match_today, lambda {
    where("strftime('%w', live_on) = ?", Date.today.wday.to_s)
  }
end
