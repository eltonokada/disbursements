# frozen_string_literal: true

require 'csv'

# lib/tasks/import_merchants.rake
namespace :custom_tasks do
  desc 'Create previous Disbursements'
  task run_disbursement_jobs: [:environment] do
    current_date = Date.today

    if current_date.today.day == 1
      RemainingMonthlyFeeJob.perform_later(current_date)
    else
      DailyDisbursementJob.perform_later(current_date)
      WeeklyDisbursementJob.perform_later(current_date)
    end
    #RemainingMonthlyFeeJob.perform_later
    #Order.all.group('orders.created_at').count.each do |order|
    #  current_date = order[0]
      # Merchant.daily_disbursement.each do |merchant|
      #   orders = merchant.past_day_undisbursed_orders(current_date.to_date)
      #   next unless orders.count.positive?

      #   OrderDisbursementJob.perform_later(merchant.id, orders.pluck(:id))
      # end


      # Merchant.weekly_disbursement.live_on_weekday_match(current_date.wday).each do |merchant|
      #   orders = merchant.past_week_undisbursed_orders(current_date.to_date)

      #   next unless orders.count.positive?

      #   p " ENTROU = merchan #{merchant.id}"
      #   p "date #{current_date.to_date}"
      #   p orders.pluck(:id)
      #   OrderDisbursementJob.perform_later(merchant.id, orders.pluck(:id))
      # end
      

   # end
  end
end
