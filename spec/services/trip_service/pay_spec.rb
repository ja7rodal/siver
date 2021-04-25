# frozen_string_literal: true

RSpec.describe TripService::Pay do
  describe '#call' do
    let(:rider) { Fabricate(:rider, status: 1) }
    let(:driver) { Fabricate(:driver, status: 1) }
    let(:source_id) { 10_661 }
    let(:payment_source) { Fabricate(:payment_source, source_id: source_id, rider: rider) }
    let(:trip) { Fabricate(:trip, rider: rider, driver: driver, status: 1) }
    let(:params) { { rider_id: rider.id, payment_source_id: payment_source.id, trip_id: trip.id } }

    before { Fabricate(:transaction, trip: trip, reference: 'AVCV-5454', transaction_id: nil, amount: 35_000) }

    context 'When all operations are successful' do
      it 'returns a Success response' do
        VCR.use_cassette('200_complete') do
          subject = described_class.new
          response = subject.call(params)
          transaction = response.value!
          trip = transaction.trip

          expect(response).to be_success
          expect(transaction.status).to eq('approved')
          expect(transaction.amount).to eq(35_000)
          expect(transaction.reference.class).to eq(String)
          expect(trip.status).to eq('paid')
          expect(trip.rider.status).to eq('inactive')
          expect(trip.driver.status).to eq('inactive')
          expect(transaction.payment_source).to eq(payment_source)
        end
      end
    end

    context 'When any operations are wrong' do
      context 'when the request token fails' do
        let(:expected_response) do
          { error: { type: 'INVALID_ACCESS_TOKEN',
                     reason: 'Se esperaba una llave pública o privada pero no se recibió ninguna' },
            code: 401 }
        end
        it 'returns a Failure response' do
          VCR.use_cassette('401_token') do
            subject = described_class.new
            response = subject.call(params)
            expect(response).to be_failure
            expect(response.failure).to eq(expected_response)
          end
        end
      end

      context 'when the request POST transaction fails' do
        let(:expected_response) do
          { code: 422,
            error: { messages: { reference: ['Debe ser tipo string', 'El tamaño no puede ser mayor que 255'] },
                     type: 'INPUT_VALIDATION_ERROR' } }
        end
        it 'returns a Failure response' do
          VCR.use_cassette('422_transaction') do
            subject = described_class.new
            response = subject.call(params)
            expect(response).to be_failure
            expect(response.failure).to eq(expected_response)
          end
        end
      end

      context 'when the request status transaction fails' do
        let(:expected_response) do
          { code: 404, error: { reason: 'La entidad solicitada no existe', type: 'NOT_FOUND_ERROR' } }
        end
        it 'returns a Failure response' do
          VCR.use_cassette('404_status_transaction') do
            subject = described_class.new
            response = subject.call(params)
            expect(response).to be_failure
            expect(response.failure).to eq(expected_response)
          end
        end
      end

      context 'when the transaction is declined' do
        it 'returns a Success response' do
          VCR.use_cassette('200_declined') do
            subject = described_class.new
            response = subject.call(params)
            transaction = trip.transactions.last

            expect(response).to be_failure
            expect(response.failure.to_s).to eq('The pay was declined')
            expect(transaction.status).to eq('declined')
            expect(transaction.amount).to eq(35_000)
            expect(transaction.reference.class).to eq(String)
            expect(trip.status).to eq('finished')
            expect(trip.rider.status).to eq('in_service')
            expect(trip.driver.status).to eq('in_service')
            expect(transaction.payment_source).to eq(payment_source)
          end
        end
      end
    end
  end
end
