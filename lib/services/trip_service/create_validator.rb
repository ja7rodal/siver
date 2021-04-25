# frozen_string_literal: true

Dry::Validation.load_extensions(:monads)

module TripService
  class CreateValidator < Dry::Validation::Contract
    params do
      required(:rider_id).value(:integer)
      required(:origin).value(:array)
      required(:destination).value(:array)
    end

    rule(:rider_id) do
      rider = Rider.find_by(id: value)

      if rider.present?
        values[:rider] = rider
      else
        key.failure('could not be found')
      end
    end
  end
end
