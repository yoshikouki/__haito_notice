require 'rails_helper'
require 'webmock'

RSpec.describe "StaticPages", type: :request do
  include SessionsHelper

  let(:user) { FactoryBot.create(:user) }
  let(:params) do
    {
      session: {
        email: user.email,
        password: user.password,
        remember_me: 0
      }
    }
  end

  before do
    # 外部APIへのアクセスをモック化
    WebMock.enable!
    url = "https://webapi.yanoshin.jp/webapi/tdnet/list/recent.xml?limit=10"
    res_xml = Rails.root.join("spec/fixtures/recent_tds.xml")
    WebMock.stub_request(:any, url)
           .to_return(
             body: File.read(res_xml),
             status: 200,
             headers: { 'Content_Type' => 'application/xml' }
           )
    # 登録した外部API以外のリクエストを許可する場合はコメントアウト
    # WebMock.allow_net_connect!(:net_http_connect_on_start => true)
  end

  # feature do
  #   it "WebMock確認用" do
  #     get_tds
  #     expect(@page_title).to eq "最新順の適時開示情報一覧"
  #   end
  # end

  feature "#home" do
    it "最新情報が表示されている" do
      visit root_path
      expect(page).to have_content 'テスト株式会社'
    end

    it "最新の適時開示情報は10件まで表示される" do
      visit root_path
      expect(page).to have_content 'テストタイトル10'
    end

    context "ログイン時" do
      xit "マイページリンクが表示" do
        visit root_path
        post login_path(params)
        expect(page).to have_content user.name
      end

      xit "ウォッチがなかった場合はウォッチするボタンを表示"
    end

    context "未ログイン時" do
      it "ログインリンクが表示" do
        visit root_path
        expect(page).to have_content 'ログイン'
      end
    end
  end
end
