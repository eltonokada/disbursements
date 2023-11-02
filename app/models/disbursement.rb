class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates_presence_of :merchant_id, :net_amount, :collected_fee
end
