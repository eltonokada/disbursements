# spec/factories/orders.rb

FactoryBot.define do
  factory :order do
    merchant_id { FactoryBot.create(:merchant).id }
    amount { 500 }
    created_at { Time.zone.now }
  end
end
