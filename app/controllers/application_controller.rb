class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  require 'net/https'
  require 'uri'

  # WebAPIからXML取得後、Hash化
  # TDnet（適時開示情報）のWEB-APIプロジェクト（非公式）by Yanoshin
  # https://webapi.yanoshin.jp/tdnet/
  def get_tds(ticker_symbol = "recent", limit = 30)
    # 銘柄コード（もしくは条件）とオプションをまとめる
    params = {  company:  ticker_symbol,
                format:   ".xml"
    }
    query =  {  limit:    limit, 
                #"hasXBRL": 0,
    }
    pr = params[:company] + params[:format]
    qu = query.to_query
    # WebAPIを叩く
    uri = URI("https://webapi.yanoshin.jp/webapi/tdnet/list/" + 
              "#{pr}?#{qu}" )
    get = Net::HTTP::Get.new(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(get)
    if res.body == "Invalid Request"
      return false
    else
      # XMLをデコード、ハッシュ型に変換
      @res_hash = Hash.from_xml(res.body)
      # h1タイトル
      @page_title = @res_hash["TDnetList"]["condition_desc"]
      # TDnet情報リスト
      @tds = @res_hash["TDnetList"]["items"]["item"]
    end
  end
  
  
end
