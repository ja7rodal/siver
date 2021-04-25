# frozen_string_literal: true

require_relative '../../lib/services/requests'

RSpec.describe Requests do
  let(:wrapper) { Class.new { extend Requests } }

  describe '#get' do
    it 'calls make_request with correct params' do
      expect(wrapper).to receive(:make_request).with(method: :get, path: '/merchant')
      wrapper.get '/merchant'
    end
  end

  describe '#post' do
    let(:default_headers) do
      { Authorization: 'Bearer prv_test_TLtMEGGALg5qMbOyE7NEdXgbramtaFPv' }
    end

    let(:default_payload) do
      {  currency: 'COP',
         payment_method: {
           type: 'CARD',
           installments: 2
         } }
    end

    let(:payload) { { reference: '111aa' } }

    it 'calls make_request' do
      expect(wrapper).to receive(:make_request)
      wrapper.post '/transaction', payload: { a: '1' }
    end

    it 'calls make_requests by adding default headers' do
      expect(wrapper).to receive(:make_request).with(
        method: :post,
        path: '/transaction',
        payload: default_payload.merge(payload).to_json,
        headers: default_headers
      )
      wrapper.post '/transaction', payload: payload
    end
  end
end
