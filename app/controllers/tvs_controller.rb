require 'httparty'
require 'json'

class TvsController < ApplicationController
  def index
    @response = JSON.parse(HTTParty.get('https://teaching-vacancies.service.gov.uk/api/v1/jobs.json').body)['data']
  end
end
