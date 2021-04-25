# frozen_string_literal: true

require 'forgery'

Fabricator(:transaction) do
  trip
  payment_source
  status 0
  reference { Forgery::Basic.text.downcase }
  transaction_id { Forgery::Basic.number * 111 }
  amount { Forgery::Basic.number * 10_000 }
end
