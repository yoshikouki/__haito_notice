require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
    # 外部APIへのアクセスをモック化
    create_webmock("recent.xml?limit=10", "recent_tds.xml")
  end

  let(:user) { FactoryBot.create(:user) }

  describe "ログイン時" do
    before do
      visit root_path
      click_on 'ログイン'
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password
      click_on 'commit'
    end

    it "ログインできている" do
      expect(page).to have_content user.name
    end

    context "企業をウォッチしてない場合" do
      it "ホーム画面のフィードは企業一覧リンク" do
        expect(page).to have_content "企業を探す"
      end

      it "マイページ画面のフィードは企業一覧リンク" do
        click_on user.name
        expect(page).to have_content "企業を探す"
      end

      it "フィード画面は企業一覧リンク" do
        click_on user.name
        click_on 'TDフィード'
        expect(page).to have_content "企業を探す"
      end
    end
  end
end
