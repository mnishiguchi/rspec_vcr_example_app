# frozen_string_literal: true

class ExampleApiClient
  EXAMPLE_API_URL="https://jsonplaceholder.typicode.com"

  def initialize
    @conn = ::Faraday.new(url: EXAMPLE_API_URL) do |builder|
      builder.request :json
      builder.response :json
      builder.response :logger if Rails.env.local?
    end
  end

  def list_todos
    @conn.get(
      "/todos", {}
    )
  end

  def get_todo(id)
    @conn.get(
      "/todos", { id: }
    )
  end
end
