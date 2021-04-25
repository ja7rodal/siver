# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.belongs_to :trip
      t.belongs_to :payment_source
      t.integer :status, default: 0
      t.string :reference
      t.string :transaction_id
      t.integer :amount, default: 0
      t.timestamps
    end
  end
end
