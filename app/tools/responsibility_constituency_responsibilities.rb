# frozen_string_literal: true

class ResponsibilityConstituencyResponsibilities < MCP::Tool
  title "List constituency responsibilities for a responsibility"
  description "A tool to list constituency responsibilities for a given responsibility"
  input_schema(
    properties: {
      responsibility_label: {
        type: "string",
        description:"The label for a responsibility, for example: Adult skills fund"
      },
    },
    required: ["responsibility_label"],
  )

  class << self
    def call( responsibility_label: )
      organisation_responsibilities = ConstituencyResponsibility.find_by_sql(
        [
          "
            SELECT
              ca.* AS constituency_name,
              o.label AS organisation_name,
              o.code AS organisation_code,
              caoo.constituency_area_population_overlap AS population_coverage_percent
            FROM
              constituency_responsibilities cr,
              responsibilities r,
              constituency_areas ca,
              organisations o,
              constituency_area_organisation_overlaps caoo
            WHERE cr.responsibility_id = r.id
            AND r.label = ?
            AND cr.constituency_area_id = ca.id
            AND cr.organisation_id = o.id
            AND cr.constituency_area_organisation_overlap_id = caoo.id
          ", responsibility_label
        ]
      )
      MCP::Tool::Response.new(
        [
          {
            type: "text",
            text: organisation_responsibilities.to_json,
          }
        ]
      )
    end
  end
end