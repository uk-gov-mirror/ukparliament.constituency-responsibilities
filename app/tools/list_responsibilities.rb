# frozen_string_literal: true

class ListResponsibilities < MCP::Tool
  title "List responsibilities"
  description "A tool to list responsibilities"
  input_schema(
    properties: {
    },
  )

  class << self
    def call
      responsibilities = Responsibility.all.order( 'label' )
      
      MCP::Tool::Response.new(
        [
          {
            type: "text",
            text: responsibilities.to_json,
          }
        ]
      )
    end
  end
end