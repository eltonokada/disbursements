# lib/tasks/calculate_daily_disbursement.rake

namespace :custom_tasks do
  desc 'Daily Orders disbursement'
  task :daily_disbursement, :environment do
    Merchant.daily_disbursement.each do |merchant|
      OrderDisbursementJob.perform_later(merchant.id, merchant.orders.where(created_at: 1.day.ago.all_day))
    end
  end
end
