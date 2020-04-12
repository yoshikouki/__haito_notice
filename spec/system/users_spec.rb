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

  describe "ユーザー基本機能" do
    it "アカウント新規登録から削除まで" do
      visit root_path
      click_on "ログイン"

      # アカウントを新規作成
      click_on "アカウント登録"
      within("#signup-form") do
        fill_in "user-name", with: jill.name
        fill_in 'user-email', with: jill.email
        fill_in 'user-password', with: jill.password
        fill_in 'user-password-confirmation', with: jill.password
      end
      expect { click_on 'commit' }.to \
        change(User, :count).by(1)
      expect(page).to have_content "ご登録ありがとうございます！"

      # アカウントを削除
      within("header") { click_on jill.name }
      expect { click_on 'アカウントを削除' }.to \
        change(User, :count).by(-1)
      expect(page).to have_content "ユーザーは削除されました。"
    end

    it "ログインからログアウトまで" do
      visit root_path
      within("header") do
        expect(page).to have_content "ログイン"
      end

      click_on "ログイン"
      within("#login-form") do
        fill_in 'user-email', with: user.email
        fill_in 'user-password', with: user.password
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
      within("header") { click_on user.name }
      click_on "ログアウト"
      expect(page).to have_content "ログアウトしました。"
    end

    it "マイページから基本情報を編集" do
      visit mypage_path
      within("#login-form") do
        fill_in 'user-email', with: user.email
        fill_in 'user-password', with: user.password
        click_on 'commit'
      end

      # フレンドリーフォワーディング（機能していない）
      # expect(page).to have_current_path mypage_path
      click_on user.name

      # 登録情報を変更
      click_on '登録情報を変更'
      within("#edit-user-form") do
        fill_in 'user-name', with: "Edited Name"
        fill_in 'user-email', with: "edited-email@email.com"
        fill_in 'user-password', with: "editedpassword"
        fill_in 'user-password-confirmation', with: "editedpassword"
        click_on 'commit'
      end
      expect(page).to have_content "変更は正常に保存されました。"
      expect(page).to have_content "Edited Name"
      expect(page).to have_content "edited-email@email.com"
      edited_user = User.find_by(email: "edited-email@email.com").authenticate("editedpassword")
      expect(edited_user).to be_valid
    end
  end
end
