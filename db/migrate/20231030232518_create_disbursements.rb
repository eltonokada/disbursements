class CreateDisbursements < ActiveRecord::Migration[7.1]
  def change
    create_table :disbursements do |t|
      t.decimal :net_amount, precision: 10, scale: 2
      t.decimal :collected_fee, precision: 10, scale: 2
      t.references :merchant, null: false, foreign_key: true
      t.string :reference
      t.datetime :created_at
    end
  end
end
