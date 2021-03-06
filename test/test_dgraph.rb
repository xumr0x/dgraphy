require 'minitest/autorun'

require_relative '../lib/dgraphy'

class TestDgraph < Minitest::Test
  def test_create_schema
    client = Dgraphy::Client.new(host: "localhost", port: 8080)

    schema = 'Testschema: string @index(exact) .'
    assert client.alter(schema: schema, timeout: 30)

    query = %q(
      {
        set {
          _:test <Testschema> "hello this is from test" .
        }
      }
    )
    assert client.mutate(query: query, timeout: 30)
  end

  def test_query
    client = Dgraphy::Client.new(host: "localhost", port: 8080)
    query = '{ students(func: eq(Type, "Student")) { uid } }'

    body = client.query(query: query, timeout: 30)
    assert body != nil
    assert_equal body.dig(:data, :students).first.dig(:uid), "0xb"
  end
end