require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  feature "#home" do
    context "未ログイン時" do
      # APIを叩いているので要検討
      xit "ログインリンクが表示" do
        visit root_path
        expect(page).to have_content 'ログイン'
      end
    end

    context "ログイン時" do
      xit "マイページリンクが表示" do
        # 要：ログイン処理
        visit root_path
        expect(page).to have_content 'mypage'
      end

      xit "ウォッチがなかった場合はウォッチするボタンを表示"
    end
  end
end
