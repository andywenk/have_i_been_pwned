#!/usr/bin/env ruby

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

require 'pathname'
require 'json'

module Hibp
  class ConfigurationReader
    attr_reader :pathname, :configuration_file, :json_from_configuration_file

    def initialize(pathname)
      @pathname                     = pathname
      @configuration_file           = get_configuration_file_from_string
      @json_from_configuration_file = read_configuration_from_file
    end

    private def get_configuration_file_from_string
      raise ConfigurationFileDoesNotExist unless File.exists?(pathname) 
      Pathname.new(pathname)
    end

    private def read_configuration_from_file
      configuration_file_content = File.read(configuration_file)
      parse_json_from_file(configuration_file_content)      
    end

    private def parse_json_from_file(configuration_file_content)
      JSON.parse(configuration_file_content)
      rescue JSON::ParserError => e
        InvalidConfigurationFileSyntax.new(e)
    end
  end
end