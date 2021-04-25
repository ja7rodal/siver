# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(Fabricate(:user)).to be_valid
    end
  end
end
