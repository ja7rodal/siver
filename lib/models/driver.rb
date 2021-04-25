# frozen_string_literal: true

class Driver < User
  has_many :trips
  has_many :transactions, through: :trips
end
