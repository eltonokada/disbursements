# frozen_string_literal: true

# disbursement_calculator_service_spec.rb

require 'rails_helper'

RSpec.describe OrderDisbursementService do
  let(:merchant) { FactoryBot.create(:merchant, disbursement_frequency: 'DAILY') }
  let(:order) { FactoryBot.create(:order, merchant_id: merchant.id, amount: 500) }
  let(:orders) { FactoryBot.create_list(:order, 3, amount: 100, merchant_id: merchant.id) }

  describe '#calculate_disbursement' do
    context 'when valid' do
      it 'creates a disbursement' do
        expect { OrderDisbursementService.new(merchant.id, orders).disburse }.to change { Disbursement.count }.by(1)
      end

      it 'creates a disbursement with sum of orders net_amount' do
        gross_amount = orders.map(&:amount).sum
        net_amount = gross_amount - (gross_amount * 0.0095)
        OrderDisbursementService.new(merchant.id, orders).disburse

        expect(Disbursement.last.net_amount).to eq(net_amount)
      end

      it 'should update order net amount and fee' do
        OrderDisbursementService.new(merchant.id, [order]).disburse

        expect(order.reload.disbursed_amount).to eq(order.net_amount)
        expect(order.reload.collected_fee).to eq(order.fee)
      end

      it 'should disburse order' do
        OrderDisbursementService.new(merchant.id, [order]).disburse
        expect(order.reload.disbursed).to eq(true)
      end
    end

    context 'when invalid' do
      it 'returns an error if the disbursement is not created' do
        allow_any_instance_of(Disbursement).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)
        service = OrderDisbursementService.new(merchant.id, orders)
        allow(Rails.logger).to receive(:error)

        expect { service.disburse }.to_not raise_error

        expect(Rails.logger).to have_received(:error).with(/Error while creating disbursement/)
      end
    end
  end
end
