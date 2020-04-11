module WebmockHelpers
  # WebMockを作成し、外部へのアクセスに対してresponseのファイルを返す
  def create_webmock(url, file_name)
    WebMock.enable!
    url ||= "recent.xml?limit=10"
    request = "https://webapi.yanoshin.jp/webapi/tdnet/list/" + url
    response = Rails.root.join("spec/fixtures/", file_name)
    WebMock.stub_request(:any, request)
           .to_return(
             body: File.read(response),
             status: 200,
             headers: { 'Content_Type' => 'application/xml' }
           )
  end
end
