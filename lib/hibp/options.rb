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
  Options = Struct.new(
    :retrieve_all_breaches_for, 
    :retrieve_single_breach_for, 
    :retrieve_breaches_for_emails_from_configuration,
    :retrieve_breaches_for_websites_from_configuration,
    :retrieve_breaches_from_configuration,
    :retrieve_breaches_for_single_email_address, 
    :json_from_configuration_file
  )
end