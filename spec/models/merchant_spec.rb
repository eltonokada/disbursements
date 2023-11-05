# spec/models/merchant_spec.rb
require 'rails_helper'

RSpec.describe Merchant, type: :model do

  it "defines a scope for daily disbursements" do
    expect(Merchant.daily_disbursement.to_sql).to include("WHERE \"merchants\".\"disbursement_frequency\" = 'DAILY'")
  end

  it "defines a scope for weekly disbursements" do
    expect(Merchant.weekly_disbursement.to_sql).to include("WHERE \"merchants\".\"disbursement_frequency\" = 'WEEKLY'")
  end

  it "defines a scope for filtering merchants by a specific day of the week" do
    day_of_week = 1 # Monday
    expect(Merchant.live_on_weekday_match(day_of_week).to_sql).to include("EXTRACT(DOW FROM live_on) = 1")
  end

  it "returns past day undisbursed orders" do
    merchant = FactoryBot.create(:merchant) # Assuming you have FactoryBot or similar for creating test data
    current_date = Date.today
    order_yesterday = FactoryBot.create(:order, merchant: merchant, created_at: current_date - 1.day)
    order_today = FactoryBot.create(:order, merchant: merchant, created_at: current_date)
    order_two_days_ago = FactoryBot.create(:order, merchant: merchant, created_at: current_date - 2.days)

    undisbursed_orders = merchant.past_day_undisbursed_orders(current_date)

    expect(undisbursed_orders).to include(order_yesterday)
    expect(undisbursed_orders).not_to include(order_today)
    expect(undisbursed_orders).not_to include(order_two_days_ago)
  end

  it "returns past week undisbursed orders" do
    merchant = FactoryBot.create(:merchant)
    current_date = Date.today
    order_last_week = FactoryBot.create(:order, merchant: merchant, created_at: current_date - 7.days)
    order_yesterday = FactoryBot.create(:order, merchant: merchant, created_at: current_date - 1.day)
    order_today = FactoryBot.create(:order, merchant: merchant, created_at: current_date)
    order_two_weeks_ago = FactoryBot.create(:order, merchant: merchant, created_at: current_date - 14.days)

    undisbursed_orders = merchant.past_week_undisbursed_orders(current_date)

    expect(undisbursed_orders).to include(order_last_week)
    expect(undisbursed_orders).to include(order_yesterday)
    expect(undisbursed_orders).not_to include(order_today)
    expect(undisbursed_orders).not_to include(order_two_weeks_ago)
  end
end
