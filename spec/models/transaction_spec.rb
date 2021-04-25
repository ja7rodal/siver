# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Transaction, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(Fabricate.build(:transaction)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:trip) }
    it { should belong_to(:payment_source) }
  end

  describe 'callbacks' do
    let(:transaction) { Fabricate(:transaction) }
    it 'triggers update_status on update' do
      expect(transaction).to receive(:update_trip_status)
      transaction.approved!
    end
  end
end
