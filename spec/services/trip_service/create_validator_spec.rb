# frozen_string_literal: true

RSpec.describe TripService::CreateValidator do
  describe '#call' do
    let(:rider) { Fabricate(:rider) }
    let(:params) { { rider_id: rider&.id, origin: rider&.coords, destination: rider&.coords } }

    context 'When all validations are ok' do
      it 'returns a Success response' do
        subject = described_class.new
        response = subject.call(params)
        expect(response.to_h.keys).to include(:rider_id, :origin, :destination)
      end
    end

    context 'When any param is missing' do
      context 'When rider_id is missing' do
        it 'returns errors' do
          params.delete(:rider_id)
          subject = described_class.new
          response = subject.call(params)
          errors = response.errors.messages.map(&:to_h)

          expect(errors.last.keys).to include(:rider_id)
          expect(errors.first[:rider_id].first).to eq('is missing')
        end
      end

      context 'When origin is missing' do
        it 'returns errors' do
          params.delete(:origin)
          subject = described_class.new
          response = subject.call(params)
          errors = response.errors.messages.map(&:to_h)

          expect(errors.last.keys).to include(:origin)
          expect(errors.first[:origin].first).to eq('is missing')
        end
      end
    end
  end
end
