# frozen_string_literal: true

class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.belongs_to :rider
      t.belongs_to :driver
      t.string :origin
      t.string :destination
      t.integer :status, default: 0
      t.datetime :finish_trip
      t.timestamps
    end
  end
end
