# frozen_string_literal: true

class ConstituencyConstituencyResponsibilities < MCP::Tool
  title "List constituency responsibilities in a constituency"
  description "A tool to list constituency responsibilities in a given constituency"
  input_schema(
    properties: {
      constituency_name: {
        type: "string",
        description:"The name of a constituency"
      },
    },
    required: ["constituency_name"],
  )

  class << self
    def call( constituency_name: )
      constituency_responsibilities = ConstituencyResponsibility.find_by_sql(
        [
          "
            SELECT
              cr.id,
              o.label AS organisation_name,
              r.label AS responsibility_label,
              caoo.constituency_area_population_overlap AS population_coverage_percent
            FROM
              constituency_responsibilities cr,
              organisations o,
              constituency_areas ca,
              responsibilities r,
              constituency_area_organisation_overlaps caoo
            WHERE cr.organisation_id = o.id
            AND cr.constituency_area_id = ca.id
            AND ca.name = ?
            AND cr.responsibility_id = r.id
            AND cr.constituency_area_organisation_overlap_id = caoo.id
          ", constituency_name
        ]
      )
      
      MCP::Tool::Response.new(
        [
          {
            type: "text",
            text: constituency_responsibilities.to_json,
          }
        ]
      )
    end
  end
end