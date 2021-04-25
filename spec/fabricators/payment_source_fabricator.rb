# frozen_string_literal: true

require 'forgery'

Fabricator(:payment_source) do
  rider
  source_id { Forgery::Basic.number min: 1000, max: 9999 }
  brand { Forgery::CreditCard.type }
  name 'MY'
  last_four { Forgery::Basic.number }
end
