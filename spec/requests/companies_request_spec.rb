require 'rails_helper'

RSpec.describe "Companies", type: :request do
  feature "企業一覧ページ" do
    it '登録企業が一覧表示される' do
      create_list(:company, 50)
      visit companies_path
      expect(page).to have_content 'テスト株式会社50'
    end

    it 'セクター毎の一覧が表示される' do
      visit companies_path
      click_link '情報・通信業'
      expect(page).to have_content 'セクター別'
    end
  end
end
