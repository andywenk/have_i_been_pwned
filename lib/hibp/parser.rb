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
require_relative 'Options'

module Hibp
  class Parser
    def self.execute    
      
      options = Hibp::Options.new
      
      OptionParser.new do |opts|
        opts.program_name = 'hipb'
        opts.version      = Hibp::VERSION
        opts.on_head('')
        opts.on_tail('')
        
        opts.on('--allb', TrueClass, 'If set, get all known breaches!') do |allb|
          options.retrieve_all_breaches_for = allb
        end

        opts.on('-s STRING', String, 'Get info about a single breach - must be a domain name') do |single_breach|
          options.retrieve_single_breach_for = single_breach
        end

        opts.on('-b', TrueClass, 'If set, retrieve info about the breaches for the websites from the configuration file') do |s|
          options.retrieve_breaches_for_websites_from_configuration = s
        end

        opts.on('-l', TrueClass, 'If set, retrieve info about the breaches for the email addresses from the emails list in the configuration file') do |l|
          options.retrieve_breaches_for_emails_from_configuration = l
        end

        opts.on('-e STRING', String, 'Retrive info about breaches for a single email email address') do |e|
          options.retrieve_breaches_for_single_email_address = e
        end

        opts.on('-c STRING', String, "Path to JSON configuration file \n#{@config}") do |configuration_file|
          configuration_reader = ConfigurationReader.new(configuration_file)
          options.json_from_configuration_file = configuration_reader.json_from_configuration_file
        end

        opts.on('-h', '--help', 'Print this help') do |h|
          puts Parser.info
          puts opts
          exit(0)
        end
      end.parse!
      
      options
      
      rescue OptionParser::MissingArgument => e
        puts "\e[31mThere is a missing argument for this option (#{e.message})\e[0m"
        exit(0)
      rescue OptionParser::InvalidOption => e
        puts "\e[31mThis option is invalid (#{e.message})\e[0m" 
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
end