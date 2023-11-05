# frozen_string_literal: true

require 'csv'

# lib/tasks/import_orders.rake
namespace :custom_tasks do
  # this tasks should run daily
  desc 'Import Merchants'
  task import_orders: [:environment] do
    CSV.foreach('lib/assets/orders.csv', headers: true, col_sep: ';') do |row|
      merchant = Merchant.find(row['reference'])
      Order.create!(merchant_reference: row['reference'], amount: row['amount'],
                    merchant_id: merchant.id, created_at: row['created_at'])
    end
  end
end
