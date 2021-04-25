# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trip, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(Fabricate.build(:trip)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:rider) }
    it { should belong_to(:driver) }
    it { should have_many(:transactions) }
  end

  describe 'callbacks' do
    let(:trip) { Fabricate(:trip) }
    it 'triggers update_status on update' do
      expect(trip).to receive(:update_users_status)
      trip.paid!
    end
  end
end
