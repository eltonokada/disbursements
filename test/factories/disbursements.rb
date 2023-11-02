 FactoryBot.define do
  factory :disbursement do
    merchant_id { FactoryBot.create(:merchant).id }
    net_amount { 500 }
    collected_fee { 10 }
    created_at { Time.zone.now }
  end
end