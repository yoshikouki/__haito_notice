class Td
  include ActiveModel::Model

  attr_accessor :info_name

  def new
    # 銘柄コード（もしくは条件）とオプションをまとめる
    params = { company: ticker_symbol,
               format:  ".xml" }
    pr = params.values.join
    query = { limit: limit }
    qu = query.to_query
    # WebAPIを叩く
    uri = URI("https://webapi.yanoshin.jp/webapi/tdnet/list/#{pr}?#{qu}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    return false if res.body == "Invalid Request"

    # XMLをデコード、ハッシュ型に変換
    @res_hash = Hash.from_xml(res.body)
    # h1タイトル
    @page_title = @res_hash["TDnetList"]["condition_desc"]
    # TDnet情報リスト
    @tds = @res_hash["TDnetList"]["items"]["item"]
  end
end
