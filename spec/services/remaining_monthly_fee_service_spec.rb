# frozen_string_literal: true

# disbursement_calculator_service_spec.rb

require 'rails_helper'

RSpec.describe RemainingMonthlyFeeService do
  let(:merchant) { FactoryBot.create(:merchant_with_195_remaining_monthly_fee) }
  let(:merchant_without_remaining_fee) { FactoryBot.create(:merchant_without_remaining_fee) }

  describe '#calculate' do
    context 'when valid' do
      it 'creates a monthly fee when minimum monthly fee not achieved' do
        RemainingMonthlyFeeService.new(merchant).calculate
        expect(RemainingMonthlyFee.count).to eq(1)
      end
      it 'creates a monthly fee when remaining fee 195' do
        RemainingMonthlyFeeService.new(merchant_without_remaining_fee).calculate
        expect(RemainingMonthlyFee.count).to eq(0)
      end
    end
    context 'when invalid' do
      it 'logs an error if record creation fails' do
        allow(RemainingMonthlyFee).to receive(:create).and_raise(ActiveRecord::RecordInvalid)

        expect(Rails.logger).to receive(:error)

        described_class.new(merchant).calculate
      end
    end
  end
end
