# frozen_string_literal: true

class User < ActiveRecord::Base
  validates :email, uniqueness: true

  has_secure_password

  enum status: %i[inactive in_service]

  def coords
    [latitude, longitude]
  end

  private

  def latitude
    n = Random.new.rand(3.0..5.0)
    format('%<n>0.6f', n: n).to_f
  end

  def longitude
    n = Random.new.rand(73.0..75.0)
    format('%<n>0.6f', n: n).to_f
  end
end
