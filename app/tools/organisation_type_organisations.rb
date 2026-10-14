# frozen_string_literal: true

class OrganisationTypeOrganisations < MCP::Tool
  title "List organisations by type"
  description "A tool to list organisations by their type"
  input_schema(
    properties: {
      organisation_type_label: { type: "string" },
    },
    required: ["organisation_type_label"],
  )

  class << self
    def call( organisation_type_label: )
      organisations = Organisation.find_by_sql(
        [
          "
            SELECT
              o.id,
              o.label,
              o.code,
              o.parent_organisation_id
            FROM
              organisations o,
              organisation_typings otg,
              organisation_types ot
            WHERE o.id = otg.organisation_id
            AND otg.organisation_type_id = ot.id
            AND ot.label = ?
            ORDER BY o.label
          ", organisation_type_label
        ]
      )
      MCP::Tool::Response.new([{
        type: "text",
        text: organisations.to_json,
      }])
    end
  end
end