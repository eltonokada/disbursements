# spec/models/order_spec.rb

require 'rails_helper'
RSpec.describe Order, type: :model do
  let(:order) { FactoryBot.create(:order) }
  let(:merchant) { FactoryBot.create(:merchant) }

  it 'is valid with valid attributes' do
    expect(order).to be_valid
  end

  it 'is not valid without an amount' do
    order.amount = nil
    expect(order).to_not be_valid
  end

  it 'return 1.00 % fee for orders with an amount strictly smaller than 50' do
    order.amount = 20.00
    expect(order.fee).to eq(20 * 0.01)
  end

  it 'return 0.95 % fee for orders with an amount = 50' do
    order.amount = 50.00
    expect(order.fee).to eq(50 * 0.0095)
  end

  it 'return 0.95 % fee for orders with an amount between 50 € and 300 €' do
    order.amount = 100
    expect(order.fee).to eq(100 * 0.0095)
  end

  it 'return 0.85 % fee for orders with an amount = 300' do
    order.amount = 300
    expect(order.fee).to eq(300 * 0.0085)
  end

  it 'return 0.85 % fee for orders with an amount of 300 € or more' do
    order.amount = 500
    expect(order.fee).to eq(500 * 0.0085)
  end
end
