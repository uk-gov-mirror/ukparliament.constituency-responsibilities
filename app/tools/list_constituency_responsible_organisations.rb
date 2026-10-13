# frozen_string_literal: true

class ListConstituencyResponsibleOrganisations < MCP::Tool
  title "List constituency responsible organisations"
  description "A tool to list organisations having a given responsibility in a given constituency"
  input_schema(
    properties: {
      constituency_name: { type: "string" },
      responsibility_label: { type: "string" },
    },
    required: ["constituency_name", "responsibility_label"],
  )

  class << self
    def call(constituency_name:, responsibility_label:)
      organisation_responsibilities = ConstituencyResponsibility.find_by_sql(
        [
          "
            SELECT
              o.id,
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
            AND ca.name = ?
            AND cr.organisation_id = o.id
            AND cr.constituency_area_organisation_overlap_id = caoo.id
          ", responsibility_label, constituency_name
        ]
      )
      MCP::Tool::Response.new([{
        type: "text",
        text: organisation_responsibilities.to_json,
      }])
    end
  end
end