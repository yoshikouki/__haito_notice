require 'rails_helper'

RSpec.describe "Watchlists", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:company) { FactoryBot.create(:company) }

  before do
    driven_by(:rack_test)
    # 外部APIへのアクセスをモック化
    create_webmock("recent.xml?limit=10", "recent_tds.xml")
    create_webmock("#{company.local_code}.xml?limit=30", "feed_tds.xml")
    create_webmock("#{company.local_code}.xml?limit=10", "feed_tds.xml")
    create_webmock("#{company.local_code}.xml?limit=3", "feed_tds.xml")
  end

  describe "ウォッチリスト機能" do
    it "ウォッチからアンウォッチまで" do
      visit login_path
      within("#login-form") do
        fill_in 'user-email', with: user.email
        fill_in 'user-password', with: user.password
        click_on 'commit'
      end

      # 銘柄コードで検索
      within("#ts-search") do
        fill_in 'ts-search-bar', with: company.local_code
        click_on 'ts-search-submit'
      end
      expect(page).to \
        have_current_path company_path(company.local_code)
      expect(page).to have_content "テスト株式会社1"
      # ウォッチする
      expect { click_on 'watch-btn' }.to \
        change { user.watchlists.count }.by(1)
      expect(page).to have_selector 'form button#unwatch-btn'
      # フィード確認
      click_on 'logo'
      expect(page).to have_content "フィードテストについてのお知らせ1"
      within("header") { click_on user.name }
      click_on "feed-link"
      expect(page).to have_content "フィードテストについてのお知らせ1"
      click_on "watchlist-link"
      expect(page).to have_content "テスト株式会社1"

      # アンウォッチする
      visit company_path(company.local_code)
      expect { click_on 'unwatch-btn' }.to \
        change { user.watchlists.count }.by(-1)
      expect(page).to have_selector 'form button#watch-btn'
      # フィード確認（ウォッチリストが空）
      within("header") { click_on user.name }
      click_on "feed-link"
      expect(page).to have_content "企業を探す"
      click_on "watchlist-link"
      expect(page).to have_content "企業を探す"
    end
  end
end
