# frozen_string_literal: true

class PaymentSource < ActiveRecord::Base
  belongs_to :rider
  has_many :transactions
end
