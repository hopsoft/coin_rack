require File.join(File.dirname(__FILE__), "lib", "coin_rack")

use Rack::Static
use Rack::AbstractFormat
run CoinRack.new
