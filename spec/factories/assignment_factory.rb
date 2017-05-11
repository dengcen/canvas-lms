#
# Copyright (C) 2011 - present Instructure, Inc.
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

module Factories
  def assignment_model(opts = {})
    course = opts.delete(:course) || opts[:context] || course_model(reusable:  true)
    # turn the group_category title into a group category "object"
    group_category = opts.delete(:group_category)
    @group_category = course.group_categories.create!(name: group_category) if group_category
    opts[:group_category] = @group_category if @group_category
    @assignment = factory_with_protected_attributes(course.assignments, assignment_valid_attributes.merge(opts))
    @a = @assignment
    @c = course
    @a
  end

  def assignment_valid_attributes
    {
      title: "value for title",
      description: "value for description",
      due_at: Time.zone.now,
      points_possible: "1.5"
    }
  end

  def assignment_with_override(opts={})
    assignment_model(opts)
    @override = @a.assignment_overrides.build
    @override.set = @c.default_section
    @override.save!
    @override
  end

  def differentiated_assignment(opts={})
    @assignment = opts[:assignment] || assignment_model(opts)
    @assignment.only_visible_to_overrides = true
    @assignment.save!
    @override = @assignment.assignment_overrides.build
    @override.set = opts[:course_section] || @course.default_section
    @override.save!
    @override
  end

  def create_assignments(course_ids, count_per_course = 1, fields = {})
    course_ids = Array(course_ids)
    course_ids *= count_per_course
    records = course_ids.each_with_index.map do |id, i|
      {
        context_id: id, context_type: 'Course', context_code: "course_#{id}",
        title: "#{id}:#{i}", grading_type: "points", submission_types: "none",
        workflow_state: 'published'
      }.merge(fields)
    end
    create_records(Assignment, records)
  end
end
