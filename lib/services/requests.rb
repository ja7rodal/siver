# frozen_string_literal: true

require 'rest-client'

module Requests
  URL = 'https://sandbox.wompi.co/v1'
  PRV_KEY = ENV['PRV_KEY'] || 'prv_test_TLtMEGGALg5qMbOyE7NEdXgbramtaFPv'

  def get(path)
    make_request(method: :get, path: path)
  end

  def post(path, payload:)
    make_request(method: :post, path: path, payload: merge_payload(payload), headers: headers)
  end

  def make_request(method:, path:, payload: nil, headers: {})
    RestClient::Request.execute(method: method,
                                url: URL + path,
                                payload: payload,
                                headers: headers)
  rescue StandardError => e
    e.response
  end

  def headers
    {
      Authorization: "Bearer #{PRV_KEY}"
    }
  end

  def merge_payload(payload)
    {
      currency: 'COP',
      payment_method: {
        type: 'CARD',
        installments: 2
      }
    }.merge(payload).to_json
  end
end
