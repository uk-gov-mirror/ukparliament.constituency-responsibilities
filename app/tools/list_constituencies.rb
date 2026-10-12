# frozen_string_literal: true

class ListConstituencies < MCP::Tool
  title "List constituencies"
  description "A tool to list current constituencies"
  input_schema(
    properties: {
    },
  )

  class << self
    def call
      constituencies = ConstituencyArea.find_by_sql(
        "
          SELECT
            ca.*,
            region.name AS region_name,
            region.geographic_code AS region_geographic_code,
            country.name AS country_name,
            country.geographic_code AS country_geographic_code
          
          FROM constituency_areas ca
          INNER JOIN (
            SELECT *
            FROM boundary_sets
            WHERE end_on IS NULL
          ) AS boundary_set
          ON ca.boundary_set_id = boundary_set.id
          LEFT JOIN (
            SELECT *
            FROM english_regions
          ) AS region
          ON ca.english_region_id = region.id
          INNER JOIN (
            SELECT *
            FROM countries
          ) AS country
          ON ca.country_id = country.id
          ORDER BY ca.name
        "
      )
      
      MCP::Tool::Response.new([{
        type: "json",
        text: constituencies.to_json,
      }])
    end
  end
end