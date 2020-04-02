require 'rails_helper'

RSpec.describe "Companies", type: :request do
  feature "全企業一覧" do
    scenario 'ページタイトルは表示されている' do
      visit companies_path
      expect(page).to have_title '上場企業一覧 | 配当ノーティス'
    end

    xscenario '登録企業が一覧表示される' do
      visit companies_path
      expect(page).to have_selector \
        'a[href="/companies/1050"]', text: 'テスト株式会社50'
    end
  end
end
