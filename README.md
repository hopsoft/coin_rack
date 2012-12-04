# CoinRack

A Simple [Rack](http://rack.github.com/) application that provides a
REST interface to [Coin's API](https://github.com/hopsoft/coin).

## Quick Start

```bash
$ gem install coin_rack
$ coin_rack
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
example=value
```

#### Response

```
"{\"example\":\"value\"}"
```

## GET

Get the current value for the specified key.

#### Request URI

```
http://localhost:9292/example.json
```

#### Response

```
"{\"example\":\"value\"}"
```

## DELETE

Deletes the key.

#### Request URI

```
http://localhost:9292/example.json
```

#### Response

```
"{\"example\":\"value\"}"
```
