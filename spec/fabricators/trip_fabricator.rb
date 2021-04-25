# frozen_string_literal: true

Fabricator(:trip) do
  rider
  driver
  origin { [latitude, longitude] }
  destination { [latitude, longitude] }
  status 0
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
