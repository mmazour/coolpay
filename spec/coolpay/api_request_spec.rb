# frozen_string_literal: true

require 'spec_helper'
require 'vcr'

RSpec.describe 'APIRequest' do
  MOCK_API_URL = 'https://private-6d20e-coolpayapi.apiary-mock.com/api'
  MOCK_USERNAME = 'your_username'
  MOCK_API_KEY = '5up3r$ecretKey!'
  RECIPIENTS = [
    { id: '6e7b4cea-5957-11e6-8b77-86f30ca893d3', name: 'Jake McFriend' }
  ].freeze
  PAYMENTS = [
    {
      id: '31db334f-9ac0-42cb-804b-09b2f899d4d2',
      amount: '10.50',
      currency: 'GBP',
      recipient_id: '6e7b146e-5957-11e6-8b77-86f30ca893d3',
      status: 'paid'
    }
  ].freeze

  VCR.configure do |config|
    config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    config.hook_into :webmock
  end

  before(:all) do
    Coolpay.api_url = MOCK_API_URL
    Coolpay.username = MOCK_USERNAME
    Coolpay.api_key = MOCK_API_KEY
  end

  context 'login' do
    it 'gets a token' do
      VCR.use_cassette('login') do
        result = Coolpay::APIRequest.login(Coolpay.username, Coolpay.api_key)
        token = result[:token]
        expect(token).to be_a(String)
        expect(token).not_to be_empty
      end
    end
  end

  context 'recipients' do
    it 'lists recipients' do
      VCR.use_cassette('recipients_all') do
        result = Coolpay::APIRequest.recipients
        recipients = result[:recipients]
        expect(recipients).to match_array(RECIPIENTS)
      end
    end

    it 'creates a recipient' do
      VCR.use_cassette('recipient_create') do
        result = Coolpay::APIRequest.create_recipient(name: 'Sandy McPal')
        recipient = result[:recipient]
        expect(recipient[:name]).to match('Sandy McPal')
        expect(recipient[:id]).not_to be_empty
      end
    end

    it 'finds a recipient by name' do
      VCR.use_cassette('recipient_find') do
        result = Coolpay::APIRequest.recipients(RECIPIENTS.first[:name])
        recipients = result[:recipients]
        expect(recipients).to match_array([RECIPIENTS.first])
      end
    end

    it 'fails to find unknown recipient' do
      VCR.use_cassette('recipient_find_fail') do
        result = Coolpay::APIRequest.recipients('Bogie McBogus')
        recipients = result[:recipients]
        expect(recipients).to be_empty
      end
    end
  end

  context 'payments' do
    it 'lists payments' do
      VCR.use_cassette('payments_all') do
        result = Coolpay::APIRequest.payments
        payments = result[:payments]
        expect(payments).to match_array(PAYMENTS)
      end
    end

    it 'creates a payment' do
      VCR.use_cassette('payment_create') do
        result = Coolpay::APIRequest.create_payment(
          amount: 12.34,
          currency: :usd,
          recipient_id: RECIPIENTS.first[:id]
        )
        payment = result[:payment]
        expect(payment[:amount]).to match('12.34')
        expect(payment[:currency]).to match('USD')
        expect(payment[:recipient_id]).to match(RECIPIENTS.first[:id])
        expect(payment[:id]).not_to be_empty
        expect(payment[:status]).to match('processing')
      end
    end
  end
end
