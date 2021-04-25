# frozen_string_literal: true

require_relative 'user'

class Driver < User
  has_many :trips
  has_many :transactions, through: :trips
end
