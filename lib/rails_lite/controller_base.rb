require 'erb'
require_relative 'params'
require_relative 'session'
require 'erb'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @route_params = route_params
  end

  def session
    @session ||= Session.new(@req)
  end

  def params
    @params ||= Params.new(@req, @route_params)
  end

  def already_rendered?
    @already_rendered || false
  end

  def redirect_to(url)
    raise "already rendered" if already_rendered?
    @res.status = '302'
    @res["location"] = url
    @already_rendered = true
    session.store_session(@res)
  end

  def render_content(content, type)
    raise "already rendered" if already_rendered?

    @res.content_type = type
    @res.body = content

    @already_rendered = true
    session.store_session(@res)
  end

  def render(action_name)
    controller_name = self.class.to_s.underscore
    filename = "views/#{controller_name}/#{action_name}.html.erb"
    template = ERB.new(File.read(filename))
    content = template.result(binding)
    render_content(content, 'text/html')
  end

  def invoke_action(name)
  end
end
