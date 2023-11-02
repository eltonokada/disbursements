# lib/tasks/calculate_weekly_disbursement.rake

namespace :custom_tasks do
  desc 'Weekly orders disbursement'
  task :weekly_disbursement, :environment do
    Merchant.weekly_disbursement.live_on_weekday_match_today.each do |merchant|
      OrderDisbursementJob.perform_later(merchant.id, merchant.orders.undisbursed.where(created_at: 1.week.ago.all_day))
    end
  end
end
