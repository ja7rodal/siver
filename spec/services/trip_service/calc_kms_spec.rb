# frozen_string_literal: true

RSpec.describe TripService::CalcKms do
  describe '#call' do
    let(:trip) { Fabricate.build(:trip) }
    let(:params) { { origin: trip.origin, destination: trip.destination } }

    context 'When all operations are successful' do
      it 'returns a Success response' do
        subject = described_class.new
        response = subject.call(params)
        expect(response).to be_success
      end
    end

    context 'When any operations are wrong' do
      context 'when the validation fails' do
        it 'returns a list of errors' do
          params.delete(:origin)
          subject = described_class.new
          response = subject.call(params)

          expect(response).to be_failure

          errors = response.errors.messages.map(&:to_h)
          expect(errors.last.keys).to include(:origin)
          expect(errors.first[:origin].first).to eq('is missing')
        end
      end

      context 'when the coords are wrong' do
        it 'returns a list of errors' do
          trip.origin = [1, nil]
          subject = described_class.new
          response = subject.call(params)

          expect(response).to be_failure

          errors = response.errors.messages.map(&:to_h)
          expect(errors.last.keys).to include(:origin)
          expect(errors.first[:origin].first).to eq('You must provide valid coords')
        end
      end
    end
  end
end
