# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Payment' do
  MOCK_API_URL = 'https://private-6d20e-coolpayapi.apiary-mock.com/api'
  PAYMENT_1_ID = '111aaa'
  PAYMENT_1_RECIPIENT_ID = '222bbb'
  PAYMENT_1_AMOUNT = 12.75
  PAYMENT_1_CURRENCY = :gbp
  LIST_API_RESULT = {
    payments: [
      {
        id: PAYMENT_1_ID,
        recipient_id: PAYMENT_1_RECIPIENT_ID,
        amount: PAYMENT_1_AMOUNT.to_s,
        currency: PAYMENT_1_CURRENCY.to_s.upcase
      }
    ]
  }.freeze
  CREATE_ARGS = {
    recipient: PAYMENT_1_RECIPIENT_ID,
    amount: PAYMENT_1_AMOUNT,
    currency: PAYMENT_1_CURRENCY
  }.freeze
  CREATE_API_RESULT = {
    payment: {
      id: PAYMENT_1_ID,
      recipient_id: PAYMENT_1_RECIPIENT_ID,
      amount: PAYMENT_1_AMOUNT.to_s,
      currency: PAYMENT_1_CURRENCY.to_s.upcase
    }
  }.freeze
  API_ERROR = { errors: [] }.freeze

  before(:all) do
    Coolpay.api_url = MOCK_API_URL
  end

  before(:each) do
    allow(Coolpay).to receive(:authorize) { true }
  end

  context 'list payments' do
    it 'makes an API request and returns Payment objects' do
      expect(Coolpay::APIRequest).to receive(:payments) { LIST_API_RESULT }
      results = Coolpay::Payment.list
      STDERR.puts results.inspect
      expect(results.count).to be 1
      expect(results.first).to be_a(Coolpay::Payment)
      expect(results.first.id).to match PAYMENT_1_ID
      expect(results.first.recipient_id).to match PAYMENT_1_RECIPIENT_ID
      expect(results.first.amount).to be PAYMENT_1_AMOUNT
      expect(results.first.string_amount).to match PAYMENT_1_AMOUNT.to_s
      expect(results.first.currency).to be PAYMENT_1_CURRENCY
    end

    it 'raises on error or missing data' do
      expect(Coolpay::APIRequest).to receive(:payments) { API_ERROR }
      expect { Coolpay::Payment.list }.to raise_error(Coolpay::Error)
      expect(Coolpay::APIRequest).to receive(:payments) { {} }
      expect { Coolpay::Payment.list }.to raise_error(Coolpay::Error)
    end
  end

  context 'create payment' do
    it 'makes an API request and returns the created payment' do
      expect(Coolpay::APIRequest)
        .to receive(:create_payment) { CREATE_API_RESULT }
      payment = Coolpay::Payment.create(CREATE_ARGS)
      expect(payment).to be_a(Coolpay::Payment)
      expect(payment.id).to match PAYMENT_1_ID
      expect(payment.recipient_id).to match PAYMENT_1_RECIPIENT_ID
      expect(payment.amount).to be PAYMENT_1_AMOUNT
      expect(payment.string_amount).to match PAYMENT_1_AMOUNT.to_s
      expect(payment.currency).to be PAYMENT_1_CURRENCY
    end

    it 'raises on error or missing data' do
      expect(Coolpay::APIRequest).to receive(:create_payment) { API_ERROR }
      expect do
        Coolpay::Payment.create(CREATE_ARGS)
      end.to raise_error(Coolpay::Error)
      expect(Coolpay::APIRequest).to receive(:create_payment) { {} }
      expect do
        Coolpay::Payment.create(CREATE_ARGS)
      end.to raise_error(Coolpay::Error)
    end
  end
end
