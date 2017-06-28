require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "error" if already_built_response?
    @res.add_header('location', url)
    @res.status = 302
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "error" if already_built_response?
    @res.write(content)
    @res["Content-Type"] = content_type
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = ActiveSupport::Inflector.underscore(self.class.to_s)
    template_content = File.read("views/#{controller_name}/#{template_name}.html.erb")
    template_content_erb = ERB.new(template_content).result(binding)
    render_content(template_content_erb, "text/html")
  end

  # method exposing a `Session` object
  def session
    # p @req.cookies
    # if @req.cookies.empty?
    #   # @res.cookies = {"_rails_lite_app"=>"{}"}
    #   @session = {}
    # else
    #   @session = JSON.parse(@req.cookies["_rails_lite_app"])
    # end
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
