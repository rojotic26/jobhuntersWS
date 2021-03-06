require_relative 'spec_helper'
require_relative 'support/jobs_helpers.rb'
require 'json'

describe 'Job Offers in CA' do
include JobsHelpers

describe 'Getting the route of the service'  do
    #Happy Path of root
    it 'Should return ok' do
        get '/'
        last_response.must_be :ok?
    end
end

describe 'The sad path: Get' do
    it 'Should return 404 for unknown categories of jobs offers' do
        get "/api/v1/job_openings/#{random_string(35)}.json"
        last_response.must_be :not_found?
    end
end

  describe 'Checking available job offers via POST /api/v1/joboffers' do
    #Happy path of /api/v1/joboffers
    it 'should find jobs' do
      header = { 'CONTENT_TYPE' => 'application/json' }
      body = {
        description: 'Check a valid category',
        category: ['marketing-ventas']
      }

      post '/api/v1/joboffers', body.to_json, header
      last_response.must_be :redirect?
      follow_redirect!
      last_request.url.must_match /api\/v1\/offers\/\d+/
    end



     it 'should return 400 for bad JSON formatting' do
	header = { 'CONTENT_TYPE' => 'application/json' }
	body = random_string(50)
	post '/api/v1/joboffers', body, header
	last_response.must_be :bad_request?
     end

  end

  describe 'Testing for sad/happy paths on GET /api/v1/job_openings/:category.json' do

    #Happy path
    it 'should return jobs' do
      get '/api/v1/job_openings/marketing.json'
      last_response.must_be :ok?
    end

        #Sad paths goes here!
     it 'should return 404 not found' do
      get '/api/v1/job_openings/falsecategory.json'
      last_response.must_be :not_found?
    end

  end

  describe 'Testing for sad/happy paths on GET /api/v1/job_openings/:category/city/:city.json' do
    #happy path :)
   it 'should return jobs' do
     get '/api/v1/job_openings/marketing-ventas/city/Nicaragua.json'
     last_response.must_be :ok?
   end
   it 'should return 404 not found' do
     get '/api/v1/job_openings/marketing-ventas/city/Taiwan.json'
     last_response.must_be :not_found?
   end
 end

 describe 'Testing for sad/happy paths on GET /joboffers' do

    #Happy path
    it 'should return jobs' do
      get '/joboffers'
      last_response.must_be :ok?
    end

        #Sad paths goes here!
     it 'should return 302' do
      get '/joboffers/falsecategory'
      last_response.must_be :redirect?
    end

  end

 describe 'Testing for sad/happy paths on GET /joboffers/category' do

    #Happy path
    it 'should return jobs' do
      get '/joboffers/marketing'
      last_response.must_be :ok?
    end

        #Sad paths goes here!
     it 'should return 302' do
      get '/joboffers/falsecategory'
      last_response.must_be :redirect?
    end

  end
end
