# frozen_string_literal: true

# app/models/disbursement.rb
class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates_presence_of :merchant_id, :net_amount, :collected_fee
end
