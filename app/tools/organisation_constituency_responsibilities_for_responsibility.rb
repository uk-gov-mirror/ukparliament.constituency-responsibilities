# frozen_string_literal: true

class OrganisationConstituencyResponsibilitiesForResponsibility < MCP::Tool
  title "List constituency responsibilities by organisation"
  description "A tool to list constituency responsibilities for a given organisation"
  input_schema(
    properties: {
      organisation_name: {
        type: "string",
        description:"The name of an organisation"
      },
      responsibility: {
        type: "string",
        description:"The label of a responsibility"
      },
    },
    required: ["organisation_name", "responsibility"],
  )

  class << self
    def call( organisation_name:, responsibility: )
      constituency_responsibilities = ConstituencyResponsibility.find_by_sql(
        [
          "
            SELECT
              cr.id,
              ca.name AS constituency_name,
              caoo.constituency_area_population_overlap AS population_coverage_percent
            FROM
              constituency_responsibilities cr,
              organisations o,
              constituency_areas ca,
              responsibilities r,
              constituency_area_organisation_overlaps caoo
            WHERE cr.organisation_id = o.id
            AND o.label = ?
            AND cr.constituency_area_id = ca.id
            AND cr.responsibility_id = r.id
            AND r.label = ?
            AND cr.constituency_area_organisation_overlap_id = caoo.id
          ", organisation_name, responsibility
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