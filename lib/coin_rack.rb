require "bundler"
Bundler.require
require File.join(File.dirname(__FILE__), "coin_rack", "version")

class CoinRack

  def call(env)
    begin
      Coin.write :nate, "Nathan Hopkins"
      Coin.write :other, true

      request = Rack::Request.new(env)
      return favicon if request.path == "/favicon.ico"

      key = request.path.gsub(/\A\//, "")
      format = format(request)

      return get(key, format) if request.get?
      return post(key, format) if request.post?
      return put(key, format) if request.put?
      return delete(key, format) if request.delete?
    rescue Exception => ex
      [500, {"Content-Type" => "text/html"}, ["ERROR! #{ex}"]]
    end

    [400, {"Content-Type" => "text/html"}, ["BAD REQUEST"]]
  end

  protected

  def get(key, format)
    result = {}
    result[key] = Coin.read(key.to_sym)
    send format, result
  end

  def post(key, format)
  end

  def put(key, format)
  end

  def delete(key, format)
  end

  def json(result)
    [200, {"Content-Type" => "text/json"}, [result.to_json]]
  end

  def xml(result)
    [200, {"Content-Type" => "text/xml"}, [result.to_xml]]
  end

  def unknown
    [400, {"Content-Type" => "text/html"}, ["UNKNOWN FORMAT"]]
  end

  def format(request)
    case request.accept_media_types.prefered
    when "application/json" then :json
    when "application/xml" then :xml
    else :unknown
    end
  end

  def favicon
    [200, { "Content-Type" => "test/plain" }, ["about:blank"]]
  end

end
