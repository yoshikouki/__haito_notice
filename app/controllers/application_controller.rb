class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  #require 'net/https'
  #require 'URI'

  # WebAPIからXMLを取得
  # TDnet（適時開示情報）のWEB-APIプロジェクト（非公式）by Yanoshin
  # https://webapi.yanoshin.jp/tdnet/
  def tds_hash(td_list)
    query = td_list[:query].to_query
    uri = URI("https://webapi.yanoshin.jp/webapi/tdnet/list/" + 
              td_list[:company] + ".xml?" + 
              query )
    get = Net::HTTP::Get.new(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(get)
    # XMLをデコード、ハッシュ型に変換
    @res_hash = Hash.from_xml(res.body)
    @tds = @res_hash["TDnetList"]["items"]["item"]
  end
  
  
end
