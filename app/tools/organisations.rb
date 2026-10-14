# frozen_string_literal: true

class Organisations < MCP::Tool
  title "List organisations"
  description "A tool to list organisations"
  input_schema(
    properties: {
    },
  )

  class << self
    def call
      organisations = Organisation.all.order( 'label' )
      
      MCP::Tool::Response.new(
        [
          {
            type: "text",
            text: organisations.to_json,
          }
        ]
      )
    end
  end
end