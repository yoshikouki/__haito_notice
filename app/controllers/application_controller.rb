class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  #require 'net/https'
  #require 'URI'

  # WebAPIからXML取得後、Hash化
  # TDnet（適時開示情報）のWEB-APIプロジェクト（非公式）by Yanoshin
  # https://webapi.yanoshin.jp/tdnet/
  def tds_hash(td_list)
    # 銘柄コード（もしくは条件）とオプションをまとめる
    params = td_list[:params][:company] + td_list[:params][:format]
    query = td_list[:query].to_query
    # WebAPIを叩く
    uri = URI("https://webapi.yanoshin.jp/webapi/tdnet/list/" + 
              "#{params}?#{query}" )
    get = Net::HTTP::Get.new(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(get)
    # XMLをデコード、ハッシュ型に変換
    @res_hash = Hash.from_xml(res.body)

    # h1タイトル
    @title = @res_hash["TDnetList"]["condition_desc"]
    # TDnet情報リスト
    @tds = @res_hash["TDnetList"]["items"]["item"]
  end
  
  
end
