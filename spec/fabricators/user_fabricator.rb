# frozen_string_literal: true

require 'forgery'

Fabricator(:user) do
  name { Forgery::Name.full_name }
  password '1234'
  email { Forgery::Internet.email_address }
  status 0
end
