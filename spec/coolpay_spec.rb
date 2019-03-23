# frozen_string_literal: true

RSpec.describe Coolpay do
  it 'has a version number' do
    expect(Coolpay::VERSION).not_to be nil
  end

  it 'runs a pointless test' do
    expect(true).to eq(true)
  end

  context 'authorization' do
    context 'authorized?' do
      it 'checks authorization token' do
        Coolpay.token = nil
        expect(Coolpay.authorized?).to be false
        Coolpay.token = '123abc'
        expect(Coolpay.authorized?).to be true
      end
    end

    context 'authorize!' do
      it 'logs in and sets authorization token' do
        Coolpay.token = nil
        expect(Coolpay.authorized?).to be false
        allow(Coolpay::APIRequest).to receive(:login) { { token: '123abc' } }
        Coolpay.authorize!
        expect(Coolpay.authorized?).to be true
        expect(Coolpay.token).to match('123abc')
      end
    end

    context 'authorize' do
      context 'already logged in' do
        it 'does not log in again' do
          Coolpay.token = '123abc'
          expect(Coolpay::APIRequest).not_to receive(:login)
          Coolpay.authorize
          expect(Coolpay.authorized?).to be true
        end
      end

      context 'not logged in' do
        it 'logs in' do
          Coolpay.token = nil
          expect(Coolpay::APIRequest).to receive(:login) { { token: '456def' } }
          Coolpay.authorize
          expect(Coolpay.authorized?).to be true
          expect(Coolpay.token).to match('456def')
        end
      end
    end
  end
end
