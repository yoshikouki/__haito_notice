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

  def converting_response(response)
    # TD情報のXMLをデコード、ハッシュ型に変換
    item = Hash.from_xml(response.body)["TDnetList"]["items"]["item"]

    # レスポンス（TD情報）の数が1つの場合階層が違う
    if item.count >= 2
      init_tds = item.map do |hash|
        hash["Tdnet"].transform_keys { |k| CONVERT_KEY[k] || k }
      end
    elsif item.count == 1
      init_tds = [item["Tdnet"].transform_keys { |k| CONVERT_KEY[k] || k }]
    end

    convert_hash(init_tds)
  end

  # TD情報ハッシュを変換
  def convert_hash(tds)
    # 企業名をリスト化（準備工程）
    local_codes = tds.map { |v| v["local_code"].chop }
    name_list = Company
                .select(:local_code, :company_name)
                .where(local_code: local_codes)
                .map do |v|
                  [v.local_code, v.company_name]
                end
                .to_h

    tds.each do |td|
      # info_urlを直URLに変換
      td["info_url"] = URI.parse(td["info_url"]).query
      # market_divisionを変換
      md = td["market_division"]
      td["market_division"] = CONVERT_MARKET_DIVISION[md] || md
      # local_code文末の0を削除
      td["local_code"].chop!
      # 企業名をDB登録名に変換
      # レコードがない場合はそのまま使用
      td["company_name"] = \
        name_list[td["local_code"].to_i] || td["company_name"]
    end
  end

  # APIレスポンスのキーとDBカラム名（予定）の対応表
  CONVERT_KEY = {
    "pubdate" => "pub_date",
    "company_code" => "local_code",
    "company_name" => "company_name",
    "title" => "info_title",
    "document_url" => "info_url",
    "markets_string" => "market_division"
  }.freeze

  # 市場区分の対応表
  CONVERT_MARKET_DIVISION = {
    # WebAPIとの対応表
    "東" => "東証",
    "東名" => "名証",
    "札" => "札証",
    "福" => "福証",
    # 東証公開の企業一覧との対応表
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
end
