# lib/tasks/calculate_daily_disbursement.rake

namespace :custom_tasks do
  desc 'Orders disbursement'
  task :orders_disbursement, :environment do
    Merchant.where(disbursement_frequency: 'DAILY').each do |merchant|
      OrderDisbursementJob.perform_later(merchant.id, merchant.orders.undisbursed)
    end
  end
end
