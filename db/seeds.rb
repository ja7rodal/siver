# frozen_string_literal: true

Rider.create(name: 'Don Rodal', email: 'ja7rodal@gmail.com', password: '1234')
Rider.create(name: 'Leonardo Rodriguez', email: 'ja7@gmail.com', password: '1234')
Rider.create(name: 'Mr Rider', email: 'rider@gmail.com', password: '1234')

Driver.create(name: 'El chofer', email: 'driver@gmail.com', password: '1234')
Driver.create(name: 'Don Jaime', email: 'driver1@gmail.com', password: '1234')
Driver.create(name: 'chofyr', email: 'driver2@gmail.com', password: '1234')
Driver.create(name: 'John Conductor', email: 'driver3@gmail.com', password: '1234')
Driver.create(name: 'Mr Ford', email: 'driver3@gmail.com', password: '1234')

Rider.all.map do |u|
  u.payment_sources.create(source_id: 10_661, name: 'Money', brand: 'VISA', last_four: 4_242)
  u.payment_sources.create(source_id: 10_662, name: 'Broken', brand: 'BIZA', last_four: 1_111)
end
