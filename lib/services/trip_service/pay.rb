# frozen_string_literal: true

require 'dry/monads'
require_relative '../requests'
require_relative '../utils'

module TripService
  class Pay
    include Dry::Monads[:result]
    include Dry.Types
    extend Dry::Initializer
    include ::Utils
    include ::Requests

    def call(params)
      PayValidator.new.call(params).to_monad
                  .bind { |opts| payload(opts.to_h) }
                  .bind { |opts| get_token(opts) }
                  .bind { |opts| perform_transaction(opts) }
                  .bind { |opts| update_transaction_model(opts) }
                  .bind { |opts| update_status_transaction(opts) }
                  .bind { |opts| verify_payment(opts) }
    end

    private

    def payload(input)
      input[:payload] = {}.tap do |t|
        t[:payment_source_id] = input[:payment_source].source_id
        t[:customer_email] = input[:trip].driver&.email
        t[:amount_in_cents] = input[:transaction_model].amount
        t[:reference] = input[:transaction_model].reference
      end
      Success(input)
    end

    def get_token(input)
      response = get("/merchants/#{pub_key}")
      if response.code == 200
        input[:acceptance_token] = acceptance_token_getter(response)
        Success(input)
      else
        Failure(parsed_error(response))
      end
    end

    def perform_transaction(input)
      response = post('/transactions', payload: input[:payload])
      if response.code == 201
        input[:transaction_response] = transaction_data(response)
        Success(input)
      else
        Failure(parsed_error(response))
      end
    end

    def update_transaction_model(input)
      transaction_model = input[:transaction_model]
      if transaction_model.update(input[:transaction_response].merge(payment_source: input[:payment_source]))
        Success(input)
      else
        Failure('Error to update transaction model')
      end
    end

    def update_status_transaction(input)
      sleep 3
      transaction = input[:transaction_model]
      response = get("/transactions/#{transaction.transaction_id}")
      if response.code == 200
        transaction.update(status: map_status(response))
        Success(transaction)
      else
        Failure(parsed_error(response))
      end
    end

    def verify_payment(transaction)
      if transaction.approved?
        Success(transaction)
      else
        Failure('The pay was declined')
      end
    end
  end
end
