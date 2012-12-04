# CoinRack

A simple [Rack](http://rack.github.com/) application that provides a
REST interface to [Coin's API](https://github.com/hopsoft/coin).

## Quick Start

Terminal 1

```bash
$ gem install coin_rack
$ coin_rack --run
```

Terminal 2

```bash
$ curl --data "value=true" http://localhost:9292/example.json
$ curl http://localhost:9292/example.json
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
