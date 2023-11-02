# frozen_string_literal: true
class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.references :merchant, null: false, foreign_key: true
      t.string :merchant_reference
      t.boolean :disbursed, default: false
      t.integer :disbursement_id
      t.decimal :collected_fee, precision: 10, scale: 2
      t.decimal :net_amount, precision: 10, scale: 2
      t.timestamps
    end
  end
end
