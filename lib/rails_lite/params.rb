require 'uri'
require 'json'

class Params
  def initialize(req, route_params)
    @params = {} if req.query_string.nil? || req.query_string.empty?
    @params = parse_www_encoded_form(req.query_string)

    if req.request_method == "POST"
      body_params = parse_www_encoded_form(req.body)
    end

    @params.merge(body_params)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    URI.decode_www_form(www_encoded_form) # TODO make this work with parse_key
  end

  def parse_key(key)
    if key.scan(/(\w+)\[(.+)\]/).first
      key = $1
      [key] + parse_key($2)
    else
      [key]
    end
  end

  def build_nested_params(keys)
    if keys.count == 1
      keys.first
    else
      {keys.first => build_nested_params(keys[1..-1]) }
    end
  end

end
