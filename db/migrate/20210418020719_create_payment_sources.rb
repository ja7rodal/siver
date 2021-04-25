# frozen_string_literal: true

class CreatePaymentSources < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_sources do |t|
      t.belongs_to :rider
      t.integer :source_id
      t.string :brand
      t.string :name
      t.integer :last_four
      t.timestamps
    end
  end
end
