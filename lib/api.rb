# Copyright [2021] [sum.cumo Sapiens GmbH]

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# frozen_string_literal: true

require 'faraday'

BASE_API_URL = 'https://haveibeenpwned.com/api/v3/'

class Api
  attr_reader :url, :api_section, :parameter, :base_api_url, :retrieve_all_breaches_for,
    :retrieve_single_breach_for, :retrieve_breaches_for_single_email_address, 
    :retrieve_breaches_for_emails_from_configuration, :retrieve_breaches_from_configuration,
    :json_result, :api_key, :json_from_configuration_file_is_not_available

  def initialize(params)
    @base_api_url       = BASE_API_URL
    @json_result        = []
    @retrieve_all_breaches_for    = params.retrieve_all_breaches_for
    @retrieve_single_breach_for   = params.retrieve_single_breach_for
    
    @json_from_configuration_file_is_not_available    = params.json_from_configuration_file.nil?

    @retrieve_breaches_from_configuration             = json_from_configuration_file_is_not_available ? [] : params.json_from_configuration_file['breaches']
    @retrieve_breaches_for_emails_from_configuration  = json_from_configuration_file_is_not_available ? [] : params.json_from_configuration_file['emails']
    @api_key                                          = json_from_configuration_file_is_not_available ? [] : params.json_from_configuration_file['api_key']
    
    @retrieve_breaches_for_single_email_address       = params.retrieve_breaches_for_single_email_address
  end

  def execute 
    if retrieve_all_breaches_for 
      @api_section = 'breaches'
      @json_result.push(create_and_fire_request)
    elsif retrieve_single_breach_for.is_a?(String)
      @api_section = 'breaches'
      @parameter = "?domain=#{retrieve_single_breach_for}"
      @json_result.push(create_and_fire_request)
    elsif retrieve_breaches_for_single_email_address.is_a?(String)
      raise ConfigurationFileMissing if json_from_configuration_file_is_not_available
      @api_section = 'breachedaccount'
      @parameter = "/#{retrieve_breaches_for_single_email_address}"
      @json_result.push(create_and_fire_request)
    elsif retrieve_breaches_for_emails_from_configuration
      raise ConfigurationFileMissing if json_from_configuration_file_is_not_available
      @api_section = 'breachedaccount'
      result = Hash.new
      retrieve_breaches_for_emails_from_configuration.each do |email|
        puts "... requesting info for #{email}"
        @parameter = "/#{email}"
        result[email] = create_and_fire_request
        sleep(2)
      end
      @json_result.push(result)
    end
  end

  def results_as_json
    json_result
  end
  
  private def create_and_fire_request
    create_request_string
    fire_request
  end

  private def create_request_string
    @url = [base_api_url, api_section, parameter].join
  end

  private def fire_request
    response = Faraday.get(url, {}, {'Accept' => 'application/json', 'hibp-api-key' => api_key})
    parsed_response_body(response.body)
  end

  private def parsed_response_body(response_body)
    response_body.empty? ? "" : JSON.parse(response_body, symbolize_names: true)
  end
end