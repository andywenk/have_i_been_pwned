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

require 'optparse'
require 'ostruct'
require 'pp'

Params = Struct.new(
  :retrieve_all_breaches_for, 
  :retrieve_single_breach_for, 
  :retrieve_breaches_for_emails_from_configuration,
  :retrieve_breaches_from_configuration,
  :retrieve_breaches_for_single_email_address, 
  :json_from_configuration_file
  )

class Parser
  def self.execute    
    
    params = Params.new
    
    OptionParser.new do |opts|
      opts.on('-allb', 'Get all known breaches') do |all_breaches|
        params.retrieve_all_breaches_for = true
      end

      opts.on('-s STRING', String, 'Get info about a single breach - must be a domain name') do |single_breach|
        params.retrieve_single_breach_for = single_breach
      end

      opts.on('-b', 'Retrieve info about the breaches for the websites from the configuration file') do |s|
        params.retrieve_breaches_for_websites_from_configuration = true
      end

      opts.on('-l', 'Retrieve info about the breaches for the email addresses from the emails list in the configuration file') do |l|
        params.retrieve_breaches_for_emails_from_configuration = true
      end

      opts.on('-e STRING', String, 'Retrive info about breaches for a single email email address') do |email|
        params.retrieve_breaches_for_single_email_address = email
      end

      opts.on('-c STRING', String, "Path to JSON configuration file \n#{@config}") do |configuration_file|
        configuration_reader = ConfigurationReader.new(configuration_file)
        params.json_from_configuration_file = configuration_reader.json_from_configuration_file
      end

      opts.on('-h', '--help', 'Print this help') do |h|
        puts Parser.info
        puts opts
        exit(0)
      end
    end.parse!
    
    params
    
    rescue OptionParser::MissingArgument => e
      puts "There is a missing argument for this option (#{e.message})"
      exit(0)
    rescue OptionParser::InvalidOption => e
      puts "This option is invalid (#{e.message})" 
      exit(0)
  end

  def self.config 
<<-CONF
                                     {
                                       "breaches": [
                                         "Adobe"
                                       ],
                                       "emails": [
                                         "harry@belafonte.com",
                                         "stuart@hamilton.com"
                                       ],
                                       "api_key": "YOUR_API_KEY"
                                     }
CONF
  end

  def self.info
<<-INFO    
Welcome to this little programm. The purpose is to check, if you 
'have been pwned' with one of your email addresses. You can also 
get information about which websites have been breached (hacked).

You can get more information on https://haveibeenpwned.com/

This programm is using the API v3 https://haveibeenpwned.com/API/v3

INFO
  end
end