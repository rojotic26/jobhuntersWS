require 'sinatra/base'
require 'json'

require 'haml'
require 'sinatra/flash'

require 'httparty'

##
# Web application to obtain Job offers from TECOLOCO
class Prognition < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  use Rack::MethodOverride

  configure :production, :development do
    enable :logging
  end

  configure :development do
    set :session_secret, "something"    # ignore if not using shotgun in development
  end

  API_BASE_URI = 'http://jobhunters.herokuapp.com/joboffers'
  API_VER = '/api/v2/'
  # Assigning nothing to the version variable
  API_VER = ''
  helpers do
    def current_page?(path = ' ')
      path_info = request.path_info
      path_info += ' ' if path_info == '/'
      request_path = path_info.split '/'
      request_path[1] == path
    end

    def api_url(resource)
      URI.join(API_BASE_URI, API_VER, resource).to_s
    end
  end

  get '/' do
    haml :home
  end

 post '/offers' do
    request_url = "#{API_BASE_URI}/api/v1/joboffers"
    category = params[:category].split("\r\n")
    city = params[:city].split("\r\n")
    param = {
      category: category,
      city: city
    }

    request = {
      body: param.to_json,
      headers: { 'Content-Type' => 'application/json' }
    }
    result = HTTParty.post(request_url, request)

    if (result.code != 200)
      flash[:notice] = 'The values provided did not match any result'
      redirect '/offers'
      return nil
    end

    id = result.request.last_uri.path.split('/').last
    session[:result] = result.to_json
    session[:category] = category
    session[:city] = city
    session[:action] = :create
    redirect "/offers/#{id}"
  end

    get '/offers/:id' do
    if session[:action] == :create
      @results = JSON.parse(session[:result])
      @category = session[:category]
      @city = session[:city]
    else
      request_url = "#{API_BASE_URI}/api/v1/offers/#{params[:id]}"
      request = { headers: {'Content-Type' => 'application/json' } }
      result = HTTParty.get(request_url,request)
      @results = result
    end
    @id = params[:id]
    @action = :update
    haml :offers
  end
  
  get '/joboffers' do

    @category = params[:category]
    if @category
      redirect "/joboffers/#{@category}"
      return nil
    end
    haml :joboffers
  end

  get '/joboffers/:category' do
    @jobofferobject = offerobject
    @category = params[:category]

    if @category && @jobofferobject.nil?
      flash[:notice] = 'Category not found' if @jobofferobject.nil?

      redirect '/joboffers'
    end
    haml :joboffers
  end
  
  get '/aboutus' do
    haml :aboutus
  end

  get '/offers' do
    haml :offers
  end
  
  delete '/offers/:id' do
      request_url = "#{API_BASE_URI}/api/v1/joboffers/#{params[:id]}"
      result = HTTParty.delete(request_url)
      flash[:notice] = 'record of job offers deleted'
      redirect '/offers'
  end
end
