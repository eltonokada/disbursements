# frozen_string_literal: true

require 'csv'
# This task disburse orders base in merchant disbursement frequency
# lib/tasks/import_merchants.rake
namespace :custom_tasks do
  desc 'Create previous Disbursements'
  task disburse_orders: [:environment] do
    current_date = Date.today
    # if is the first day of the month, we need to ensure that remaining monthly fee is calculated
    # daily and weekly jobs for merchants only run if remaining fees calculations are done
    # these 2 jobs are called on remaining monthly fee job after_perform

    Rails.logger.info("Disbursing orders for #{current_date}")
    if current_date.today.day == 1
      RemainingMonthlyFeeJob.perform(current_date)
    else
      DailyDisbursementJob.perform(current_date)
      WeeklyDisbursementJob.perform(current_date)
    end
    Rails.logger.info("Orders for #{current_date} sent to sidekiq to be disbursed")
  end
end
