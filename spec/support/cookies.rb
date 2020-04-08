# RSpecでcookies.signedがエラーになる対処
class Rack::Test::CookieJar
  def signed
    self
  end

  def permanent
    self
  end

  def encrypted
    self
  end
end
