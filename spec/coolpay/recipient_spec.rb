# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Recipient' do
  MOCK_API_URL = 'https://private-6d20e-coolpayapi.apiary-mock.com/api'
  RECIPIENT_1_ID = '123abc'
  RECIPIENT_1_NAME = 'R. E. Cipient'
  LIST_API_RESULT = {
    recipients: [
      { id: RECIPIENT_1_ID, name: RECIPIENT_1_NAME }
    ]
  }.freeze
  CREATE_API_RESULT = {
    recipient: { id: RECIPIENT_1_ID, name: RECIPIENT_1_NAME }
  }.freeze
  API_ERROR = { errors: [] }.freeze

  before(:all) do
    Coolpay.api_url = MOCK_API_URL
  end

  before(:each) do
    allow(Coolpay).to receive(:authorize) { true }
  end

  context 'list recipients' do
    it 'makes an API request and returns Recipient objects' do
      expect(Coolpay::APIRequest).to receive(:recipients) { LIST_API_RESULT }
      results = Coolpay::Recipient.list
      expect(results.count).to be 1
      expect(results.first).to be_a(Coolpay::Recipient)
      expect(results.first.id).to match RECIPIENT_1_ID
      expect(results.first.name).to match RECIPIENT_1_NAME
    end

    it 'raises on error or missing data' do
      expect(Coolpay::APIRequest).to receive(:recipients) { API_ERROR }
      expect { Coolpay::Recipient.list }.to raise_error(Coolpay::Error)
      expect(Coolpay::APIRequest).to receive(:recipients) { {} }
      expect { Coolpay::Recipient.list }.to raise_error(Coolpay::Error)
    end
  end

  context 'find recipient' do
    it 'makes an API request and returns a Recipient' do
      expect(Coolpay::APIRequest).to receive(:recipients) { LIST_API_RESULT }
      recipient = Coolpay::Recipient.find(RECIPIENT_1_NAME)
      expect(recipient).to be_a(Coolpay::Recipient)
      expect(recipient.id).to match RECIPIENT_1_ID
      expect(recipient.name).to match RECIPIENT_1_NAME
    end

    it 'raises on error or missing data' do
      expect(Coolpay::APIRequest).to receive(:recipients) { API_ERROR }
      expect do
        Coolpay::Recipient.find(RECIPIENT_1_NAME)
      end.to raise_error(Coolpay::Error)
      expect(Coolpay::APIRequest).to receive(:recipients) { {} }
      expect do
        Coolpay::Recipient.find(RECIPIENT_1_NAME)
      end.to raise_error(Coolpay::Error)
    end
  end

  context 'create recipient' do
    it 'makes an API request and returns the created recipient' do
      expect(Coolpay::APIRequest)
        .to receive(:create_recipient) { CREATE_API_RESULT }
      recipient = Coolpay::Recipient.create(RECIPIENT_1_NAME)
      expect(recipient).to be_a(Coolpay::Recipient)
      expect(recipient.id).to match RECIPIENT_1_ID
      expect(recipient.name).to match RECIPIENT_1_NAME
    end

    it 'raises on error or missing data' do
      expect(Coolpay::APIRequest).to receive(:create_recipient) { API_ERROR }
      expect do
        Coolpay::Recipient.create(RECIPIENT_1_NAME)
      end.to raise_error(Coolpay::Error)
      expect(Coolpay::APIRequest).to receive(:create_recipient) { {} }
      expect do
        Coolpay::Recipient.create(RECIPIENT_1_NAME)
      end.to raise_error(Coolpay::Error)
    end
  end
end
