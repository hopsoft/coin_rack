require "net/http"
require "net/telnet"
require "uri"
require "json"
require "rexml/document"
require_relative "../lib/coin_rack"

class CoinRackTest < MicroTest::Test

  before do
    @path = File.join(File.dirname(__FILE__), "..", "config.ru")
    @pid = spawn({}, "rackup #{@path}")

    # wait for the server to come up
    sleep 0.1
    t = nil
    begin
      t = Net::Telnet.new "Host" => "localhost", "Port" => 9292
    rescue Exception => ex
    end
    while t.nil?
      begin
        t = Net::Telnet.new "Host" => "localhost", "Port" => 9292
      rescue Exception => ex
        sleep 0.1
      end
    end

    @uri = URI.parse("http://localhost:9292")
  end

  after do
    Coin.stop_server
    Process.kill(9, @pid)
  end

  test "GET JSON data" do
    Coin.write "example", "value"
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Get.new("/example.json")
    response = http.request(request)
    data = JSON.parse(response.body)
    assert response.header["Content-Type"] == "text/json"
    assert response.code == "200"
    assert response.body == "{\"example\":\"value\"}"
    assert data["example"] == "value"
  end

  test "GET complex JSON data" do
    Coin.write "example", {
      "value1" => true,
      "value2" => [1, 2, 3],
      "nested" => {
        "value1" => false,
        "value2" => [4, 5, 6]
      }
    }
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Get.new("/example.json")
    response = http.request(request)
    assert response.header["Content-Type"] == "text/json"
    assert response.code == "200"
    assert response.body == "{\"example\":{\"value1\":true,\"value2\":[1,2,3],\"nested\":{\"value1\":false,\"value2\":[4,5,6]}}}"
    assert JSON.parse(response.body)
  end

  test "GET XML data" do
    Coin.write "example", "value"
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Get.new("/example.xml")
    response = http.request(request)
    assert response.header["Content-Type"] == "text/xml"
    assert response.code == "200"
    assert response.body == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  <example>value</example>\n</hash>\n"
    assert REXML::Document.new(response.body)
  end

  test "GET complex XML data" do
    Coin.write "example", {
      "value1" => true,
      "value2" => [1, 2, 3],
      "nested" => {
        "value1" => false,
        "value2" => [4, 5, 6]
      }
    }
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Get.new("/example.xml")
    response = http.request(request)
    assert response.header["Content-Type"] == "text/xml"
    assert response.code == "200"
    assert response.body == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  <example>\n    <value1 type=\"boolean\">true</value1>\n    <value2 type=\"array\">\n      <value2 type=\"integer\">1</value2>\n      <value2 type=\"integer\">2</value2>\n      <value2 type=\"integer\">3</value2>\n    </value2>\n    <nested>\n      <value1 type=\"boolean\">false</value1>\n      <value2 type=\"array\">\n        <value2 type=\"integer\">4</value2>\n        <value2 type=\"integer\">5</value2>\n        <value2 type=\"integer\">6</value2>\n      </value2>\n    </nested>\n  </example>\n</hash>\n"
    assert REXML::Document.new(response.body)
  end

  test "POST returning JSON" do
    example = {
      "value" => {
        "value1" => true,
        "value2" => [1, 2, 3],
        "nested" => {
          "value1" => false,
          "value2" => [4, 5, 6]
        }
      }
    }
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Post.new("/example.json")
    request.body = example.to_param
    response = http.request(request)
    assert response.header["Content-Type"] == "text/json"
    assert response.code == "200"
    assert response.body == "{\"example\":{\"nested\":{\"value1\":false,\"value2\":[4,5,6]},\"value1\":true,\"value2\":[1,2,3]}}"
    assert JSON.parse(response.body)
    cached = Coin.read("example")
    assert (cached.keys - example["value"].keys).empty?
    assert (cached.values - example["value"].values).empty?
  end

  test "POST returning XML" do
    example = {
      "value" => {
        "value1" => true,
        "value2" => [1, 2, 3],
        "nested" => {
          "value1" => false,
          "value2" => [4, 5, 6]
        }
      }
    }
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Post.new("/example.xml")
    request.body = example.to_param
    response = http.request(request)
    assert response.header["Content-Type"] == "text/xml"
    assert response.code == "200"
    assert response.body == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  <example>\n    <nested>\n      <value1 type=\"boolean\">false</value1>\n      <value2 type=\"array\">\n        <value2 type=\"integer\">4</value2>\n        <value2 type=\"integer\">5</value2>\n        <value2 type=\"integer\">6</value2>\n      </value2>\n    </nested>\n    <value1 type=\"boolean\">true</value1>\n    <value2 type=\"array\">\n      <value2 type=\"integer\">1</value2>\n      <value2 type=\"integer\">2</value2>\n      <value2 type=\"integer\">3</value2>\n    </value2>\n  </example>\n</hash>\n"
    assert REXML::Document.new(response.body)
    cached = Coin.read("example")
    assert (cached.keys - example["value"].keys).empty?
    assert (cached.values - example["value"].values).empty?
  end

  test "PUT returning JSON" do
    example = {
      "value" => {
        "value1" => true,
        "value2" => [1, 2, 3],
        "nested" => {
          "value1" => false,
          "value2" => [4, 5, 6]
        }
      }
    }
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Put.new("/example.json")
    request.body = example.to_param
    response = http.request(request)
    assert response.header["Content-Type"] == "text/json"
    assert response.code == "200"
    assert response.body == "{\"example\":{\"nested\":{\"value1\":false,\"value2\":[4,5,6]},\"value1\":true,\"value2\":[1,2,3]}}"
    assert JSON.parse(response.body)
    cached = Coin.read("example")
    assert (cached.keys - example["value"].keys).empty?
    assert (cached.values - example["value"].values).empty?
  end

  test "PUT returning XML" do
    example = {
      "value" => {
        "value1" => true,
        "value2" => [1, 2, 3],
        "nested" => {
          "value1" => false,
          "value2" => [4, 5, 6]
        }
      }
    }
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Put.new("/example.xml")
    request.body = example.to_param
    response = http.request(request)
    assert response.header["Content-Type"] == "text/xml"
    assert response.code == "200"
    assert response.body == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  <example>\n    <nested>\n      <value1 type=\"boolean\">false</value1>\n      <value2 type=\"array\">\n        <value2 type=\"integer\">4</value2>\n        <value2 type=\"integer\">5</value2>\n        <value2 type=\"integer\">6</value2>\n      </value2>\n    </nested>\n    <value1 type=\"boolean\">true</value1>\n    <value2 type=\"array\">\n      <value2 type=\"integer\">1</value2>\n      <value2 type=\"integer\">2</value2>\n      <value2 type=\"integer\">3</value2>\n    </value2>\n  </example>\n</hash>\n"
    assert REXML::Document.new(response.body)
    cached = Coin.read("example")
    assert (cached.keys - example["value"].keys).empty?
    assert (cached.values - example["value"].values).empty?
  end

  test "DELETE returning JSON" do
    Coin.write "example", "value"
    assert Coin.read("example") == "value"
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Delete.new("/example.json")
    response = http.request(request)
    data = JSON.parse(response.body)
    assert response.header["Content-Type"] == "text/json"
    assert response.code == "200"
    assert response.body == "{\"example\":\"value\"}"
    assert Coin.read("example").nil?
  end

  test "DELETE returning XML" do
    Coin.write "example", "value"
    assert Coin.read("example") == "value"
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Delete.new("/example.xml")
    response = http.request(request)
    assert response.header["Content-Type"] == "text/xml"
    assert response.code == "200"
    assert response.body == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  <example>value</example>\n</hash>\n"
    assert REXML::Document.new(response.body)
    assert Coin.read("example").nil?
  end

end
