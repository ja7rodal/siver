# frozen_string_literal: true

require 'app'
require 'rack/test'

RSpec.describe 'Sinatra App' do
  include Rack::Test::Methods
  include RSpecHtmlMatchers

  def app
    App.new
  end

  def authenticate!
    env 'rack.session', { user_id: user.id }
  end

  shared_examples_for 'redirect to /' do
    it 'redirect to main page' do
      expect(response.status).to eq 302
      follow_redirect!
      expect(response.location).to include('/')
    end
  end

  shared_examples_for 'redirect to /users/home' do
    it 'redirect to users home page' do
      expect(response.status).to eq 302
      follow_redirect!
      expect(response.location).to include('users', 'home')
    end
  end

  context 'GET to /' do
    let(:response) { get '/' }

    context 'When the user is not authenticated' do
      it 'redirect to main page' do
        expect(response.status).to eq 200
        expect(response.body).to have_tag('form', with: { action: '/users/home', method: 'POST' }) do
          with_tag 'input', with: { name: 'email', type: 'email' }
          with_tag 'input', with: { name: 'password', type: 'password' }
          with_tag 'button', with: { type: 'submit' }
        end
      end
    end

    context 'When the user is authenticated' do
      let(:user) { Fabricate(:rider, password: '1234') }

      before { authenticate! }
      it_behaves_like 'redirect to /users/home'
    end
  end

  context 'GET to /logout' do
    let(:response) { get '/logout' }

    context 'When the user is authenticated' do
      it_behaves_like 'redirect to /'
    end
  end

  context 'GET to /users/home' do
    let(:response) { get '/users/home' }

    context 'When the user is not authenticated' do
      it_behaves_like 'redirect to /'
    end

    context 'When the user is authenticated' do
      context 'When the user is a Rider' do
        let(:user) { Fabricate(:rider, password: '1234') }

        it 'redirects to rider home' do
          authenticate!
          expect(response.status).to eq 200
          expect(response.body).to include('Welcome Rider')
          expect(response.body).to have_tag('form', with: { action: '/start_trip', method: 'POST' })
        end
      end

      context 'When the user is a Driver' do
        let(:user) { Fabricate(:driver, password: '1234') }

        it 'redirects to driver home' do
          authenticate!
          expect(response.status).to eq 200
          expect(response.body).to include('Welcome Driver')
        end
      end
    end
  end

  context 'POST  to /users/home' do
    let(:user) { Fabricate(:rider, password: '1234') }
    let(:password) { '1234' }
    let(:response) { post '/users/home', { email: user.email, password: password } }

    context 'When the credentials of user are ok' do
      it_behaves_like 'redirect to /users/home'
    end

    context 'When the credentials of user are wrong' do
      let(:password) { '123' }

      it_behaves_like 'redirect to /'
    end
  end

  context 'POST to /start_trip' do
    let(:user) { Fabricate(:rider, password: '1234') }
    let(:service) { Dry::Monads::Result::Success.new(true) }

    it 'returns' do
      authenticate!
      expect_any_instance_of(TripService::Create).to receive(:call)
        .with(anything)
        .and_return(service)
      post '/start_trip', {}
    end
  end
end
