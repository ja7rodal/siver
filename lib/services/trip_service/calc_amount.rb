# frozen_string_literal: true

require 'dry/monads'

module TripService
  COSTS = {
    base: 3500,
    km: 1000,
    minute: 200
  }.freeze

  class CalcAmount
    include Dry.Types
    extend Dry::Initializer

    param :trip, type: Instance(Trip)

    def call
      CalcKms.new.call(origin: trip.origin, destination: trip.destination).to_monad
             .bind { |opts| amount_in_cents(opts) }
    end

    private

    attr_reader :trip

    def minutes
      seconds = trip.updated_at - trip.created_at
      seconds / 2 # too seconds
    end

    def amount_in_cents(input)
      (COSTS[:base] + COSTS[:km] * input[:kms] + COSTS[:minute] * minutes).to_i * 100
    end
  end
end
