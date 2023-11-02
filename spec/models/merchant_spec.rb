# spec/models/merchant_spec.rb

require 'rails_helper'
RSpec.describe Merchant, type: :model do

  let(:merchant1) { FactoryBot.create(:merchant, live_on: '2022-10-06') }
  let(:merchant2) { FactoryBot.create(:merchant, live_on: '2022-03-01') }
  it 'return merchants where live on weekday equals today' do

    p merchant1.live_on.to_date.wday
    p Date.today.wday
    # p Date.today.wday
    expect(Merchant.live_on_weekday_match_today).to eq([merchant1])
  end
end
