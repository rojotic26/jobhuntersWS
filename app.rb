require 'sinatra/base'
#require 'sinatra/namespace'
require 'jobhunters'
require 'json'
require_relative 'model/offer'
require 'httparty'
require 'haml'
require 'sinatra/flash'

class TecolocoJobOffers < Sinatra::Base
  #register Sinatra::Namespace
  enable :sessions
  register Sinatra::Flash
  use Rack::MethodOverride
  configure :production, :development do
    enable :logging
  end

  API_BASE_URI = 'http://localhost:9292'
  after { ActiveRecord::Base.connection.close }
  helpers do
    def offerobject
      category = check_cat(params[:category])
       if category == 'none' then

         return nil

       end

        return nil unless category
        catego = { 'id' => category , 'offers' => [], }

        begin
          JobSearch::Tecoloco.getjobs(category).each do |title, date, cities, details|
            catego['offers'].push('title'=>title,'date'=>date,'city'=>cities, 'details'=>details)
          end
          catego
        rescue
          nil
        end
      end
      def get_jobs(category)
        jobs_after = {
          'type of job' => category,
          'kind' => 'openings',
          'jobs' => []
        }

        category = params[:category]
        JobSearch::Tecoloco.getjobs(category).each do |title, date, cities, details|
          jobs_after['jobs'].push('id' => title, 'date' => date, 'city' => cities, 'details'=>details)
        end
        jobs_after

    end


    #Defining the function get_jobs_cat_city
    def get_jobs_cat_city(category,city)
      jobs_after_city = {
        'jobs' => []
      }
      flag=false
      cat = check_cat(category[0])
      cit = city[0]

        JobSearch::Tecoloco.getjobs(cat).each do |title, date, cities, details|
          if cities.to_s == cit.to_s
            flag=true
            jobs_after_city['jobs'].push('id' => title, 'date' => date, 'cities' => cities, 'details' => details)
          end
        end
        if flag==false then
          halt 404
        else
          jobs_after_city
        end


    end

    def get_jobs_cat_city_url(category,city)
      jobs_after_city = {
        'type of job' => category,
        'kind' => 'openings',
        'city' => city,
        'jobs' => []
      }
      flag=false
      category = params[:category]
      city = params[:city]


        JobSearch::Tecoloco.getjobs(cat).each do |title, date, cities|
          if cities.to_s == city.to_s
            flag=true
            jobs_after_city['jobs'].push('id' => title, 'date' => date)
          end
        end
        if flag==false then
          halt 404
        else
          jobs_after_city
        end



    end

    #Defining the function get_jobs_city
    def check_cat(category)
      ##Checks if Category exists within Tecoloco

      case category
      when  "marketing"
        @output = "marketing-ventas"
      when "banca"
        @output = "banco-servicios-financieros"
      else
        @output = "none"
        halt 404
      end
      @output
    end

    def list_joboffers(categories)
      @list_all = {}
      categories.each do |category|
        @list_all[category] = JobSearch::Tecoloco.getjobs(category)
      end
      @list_all
    end

    def current_page?(path = ' ')
      path_info = request.path_info
      path_info += ' ' if path_info == '/'
      request_path = path_info.split '/'
      request_path[1] == path
    end


  end

  get '/api/v1/job_openings/:category.json' do
    cat = params[:category]
    category_url = check_cat(cat)
    if category_url == "none" then
      halt 404
    else
      content_type :json
      get_jobs(category_url).to_json
    end

  end

  get '/api/v1/job_openings/:category/city/:city.json' do
    content_type :json
    get_jobs_cat_city_url(params[:category],params[:city]).to_json
  end

  post '/api/v1/joboffers' do
    content_type:json

    body = request.body.read
    logger.info body
    begin
      req = JSON.parse(body)
      logger.info req
    rescue Exception => e
      puts e.message
      halt 400
    end

    cat = Category.new
    cat.category = req['category'].to_json
    cat.city = req['city'].to_json

    if cat.save
      redirect "/api/v1/offers/#{cat.id}"
    end
  end

  delete '/api/v1/joboffers/:id' do
    cat = Category.destroy(params[:id])
  end

  get '/api/v1/offers/:id' do
    content_type:json
    logger.info "GET /api/v1/offers/#{params[:id]}"
    begin
      @category = Category.find(params[:id])
      cat = JSON.parse(@category.category)
      cat2 = @category.category
      city = JSON.parse(@category.city)
    rescue
      halt 400
    end
    logger.info({ category: cat, city: city }.to_json)
    result = get_jobs_cat_city(cat, city).to_json
    logger.info "result: #{result}\n"
    result
  end

  
end
