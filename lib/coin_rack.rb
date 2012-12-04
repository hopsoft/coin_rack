require "bundler"
Bundler.require
require File.join(File.dirname(__FILE__), "coin_rack", "version")

Footing.patch! String, Footing::String
Footing.patch! Array, Footing::Array
Footing.patch! Hash, Footing::Hash

class CoinRack

  def call(env)
    begin
      request = Rack::Request.new(env)
      request.POST.cast_values!
      return favicon if request.path == "/favicon.ico"
      return get(request) if request.get?
      return post(request) if request.post?
      return put(request) if request.put?
      return delete(request) if request.delete?
    rescue Exception => ex
      [500, {"Content-Type" => "text/html"}, ["ERROR: #{ex}"]]
    end

    [400, {"Content-Type" => "text/html"}, ["BAD REQUEST"]]
  end

  protected

  def key(request)
    request.path.gsub(/\A\//, "")
  end

  def format(request)
    case request.accept_media_types.prefered
    when "application/json" then :json
    when "application/xml" then :xml
    else :unknown
    end
  end

  # CREATE
  def post(request)
    put(request)
  end

  # READ
  def get(request)
    k = key(request)
    f = format(request)
    result = {}
    result[k] = Coin.read(k)
    send f, result
  end

  # UPDATE
  def put(request)
    k = key(request)
    f = format(request)
    value = request.POST["value"]
    Coin.write k, value
    result = {}
    result[k] = value
    send f, result
  end

  # DELETE
  def delete(request)
    k = key(request)
    f = format(request)
    Coin.delete k
    result = {}
    result[k] = nil
    send f, result
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

  def favicon
    [200, { "Content-Type" => "test/plain" }, ["about:blank"]]
  end

end
