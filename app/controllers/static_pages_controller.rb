class StaticPagesController < ApplicationController
  
  require 'net/https'
  require 'URI'

  def home
    # WebAPIからXMLを取得
    # TDnet（適時開示情報）のWEB-APIプロジェクト（非公式）by Yanoshin
    # https://webapi.yanoshin.jp/tdnet/
    data = {
      "limit": 5,
    }
    query = data.to_query
    uri = URI("https://webapi.yanoshin.jp/webapi/tdnet/list/recent.xml?" + query)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    # XMLをデコード、ハッシュ型に変換
    res_date = Hash.from_xml(res.body)



    @xml = 
    @tds = 
  end
end
