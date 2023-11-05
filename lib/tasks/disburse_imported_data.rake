# frozen_string_literal: true

require 'csv'

# lib/tasks/import_orders.rake
namespace :sequra do
  # This task handle the disbursement of previous dates
  desc 'Disburse previous dates'
  task disburse_imported_data: [:environment] do
    Order.all.group('orders.created_at').count.each do |order|
      current_date = order[0]

      # Run remaining monthly fee job after
      # RemainingMonthlyFeeJob.perform_later(current_date)
      DailyDisbursementJob.perform_later(current_date)
      WeeklyDisbursementJob.perform_later(current_date)
    end
  end
end
