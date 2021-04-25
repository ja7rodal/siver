# frozen_string_literal: true

RSpec.describe TripService::CalcAmount do
  describe '#call' do
    let(:trip) { Fabricate(:trip) }

    context 'When all operations are successful' do
      it 'returns a Success response' do
        subject = described_class.new(trip)
        response = subject.call

        expect(response.class).to be(Integer)
      end
    end
  end
end
