# frozen_string_literal: true

module Coolpay
  #
  # Implements the actual requests to the Coolpay API.
  #
  class APIRequest
    require 'rest_client'
    require 'json'
    require 'uri'
    require 'pathname'
    require 'cgi'

    def self.login(username, api_key)
      params = {
        username: username,
        apikey: api_key
      }.to_json
      parse_json(
        RestClient.post(url_for('login'), params, headers(with_auth: false))
      )
    end

    def self.recipients(search_name = nil)
      Coolpay.authorize
      query = query_for('name', search_name)
      parse_json RestClient.get(url_for('recipients', query), headers)
    end

    def self.create_recipient(name:)
      Coolpay.authorize
      params = { recipient: { name: name } }.to_json
      parse_json RestClient.post(url_for('recipients'), params, headers)
    end

    def self.payments
      Coolpay.authorize
      parse_json RestClient.get(url_for('payments'), headers)
    end

    def self.create_payment(amount:, currency:, recipient_id:)
      Coolpay.authorize
      params = {
        payment: {
          amount: amount,
          currency: currency,
          recipient_id: recipient_id
        }
      }
      parse_json RestClient.post(url_for('payments'), params, headers)
    end

    def self.headers(with_auth: true)
      hdrs = { content_type: 'application/json' }
      hdrs[:authorization] = "Bearer #{Coolpay.token}" if with_auth
      hdrs
    end

    def self.query_for(name, value)
      return nil unless value

      "#{name}=#{CGI.escape(value)}"
    end

    def self.url_for(endpoint, query = nil)
      uri = URI(Coolpay.api_url)
      uri.path = (Pathname.new(uri.path) / endpoint).to_s
      uri.query = query if query
      uri.to_s
    end

    def self.parse_json(json)
      JSON.parse(json, symbolize_names: true)
    end
  end
end
