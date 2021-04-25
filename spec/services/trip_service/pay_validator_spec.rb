# frozen_string_literal: true

RSpec.describe TripService::PayValidator do
  describe '#call' do
    let(:payment_source) { Fabricate(:payment_source) }
    let(:trip) { Fabricate(:trip) }
    let(:params) { { trip_id: trip&.id, payment_source_id: payment_source&.id } }

    before { Fabricate(:transaction, trip: trip, reference: nil, transaction_id: nil, amount: 358_000) }

    context 'When all validations are ok' do
      it 'returns a Success response' do
        subject = described_class.new
        response = subject.call(params)
        expect(response.to_h.keys).to include(:trip_id, :payment_source_id, :trip)
      end
    end

    context 'When any param is missing' do
      context 'when payment_source is nil' do
        let(:payment_source) { nil }

        it 'returns errors' do
          subject = described_class.new
          response = subject.call(params)
          errors = response.errors.messages.map(&:to_h)

          expect(errors.last.keys).to include(:payment_source_id)
          expect(errors.first[:payment_source_id].first).to eq('must be an integer')
        end
      end

      context 'When there is no a trip' do
        let(:trip) { nil }

        it 'returns errors' do
          subject = described_class.new
          response = subject.call(params)

          errors = response.errors.messages.map(&:to_h)
          expect(errors.last.keys).to include(:trip_id)
          expect(errors.first[:trip_id].first).to eq('must be an integer')
        end
      end

      context 'When trip does not have a transaction created' do
        it 'returns errors' do
          trip.transactions.destroy_all
          subject = described_class.new
          response = subject.call(params)

          errors = response.errors.messages.map(&:to_h)
          expect(errors.last.keys).to include(:trip_id)
          expect(errors.first[:trip_id].first).to eq('The trip does not have an associated transaction')
        end
      end
    end
  end
end
