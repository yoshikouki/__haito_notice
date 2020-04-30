class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # ログイン機能
  include SessionsHelper

  # url_for関係メソッドでロケールを設定するよう上書き
  def default_url_options
    { locale: I18n.locale }
  end

  # WebAPIからXML取得後、Hash化
  # TDnet（適時開示情報）のWEB-APIプロジェクト（非公式）by Yanoshin
  # https://webapi.yanoshin.jp/tdnet/
  require 'net/https'
  require 'uri'
  def get_tds(ticker_symbol = "recent", limit = 30)
    # 銘柄コード（もしくは条件）とオプションをまとめる
    params = {  company:  ticker_symbol,
                format:   ".xml"
    }
    pr = params.values.join
    query =  {  limit:    limit, 
                #"hasXBRL": 0,
    }
    qu = query.to_query
    # WebAPIを叩く
    uri = URI("https://webapi.yanoshin.jp/webapi/tdnet/list/#{pr}?#{qu}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
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

  private
    # ログアウトしている場合、ログインページにリダイレクト
    def logged_in_user
      unless logged_in?
        flash[:warning] = "ご利用のページはログインが必要です。"
        redirect_to login_url
      end
    end

    # ログインしている場合、マイページにリダイレクト
    def logged_out_user
      if logged_in?
        flash[:info] = "ログアウトしてから再度お試しください。"
        redirect_to mypage_url
      end
    end
end
