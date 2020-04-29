class Tdi
  include ActiveModel::Model

  attr_accessor :pub_date,
                :local_code,
                :company_name,
                :info_title,
                :info_url,
                :market_division

  def recent(limit)
    create_tdis("recent", limit)
  end

  def company(local_code, limit)
    create_tdis(local_code, limit)
  end

  def daily(date, limit)
    date ||= "today"
    create_tdis(date, limit)
  end

  def watching_tdis(user, limit)
    local_codes = user.watching_local_codes
    return false if local_codes.count.zero?

    create_tdis(local_codes.join("-"), limit)
  end

  def create_tdis(key, limit = 10)
    res = call_api(key, limit)
    return false if res.body.include?("Invalid Request")

    init_tdis = convert_response(res)
    convert_hash(init_tdis)
  end

  private

  def call_api(company = "recent", limit = 30)
    # 銘柄コード（もしくは条件）とオプションをまとめる
    params = {
      company: company,
      format:  ".xml"
    }.values.join
    query = {
      limit: limit
    }.to_query

    # WebAPIを呼び出す
    uri = URI("https://webapi.yanoshin.jp/webapi/tdnet/list/#{params}?#{query}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri)
    http.request(request)
  end

  def convert_response(response)
    # TD情報のXMLをデコード、ハッシュ型に変換
    item = Hash.from_xml(response.body)["TDnetList"]["items"]["item"]

    # レスポンス（TD情報）の数が1つの場合階層が違う
    if item.count >= 2
      item.map do |hash|
        hash["Tdnet"].transform_keys { |k| CONVERT_TABLE_KEY[k] || k }
      end
    elsif item.count == 1
      [item["Tdnet"].transform_keys { |k| CONVERT_TABLE_KEY[k] || k }]
    end
  end

  # TD情報ハッシュを変換
  def convert_hash(tdis)
    # 企業名をリスト化（準備工程）
    local_codes = tdis.map { |v| v["local_code"].chop }.uniq
    name_list = Company
                .select(:local_code, :company_name)
                .where(local_code: local_codes)
                .map { |v| [v.local_code, v.company_name] }
                .to_h

    tdis.each do |tdi|
      # info_urlを直URLに変換
      tdi["info_url"] = URI.parse(tdi["info_url"]).query
      # market_divisionを変換
      md = tdi["market_division"]
      tdi["market_division"] = CONVERT_TABLE_MARKET_DIVISION[md] || md
      # local_code文末の0を削除
      tdi["local_code"].chop!
      # 企業名をDB登録名に変換
      # レコードがない場合はそのまま使用
      tdi["company_name"] = \
        name_list[tdi["local_code"].to_i] || tdi["company_name"]
    end
  end

  # APIレスポンスのキーとDBカラム名（予定）の対応表
  CONVERT_TABLE_KEY = {
    "pubdate" => "pub_date",
    "company_code" => "local_code",
    "company_name" => "company_name",
    "title" => "info_title",
    "document_url" => "info_url",
    "markets_string" => "market_division"
  }.freeze

  # 市場区分の対応表
  CONVERT_TABLE_MARKET_DIVISION = {
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
