# frozen_string_literal: true

RSpec.describe TripService::Create do
  describe '#call' do
    let(:driver) { Fabricate(:driver) }
    let(:rider) { Fabricate(:rider) }
    let(:params) { { rider_id: rider.id, origin: rider.coords, destination: rider.coords } }

    context 'When all operations are successful' do
      it 'returns a Success response' do
        driver.inactive!
        subject = described_class.new
        response = subject.call(params)
        expect(response).to be_success
      end
    end

    context 'When any operations are wrong' do
      context 'when the validation fails' do
        it 'returns a Failure response' do
          params.delete(:origin)
          subject = described_class.new
          response = subject.call(params)

          expect(response).to be_failure

          errors = response.failure.errors.messages.map(&:to_h)
          expect(errors.last.keys).to include(:origin)
          expect(errors.first[:origin].first).to eq('is missing')
        end
      end

      context 'when the request POST transaction fails' do
        let(:expected_response) { 'Sorry, all drivers are in service' }

        it 'returns a Failure response' do
          driver.in_service!
          subject = described_class.new
          response = subject.call(params)

          expect(response).to be_failure
          expect(response.failure).to eq(expected_response)
        end
      end
    end
  end
end
