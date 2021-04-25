# frozen_string_literal: true

Dry::Validation.load_extensions(:monads)

module TripService
  class PayValidator < Dry::Validation::Contract
    params do
      required(:trip_id).value(:integer)
      required(:payment_source_id).value(:integer)
    end

    rule(:trip_id) do
      trip = Trip.find_by(id: value)

      if trip.present? && trip.driver.present?
        values[:trip] = trip
      else
        key.failure('could not be found a trip')
      end

      transaction = if trip.transactions.declined&.last
                      trx = trip.transactions.declined&.last
                      trip.transactions.create(amount: trx.amount, reference: trx.reference)
                    else
                      trip.transactions&.created&.last
                    end
      if transaction.present? && transaction.amount.positive?
        values[:transaction_model] = transaction
      else
        key.failure('The trip does not have an associated transaction')
      end
    end

    rule(:payment_source_id) do
      payment_source = PaymentSource.find_by(id: value)

      if payment_source.present?
        values[:payment_source] = payment_source
      else
        key.failure('could not be found')
      end
    end
  end
end
