#
# Copyright (C) 2014 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require 'simplecov'

class CoverageTool
  def self.start(command_name)
    SimpleCov.merge_timeout(3600)
    SimpleCov.command_name(command_name)
    SimpleCov.start do
      SimpleCov.coverage_dir("#{ENV['WORKSPACE']}/coverage") if ENV['WORKSPACE']
      # no formatting by default, just get the json
      SimpleCov.at_exit {
        # generate an HTML report if this is running locally / not on jenkins:
        SimpleCov.result.format! unless ENV['WORKSPACE']
        SimpleCov.result
      }
    end
  end
end
