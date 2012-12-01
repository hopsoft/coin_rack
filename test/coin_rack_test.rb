require "net/http"
require "net/telnet"
require "uri"
require "json"
require "rexml/document"
require "bundler"
Bundler.require :default, :development

class CoinRackTest < MicroTest::Test

  before do
    @path = File.join(File.dirname(__FILE__), "..", "config.ru")
    @pid = spawn({}, "rackup #{@path}")

    # wait for the server to come up
    t = nil
    begin
      t = Net::Telnet.new "Host" => "localhost", "Port" => 9292
    rescue Exception => ex
    end
    while t.nil?
      begin
        t = Net::Telnet.new "Host" => "localhost", "Port" => 9292
      rescue Exception => ex
      end
    end

    @uri = URI.parse("http://localhost:9292")
  end

  after do
    Coin.stop_server
    Process.kill(9, @pid)
  end

  test "GET simple JSON data" do
    Coin.write "foo", :bar
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Get.new("/foo.json")
    response = http.request(request)
    data = JSON.parse(response.body)
    assert response.header["Content-Type"] == "text/json"
    assert response.body == "{\"foo\":\"bar\"}"
    assert data["foo"] == "bar"
  end

  test "GET complex JSON data" do
    Coin.write "foo", {
      "bar" => true,
      "nested" => {
        "inner" => "hi"
      }
    }
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Get.new("/foo.json")
    response = http.request(request)
    assert response.header["Content-Type"] == "text/json"
    assert response.body == "{\"foo\":{\"bar\":true,\"nested\":{\"inner\":\"hi\"}}}"
  end

  test "GET simple XML data" do
    Coin.write "foo", :bar
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Get.new("/foo.xml")
    response = http.request(request)
    doc = REXML::Document.new(response.body)
    assert response.header["Content-Type"] == "text/xml"
    assert response.body == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  <foo type=\"symbol\">bar</foo>\n</hash>\n"
    assert doc.elements.first.name == "hash"
    assert doc.elements.first.elements.first.name == "foo"
    assert doc.elements.first.elements.first.text == "bar"
  end

  test "GET complex XML data" do
    Coin.write "foo", {
      "bar" => true,
      "nested" => {
        "inner" => "hi"
      }
    }
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Get.new("/foo.xml")
    response = http.request(request)
    assert response.header["Content-Type"] == "text/xml"
    assert response.body == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  <foo>\n    <bar type=\"boolean\">true</bar>\n    <nested>\n      <inner>hi</inner>\n    </nested>\n  </foo>\n</hash>\n"
  end

# # Basic REST.
# # Most REST APIs will set semantic values in response.body and response.code.
# require "net/http"

# http = Net::HTTP.new("api.restsite.com")

# request = Net::HTTP::Post.new("/users")
# request.set_form_data({"users[login]" => "quentin"})
# response = http.request(request)
# # Use nokogiri, hpricot, etc to parse response.body.

# request = Net::HTTP::Get.new("/users/1")
# response = http.request(request)
# # As with POST, the data is in response.body.

# request = Net::HTTP::Put.new("/users/1")
# request.set_form_data({"users[login]" => "changed"})
# response = http.request(request)

# request = Net::HTTP::Delete.new("/users/1")
# response = http.request(request)

end
