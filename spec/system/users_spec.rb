require 'rails_helper'

RSpec.describe "統合テスト : Users", type: :system do
  include SessionsHelper

  before do
    driven_by(:rack_test)
    # 外部APIへのアクセスをモック化
    create_webmock("recent.xml?limit=10", "recent_tds.xml")
    # メールのテストのため、送信済みメールを初期化
    ActionMailer::Base.deliveries.clear
  end

  let(:user) { FactoryBot.create(:user) }
  let(:inact) { FactoryBot.build(:inact) }

  describe "CRUD" do
    it "アカウント新規登録" do
      visit root_path
      click_on "ログイン"

      # アカウントを新規作成
      click_on "アカウント登録"
      within("#signup-form") do
        fill_in "user-name", with: inact.name
        fill_in 'user-email', with: inact.email
        fill_in 'user-password', with: inact.password
        fill_in 'user-password-confirmation', with: inact.password
      end
      expect { click_on 'commit' }.to \
        change(User, :count).by(1)

      # 有効化メールの送信
      expect(find("header")).to have_content "ログイン"
      expect(page).to have_content "登録確認用のメールを送信しました。メールを確認し、アカウントを有効化してください"
      expect(ActionMailer::Base.deliveries.count).to eq 1
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

    it "アカウントの削除" do
      visit login_path
      within("#login-form") do
        fill_in 'user-email', with: user.email
        fill_in 'user-password', with: user.password
        click_on 'commit'
      end
      click_on user.name

      # アカウントを削除
      within("header") { click_on user.name }
      expect { click_on 'アカウントを削除' }.to \
        change(User, :count).by(-1)
      expect(page).to have_content "ユーザーは削除されました。"
    end
  end

  describe "ユーザー関連機能" do
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

    it "パスワードの再設定" do
      visit login_path
      click_on "password-reset-link"
      expect(page).to have_current_path new_password_reset_path
      within("#new-password-reset-form") do
        fill_in 'user-email', with: user.email
      end
      expect { click_on 'submit-password-reset' }.to \
        change { ActionMailer::Base.deliveries.count }.by(1)
      expect(page).to have_content "ご登録メールアドレスにパスワード再設定のURLを送信しました。"
    end
  end
end
