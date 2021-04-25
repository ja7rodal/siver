# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rider, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(Fabricate.build(:rider)).to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:trips) }
    it { should have_many(:payment_sources) }
    it { should have_many(:transactions).through(:trips) }
  end
end
