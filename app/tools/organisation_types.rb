# frozen_string_literal: true

class OrganisationTypes < MCP::Tool
  title "List organisation types"
  description "A tool to list types of organisation, as defined by the House of Commons Library"
  input_schema(
    properties: {
    },
  )

  class << self
    def call
      organisation_types = OrganisationType.all.order( 'label' )
      
      MCP::Tool::Response.new(
        [
          {
            type: "text",
            text: organisation_types.to_json,
          }
        ]
      )
    end
  end
end