require 'rails_helper'

RSpec.describe "統合テスト : Users", type: :system do
  include SessionsHelper

  before do
    driven_by(:rack_test)
    # 外部APIへのアクセスをモック化
    create_webmock("recent.xml?limit=10", "recent_tds.xml")
  end

  let(:user) { FactoryBot.create(:user) }
  let(:jill) { FactoryBot.build(:jill) }

  describe "ホーム画面" do
    it "新規アカウント登録" do
      visit root_path
      click_on "ログイン"

      # アカウントを新規作成
      click_on "アカウント登録"
      within("#signup-form") do
        fill_in "user_name", with: jill.name
        fill_in 'user_email', with: jill.email
        fill_in 'user_password', with: jill.password
        fill_in 'user_password_confirmation', with: jill.password
      end
      expect { click_on 'commit' }.to change(User, :count).by(1)
      expect(page).to have_content "ご登録ありがとうございます！"

      # アカウントを削除
      within("header") do
        click_on jill.name
      end
      expect { click_on 'アカウントを削除' }.to change(User, :count).by(-1)
      expect(page).to have_content "ユーザーは削除されました。"
    end

    it "ログインからログアウトまで" do
      visit root_path
      within("header") do
        expect(page).to have_content "ログイン"
      end

      click_on "ログイン"
      within("#login-form") do
        fill_in 'session[email]', with: user.email
        fill_in 'session[password]', with: user.password
        click_on 'commit'
      end
      within("header") do
        expect(page).to have_content user.name
      end

      # ウォッチリストが空なら企業を探すが表示されている
      # ホーム画面のフィード
      expect(page).to have_content "企業を探す"
      # マイページ画面のフィード
      click_on user.name
      expect(page).to have_content "企業を探す"
      # フィード画面のフィード
      click_on 'TDフィード'
      expect(page).to have_content "企業を探す"

      # ログアウト
      within("header") do
        click_on user.name
      end
      click_on "ログアウト"
      expect(page).to have_content "ログアウトしました。"
    end
  end
end
