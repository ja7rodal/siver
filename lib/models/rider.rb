# frozen_string_literal: true

require_relative 'user'

class Rider < User
  has_many :payment_sources
  has_many :trips
  has_many :transactions, through: :trips
end
