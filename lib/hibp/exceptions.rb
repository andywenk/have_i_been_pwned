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

module Hibp
  class MissingOptions < StandardError
    def initialize
      super
      puts "You need to specify at least one option"
      exit(0)
    end
  end

  class ConfigurationFileDoesNotExist < StandardError
    def initialize
      super
      puts "\e[31mThe configuration file does not exist\e[0m"
      exit(0)
    end
  end

  class InvalidConfigurationFileSyntax < StandardError
    def initialize(e)
      super
      puts "\e[31mInvalid JSON syntax in configuration file:\e[0m\n\n"
      puts e.message
      exit(0)
    end
  end

  class ConfigurationFileMissing < StandardError
    def initialize
      super
      puts "\e[31mYou need to give the path to the configuration file with the option -c\e[0m"
      exit(0)
    end
  end
end