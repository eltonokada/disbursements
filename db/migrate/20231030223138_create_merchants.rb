class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants do |t|
      t.string :reference, index: true
      t.string :email
      t.datetime :live_on
      t.string :disbursement_frequency
      t.decimal :minimum_monthly_fee, precision: 10, scale: 2
    end
  end
end
