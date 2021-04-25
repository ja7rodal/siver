# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Driver, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(Fabricate.build(:driver)).to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:trips) }
    it { should have_many(:transactions).through(:trips) }
  end
end
