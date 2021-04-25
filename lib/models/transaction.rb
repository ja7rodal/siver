# frozen_string_literal: true

class Transaction < ActiveRecord::Base
  belongs_to :trip
  belongs_to :payment_source

  enum status: %i[created pending approved declined]

  after_update :update_trip_status

  private

  def update_trip_status
    trip.paid! if approved?
  end
end
