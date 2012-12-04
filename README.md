# CoinRack

A simple [Rack](http://rack.github.com/) application that provides a
REST interface to [Coin's API](https://github.com/hopsoft/coin).

## Quick Start

### Run the server

```bash
$ gem install coin_rack
$ coin_rack --run
```

### Make some client requests

```bash
$ curl --data "value=true" http://localhost:9292/example.json
# => {"example":true}

$ curl http://localhost:9292/example.json
# => {"example":true}

$ curl -X DELETE http://localhost:9292/example.json
# => {"example":null}

$ curl http://localhost:9292/example.json
# => {"example":null}
```

#### Prefer XML?
```bash
$ curl --data "value=true" http://localhost:9292/example.xml
# <?xml version="1.0" encoding="UTF-8"?>
# <hash>
#   <example type="boolean">true</example>
# </hash>

$ curl http://localhost:9292/example.xml
# <?xml version="1.0" encoding="UTF-8"?>
# <hash>
#   <example type="boolean">true</example>
# </hash>

$ curl -X DELETE http://localhost:9292/example.xml
# <?xml version="1.0" encoding="UTF-8"?>
# <hash>
#   <example nil="true"/>
# </hash>

$ curl http://localhost:9292/example.xml
# <?xml version="1.0" encoding="UTF-8"?>
# <hash>
#   <example nil="true"/>
# </hash>
```

## URL Definition

```
                  cache key
                       |
http://localhost:9292/KEY.FORMAT
                            |
                    response format
```

*Note: The XML format is also supported but XML examples have been omitted for brevity.*

## POST/PUT

Create and/or update the key to a new value.

#### Params

* **value** - the value to assign

#### Request URI

```
http://localhost:9292/example.json
```

#### Request Body

```
value=true
```

#### Response

```
"{\"example\":\"true\"}"
```

## GET

Get the current value for the specified key.

#### Request URI

```
http://localhost:9292/example.json
```

#### Response

```
"{\"example\":\"true\"}"
```

## DELETE

Deletes the key.

#### Request URI

```
http://localhost:9292/example.json
```

#### Response

```
"{\"example\":null}"
```
