# frozen_string_literal: true

require 'sinatra'
require 'sinatra/flash'
require_relative '../config/environment'

# class base
class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/' do
    redirect to '/users/home' if session[:user_id]
    erb :login
  end

  get '/logout' do
    session.clear
    redirect to '/'
  end

  post '/users/home' do
    @user = User.find_by(email: params[:email])
    if @user && @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/users/home'
    else
      session.clear
      flash[:error] = 'invalid credentials'
      redirect to '/'
    end
  end

  get '/users/home' do
    authenticate!
    @user = User.find(session[:user_id])
    path = @user.is_a?(Rider) ? :'/riders/home' : :'/drivers/home'
    erb path
  end

  post '/start_trip' do
    params.merge!(rider_id: current_user.id, destination: current_user.coords, origin: current_user.coords)
    service = TripService::Create.new.call(params.to_h)

    if service.success?
      flash[:success] = 'your trip have started'
    else
      flash[:error] = service.failure.to_s
    end
    redirect to '/users/home'
  end

  post '/finish_trip' do
    service = TripService::Finish.new(trip_id: params[:trip_id].to_i).call
    if service.success?
      flash[:success] = 'you have finished the trip correctly'
    else
      flash[:error] = service.failure.to_s
    end
    redirect to '/users/home'
  end

  post '/pay_trip' do
    service = TripService::Pay.new.call(new_params)
    if service.success?
      flash[:success] = 'your pay was correct'
    else
      flash[:error] = service.failure.to_s
    end
    redirect to '/'
  end

  private

  def authenticate!
    redirect to '/' unless session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end

  def new_params
    params.each_with_object({}) { |v, h| h[v.first] = v.last.to_i }
  end
end
