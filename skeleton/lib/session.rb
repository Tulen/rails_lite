require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies.empty?
      # @res.cookies = {"_rails_lite_app"=>"{}"}
      @session = {}
    else
      @session = JSON.parse(req.cookies["_rails_lite_app"])
    end

  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    # res.set_cookie("_rails_lite_app", {path:"/", value: @session})
    res.set_cookie(JSON.generate("_rails_lite_app", {path:"/", value: @session}))
  end
end
