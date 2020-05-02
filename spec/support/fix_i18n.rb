class ActionDispatch::Routing::RouteSet
  def default_url_options(_options = {})
    { locale: I18n.default_locale }
  end
end
