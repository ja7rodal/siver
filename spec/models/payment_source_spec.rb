# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PaymentSource, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(Fabricate.build(:payment_source)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:rider) }
    it { should have_many(:transactions) }
  end
end
