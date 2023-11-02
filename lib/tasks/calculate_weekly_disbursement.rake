
# lib/tasks/calculate_daily_disbursement.rake

namespace :custom_tasks do
  desc 'Calculate disbursement'
  task :calculate_disbursement, [:frequency] => :environment do |args|
    frequency = args[:frequency] || 'WEEKLY'
    # BUSCAR O DIA DA SEMANA DE HOJE
    # PEGAR TODOS OS MERCHANTS QUE TIVEREM O LIVE_ON COM O DIA DA SEMANA IGUAL AO DIA DE HOJE
    #
    # CALCULAR O DISBURSEMENT DELES


    Merchant.where(disbursement_frequency: frequency).each do |merchant|
      DisbursementCalculatorJob.perform_later(merchant.id, merchant.orders.undisbursed)
    end
  end
end
