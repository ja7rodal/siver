# frozen_string_literal: true

Dry::Validation.load_extensions(:monads)

module TripService
  class CalcKms < Dry::Validation::Contract
    params do
      required(:origin).value(:array)
      required(:destination).value(:array)
    end

    rule(:origin, :destination) do
      coords = [values[:origin], values[:destination]].flatten

      if coords.length != 4 || !coords.all? { |e| e.is_a? Float }
        key.failure('You must provide valid coords')
      else
        values[:kms] = kms(coords)
      end
    end

    def kms(coords)
      degree = (coords[2] - coords[0]).abs +
               (coords[3] - coords[1]).abs
      degree * 40 # kms por degree
    end
  end
end
