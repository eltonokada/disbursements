# spec/models/disbursement_spec.rb
require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  let(:merchant) { FactoryBot.create(:merchant) }

  it 'is valid with valid attributes' do
    disbursement = Disbursement.new(merchant: merchant, net_amount: 100.0, collected_fee: 10.0)
    expect(disbursement).to be_valid
  end

  it 'is not valid without a merchant' do
    disbursement = Disbursement.new(net_amount: 100.0, collected_fee: 10.0)
    expect(disbursement).not_to be_valid
  end

  it 'is not valid without net_amount' do
    disbursement = Disbursement.new(merchant: merchant, collected_fee: 10.0)
    expect(disbursement).not_to be_valid
  end

  it 'is not valid without collected_fee' do
    disbursement = Disbursement.new(merchant: merchant, net_amount: 100.0)
    expect(disbursement).not_to be_valid
  end

  it 'is associated with a merchant' do
    disbursement = Disbursement.new(merchant: merchant, net_amount: 100.0, collected_fee: 10.0)
    expect(disbursement.merchant).to eq(merchant)
  end

  it 'can have multiple orders' do
    disbursement = Disbursement.new(merchant: merchant, net_amount: 100.0, collected_fee: 10.0)
    order1 = disbursement.orders.build(id: '12345', amount: 50.0)
    order2 = disbursement.orders.build(id: '67890', amount: 60.0)

    expect(disbursement.orders).to include(order1)
    expect(disbursement.orders).to include(order2)
  end
end
