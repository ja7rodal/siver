# frozen_string_literal: true

RSpec.describe TripService::Finish do
  describe '#call' do
    let(:driver) { Fabricate(:driver) }
    let(:rider) { Fabricate(:rider) }
    let(:trip) { Fabricate(:trip, rider: rider, driver: driver) }

    context 'When all operations are successful' do
      it 'returns a Success response' do
        subject = described_class.new(trip_id: trip.id)
        response = subject.call

        expect(response).to be_success
        trip.reload
        expect(trip.finished?).to be_truthy
      end
    end
  end
end
