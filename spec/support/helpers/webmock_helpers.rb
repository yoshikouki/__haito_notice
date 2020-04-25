module WebmockHelpers
  # WebMockを作成し、外部へのアクセスに対してresponseのファイルを返す
  def create_webmock(url, file_name)
    WebMock.enable!

    # 引数の初期化
    url ||= "recent.xml?limit=10"
    file_name ||= "recent_tds.xml"

    request = "https://webapi.yanoshin.jp/webapi/tdnet/list/" + url
    response = Rails.root.join("spec/fixtures/", file_name)
    WebMock.stub_request(:any, request)
           .to_return(
             body:    File.read(response),
             status:  200,
             headers: { 'Content_Type' => 'application/xml' }
           )

    # 登録した外部API以外のリクエストを許可する場合はコメントアウト
    # WebMock.allow_net_connect!(:net_http_connect_on_start => true)
  end
end
