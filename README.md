[![Lines of Code](http://img.shields.io/badge/lines_of_code-79-brightgreen.svg?style=flat)](http://blog.codinghorror.com/the-best-code-is-no-code-at-all/)
[![Code Status](http://img.shields.io/codeclimate/github/hopsoft/coin_rack.svg?style=flat)](https://codeclimate.com/github/hopsoft/coin_rack)
[![Dependency Status](http://img.shields.io/gemnasium/hopsoft/coin_rack.svg?style=flat)](https://gemnasium.com/hopsoft/coin_rack)
[![Build Status](http://img.shields.io/travis/hopsoft/coin_rack.svg?style=flat)](https://travis-ci.org/hopsoft/coin_rack)
[![Coverage Status](https://img.shields.io/coveralls/hopsoft/coin_rack.svg?style=flat)](https://coveralls.io/r/hopsoft/coin_rack?branch=master)
[![Downloads](http://img.shields.io/gem/dt/coin_rack.svg?style=flat)](http://rubygems.org/gems/coin_rack)

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
{"example":true}

$ curl http://localhost:9292/example.json
{"example":true}

$ curl -X DELETE http://localhost:9292/example.json
{"example":true}

$ curl http://localhost:9292/example.json
{"example":null}
```

#### Prefer XML?
```bash
$ curl --data "value=true" http://localhost:9292/example.xml
<?xml version="1.0" encoding="UTF-8"?>
<hash>
  <example type="boolean">true</example>
</hash>

$ curl http://localhost:9292/example.xml
<?xml version="1.0" encoding="UTF-8"?>
<hash>
  <example type="boolean">true</example>
</hash>

$ curl -X DELETE http://localhost:9292/example.xml
<?xml version="1.0" encoding="UTF-8"?>
<hash>
  <example type="boolean">true</example>
</hash>

$ curl http://localhost:9292/example.xml
<?xml version="1.0" encoding="UTF-8"?>
<hash>
  <example nil="true"/>
</hash>
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

Note the value returned is the value that was deleted.

```
"{\"example\":true}"
```

## Getting Serious

* [Running behind robust web servers](https://github.com/hopsoft/coin_rack/wiki/Running-behind-robust-web-servers)

