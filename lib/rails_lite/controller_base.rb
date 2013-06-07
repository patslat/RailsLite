require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params)
    @req = req
    @res = res
    @route_params = route_params
  end

  def session
  end

  def already_rendered?
    @already_rendered || false
  end

  def redirect_to(url)
    if not already_rendered?
      @response.status = 302
      @response.header[] # set response
      @already_rendered = true

    else
      #already_rendered error?
    end
  end

  def render_content(content, type)
    if not already_rendered?
      @response.content_type = body_type
      @response.body = content

      @already_rendered = true
    else
      #already_rendered error?
    end
  end

  def render(template_name)
  end

  def invoke_action(name)
  end
end
