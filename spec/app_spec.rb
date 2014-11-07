require_relative 'spec_helper'
require_relative 'support/jobs_helpers.rb'
require_relative 'json'

describe 'Job Offers in CA' do
include JobsHelpers

describe 'Getting the route of the service'
    it 'Should return ok' do
        get '/'
        last_response.must_be :ok?
    end
end

describe 'The sad path: Get' do
    it 'Should return 404 for unknown categories of jobs offers' do
        get '/api/v1/job_openings/#{random_str(35)}.json'
        last_response.must_be :not_found?
    end
end

describe 'The sad path: Post' do
    it 'Should return 400 for bad request' do
        header = {'CONTENT_TYPE' => 'application/json'}
        body = random_str(145)
        post '/api/v1/job_openings/all', body, header
        last_response.must_be :bad_request?
    end
end

end
