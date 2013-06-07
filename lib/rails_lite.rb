require_relative 'rails_lite/controller_base'
require_relative 'rails_lite/router'
require 'webrick'

server = WEBrick::HTTPServer.new(
  :Port => 8080
)

trap('INT') { server.shutdown }

server.mount_proc '/' do |req, res|
  MyController.new(req, res)
end

server.start

class MyController < ControllerBase
  def go
    redirect_to 'www.google.com' if @request == '/redirect'
  end
end