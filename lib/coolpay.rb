# frozen_string_literal: true

require 'coolpay/version'
require 'coolpay/helpers'
require 'coolpay/api_request'
require 'coolpay/payment'
require 'coolpay/recipient'

#
# Interface to the Coolpay API
#
module Coolpay
  class << self
    attr_accessor :api_url, :username, :api_key, :token

    def authorize
      authorized? || authorize!
    end

    def authorize!
      result = Coolpay::APIRequest.login(@username, @api_key)
      @token = result[:token]
      authorized?
    end

    def authorized?
      !@token.nil?
    end
  end

  class Error < StandardError; end
end
