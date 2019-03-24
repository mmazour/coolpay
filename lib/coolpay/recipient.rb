# frozen_string_literal: true

module Coolpay
  #
  # Encapsulates a Coolpay recipient.
  #
  class Recipient
    extend Coolpay::Helpers

    attr_reader :id, :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end

    def self.create(name)
      api_result = Coolpay::APIRequest.create_recipient(name: name)
      recipient = check_api_result(
        api_result,
        description: "creating recipient '#{name}'",
        expect_and_return_key: :recipient
      )
      new(id: recipient[:id], name: recipient[:name])
    end

    def self.find(name)
      api_result = Coolpay::APIRequest.recipients(name)
      recipient = check_api_result(
        api_result,
        description: "finding recipient '#{name}'",
        expect_and_return_key: :recipients
      ).first
      return nil unless recipient

      new(id: recipient[:id], name: recipient[:name])
    end

    def self.list
      api_result = Coolpay::APIRequest.recipients
      recipients = check_api_result(
        api_result,
        description: 'listing recipients',
        expect_and_return_key: :recipients
      )
      recipients.map { |r| new(id: r[:id], name: r[:name]) }
    end
  end
end
