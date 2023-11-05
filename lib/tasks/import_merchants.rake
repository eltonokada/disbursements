# frozen_string_literal: true

require 'csv'

# lib/tasks/import_merchants.rake
namespace :custom_tasks do
  # this tasks should run daily
  desc 'Import Merchants'
  task import_merchants: [:environment] do
    CSV.foreach('lib/assets/merchants.csv', headers: true, col_sep: ';') do |row|
      Merchant.create!(reference: row['reference'], email: row['email'],
                       minimum_monthly_fee: row['minimum_monthly_fee'],
                       disbursement_frequency: row['disbursement_frequency'],
                       live_on: row['live_on'])
    end
  end
end
