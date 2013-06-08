require 'webrick'
require_relative './controller_base.rb'

class MyController < ControllerBase
  def go
    redirect_to('http://www.google.com') if @req.path == '/redirect'
  end
end

server = WEBrick::HTTPServer.new(
  :Port => 8080
)

trap('INT') { server.shutdown }

server.mount_proc '/' do |req, res|
  res.content_type = 'text/text'
  res.body = req.path
  p "THIS IS THE REQUEST"
  p req
  p "THIS IS THE RESPONSE"
  p res
  MyController.new(req, res).render
end

server.start