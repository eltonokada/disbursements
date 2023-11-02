# frozen_string_literal: true

# app/models/order.rb
class Order < ApplicationRecord
  validates_presence_of :amount, :merchant_id
  belongs_to :merchant
  belongs_to :disbursement, optional: true
  scope :undisbursed, -> { where(disbursed: false) }

  def fee
    return amount * 0.01 if amount < 50
    return amount * 0.0095 if amount >= 50 && amount <= 300

    amount * 0.0085
  end

  def net_amount
    amount - fee
  end
end
