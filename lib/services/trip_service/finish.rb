# frozen_string_literal: true

require 'dry/monads'
require_relative '../utils'

module TripService
  class Finish
    include Dry::Monads[:result]
    include Dry.Types
    include ::Utils
    extend Dry::Initializer

    option :trip_id, type: Integer, reader: :private

    def call
      finish_trip.bind { |opts| persist_transaction(opts) }
    end

    private

    def finish_trip
      trip = Trip.find_by(id: trip_id)
      if trip
        trip.finished!
        Success(trip)
      else
        Failure('The trip could not be found')
      end
    end

    def persist_transaction(trip)
      amount = CalcAmount.new(trip).call
      transaction = trip.transactions.new(amount: amount, reference: reference)
      if transaction.save
        Success(transaction)
      else
        Failure('The transaction could not be initialized')
      end
    end
  end
end
