class Td
  include ActiveModel::Model

  attr_accessor :pub_date,
                :local_code,
                :company_name,
                :info_title,
                :info_url,
                :market_division

  def recent_tds(limit = 10)
    res = call_api("recent", limit)
    converting_response(res)
  end

  private

  def call_api(company = "recent", limit = 30)
    # 銘柄コード（もしくは条件）とオプションをまとめる
    params = { company: company,
               format:  ".xml" }
    pr = params.values.join
    query = { limit: limit }
    qu = query.to_query

    # WebAPIを呼び出す
    uri = URI("https://webapi.yanoshin.jp/webapi/tdnet/list/#{pr}?#{qu}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    response = http.request(req)
    return false if response.body == "Invalid Request"

    response
  end

  CONVERT_KEY = {
    "pubdate" => "pub_date",
    "company_code" => "local_code",
    "company_name" => "company_name",
    "title" => "info_title",
    "document_url" => "info_url",
    "markets_string" => "market_division"
  }.freeze

  CONVERT_MARKET_DIVISION = {
    "東" => "東証",
    "東名" => "名証",
    "札" => "札証",
    "福" => "福証",
    "市場第一部（内国株）" => "東証1",
    "市場第一部（外国株）" => "東証1",
    "市場第二部（内国株）" => "東証2",
    "市場第二部（外国株）" => "東証2",
    "JASDAQ(スタンダード・内国株）" => "JASDAQ",
    "JASDAQ(グロース・内国株）" => "JASDAQ",
    "JASDAQ(スタンダード・外国株）" => "JASDAQ",
    "マザーズ（外国株）" => "マザーズ",
    "マザーズ（内国株）" => "マザーズ",
    "ETF・ETN" => "ETF",
    "REIT・ベンチャーファンド・カントリーファンド・インフラファンド" => "REIT",
    "出資証券" => "証券",
    "PRO Market" => "PRO"
  }.freeze

  def converting_response(response)
    # XMLをデコード、ハッシュ型に変換
    res_hash = Hash.from_xml(response.body)
    return unless res_hash["TDnetList"]["items"]["item"].count >= 2

    # TDnet情報リスト
    # Array配列の中にHashで情報が入っている。keyはAPI準拠。
    init_tds = res_hash["TDnetList"]["items"]["item"].map do |v|
      v["Tdnet"]
    end

    # keysをDBカラムに変換
    converted_keys = init_tds.map do |h|
      h.transform_keys { |k| CONVERT_KEY[k] || k }
    end

    # info_urlを直URLに変換
    converted_keys.each do |h|
      h["info_url"] = URI.parse(h["info_url"]).query
    end

    # market_divisionをコンバート
    converted_keys.each do |h|
      md = h["market_division"]
      h["market_division"] = CONVERT_MARKET_DIVISION[md] || md
    end
  end
end
