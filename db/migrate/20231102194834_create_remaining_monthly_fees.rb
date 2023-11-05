# frozen_string_literal: true

# app/services/remaining_monthly_fee_service.rb
class CreateRemainingMonthlyFees < ActiveRecord::Migration[7.1]
  def change
    create_table :remaining_monthly_fees do |t|
      t.integer :merchant_id
      t.decimal :fee, precision: 10, scale: 2

      t.timestamps
    end
  end
end
