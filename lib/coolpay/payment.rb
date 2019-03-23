# frozen_string_literal: true

module Coolpay
  #
  # Encapsulates a Coolpay payment.
  #
  class Payment
    extend Coolpay::Helpers

    PAYMENT_FIELDS = %i[id recipient_id amount currency status].freeze

    attr_reader(*PAYMENT_FIELDS, :string_amount)

    def initialize(id:, recipient_id:, amount: 0.0, currency: nil, status: nil)
      @id = id
      @recipient_id = recipient_id
      @currency = currency.to_s.downcase.to_sym # "GBP" -> :gbp
      @amount = amount.to_f
      @string_amount = amount
      @status = status
    end

    #
    # Create a payment.
    # Recipient may be specified either with a Recipient object or an id.
    # Amount and currency are passed through unchanged to the Coolpay API,
    # but by convention in the API examples, they are numeric and symbol
    # (e.g. :gbp) respectively.
    #
    def self.create(recipient:, amount: 0.0, currency: nil)
      recipient_id = recipient.respond_to?(:id) ? recipient.id : recipient
      api_result = Coolpay::APIRequest.create_payment(
        recipient_id: recipient_id,
        amount: amount,
        currency: currency
      )
      payment = check_api_result(
        api_result,
        description:
          "creating payment of #{amount} #{currency} to #{recipient}",
        expect_and_return_key: :payment
      )
      new(payment.slice(*PAYMENT_FIELDS))
    end

    #
    # List the existing payments
    #
    def self.list
      api_result = Coolpay::APIRequest.payments
      payments = check_api_result(
        api_result,
        description: 'listing payments',
        expect_and_return_key: :payments
      )
      payments.map do |p|
        new(p.slice(*PAYMENT_FIELDS))
      end
    end
  end
end
