# frozen_string_literal: true

require 'active_support/core_ext/numeric/conversions'

class Trip < ActiveRecord::Base
  belongs_to :rider
  belongs_to :driver
  has_many :transactions

  enum status: %i[started finished paid canceled]
  serialize :origin, Array
  serialize :destination, Array

  after_update :update_users_status

  private

  def update_users_status
    if paid?
      rider.inactive!
      driver.inactive!
    end
  end
end
