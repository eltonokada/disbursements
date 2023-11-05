# create factory for merchants
FactoryBot.define do

  factory :merchant do
    reference { 'MyString' }
    email { 'MyString' }
    live_on { '2021-10-30 23:00:28'  }
    disbursement_frequency { 'DAILY' }
    minimum_monthly_fee { '9.99' }

    factory :merchant_with_195_remaining_monthly_fee do
      minimum_monthly_fee { '200.00' }
      after(:create) do |merchant|
        create_list(:order, 5, merchant_id: merchant.id, disbursed: true, collected_fee: 1.00, created_at: 1.month.ago)
      end
    end

    factory :merchant_without_remaining_fee do
      minimum_monthly_fee { '100.00' }
      after(:create) do |merchant|
        create_list(:order, 5, merchant_id: merchant.id, disbursed: true, collected_fee: 20.00, created_at: 1.month.ago)
      end
    end

    factory :merchant_with_daily_disbursement_orders do
      after(:create) do |merchant|
        create_list(:order, 10, merchant_id: merchant.id, disbursed: false, created_at: 1.day.ago, amount: 100.00)
      end
    end
  end
end
