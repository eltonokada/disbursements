# create factory for merchants
FactoryBot.define do
  factory :merchant do
    reference { 'MyString' }
    email { 'MyString' }
    live_on { '2021-10-30 23:00:28'  }
    disbursement_frequency { 'MyString' }
    minimum_monthly_fee { '9.99' }
  end
end
