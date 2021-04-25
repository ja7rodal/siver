# frozen_string_literal: true

require 'dry/monads'

module TripService
  class Create
    include Dry::Monads[:result]
    include Dry.Types

    def call(params)
      CreateValidator.new.call(params).to_monad
                     .bind { |opts| assign_driver(opts.to_h) }
                     .bind { |opts| create_trip(opts) }
    end

    private

    def assign_driver(input)
      driver = Driver.inactive.sample
      if driver
        driver.in_service!
        input[:rider].in_service!
        input[:driver_id] = driver.id
        Success(input)
      else
        Failure('Sorry, all drivers are in service')
      end
    end

    def create_trip(input)
      trip = Trip.new(input)
      if trip.save
        Success(trip)
      else
        Failure('The trip could not be created')
      end
    end
  end
end
