require 'rails_helper'

RSpec.describe "Companies", type: :request do
  feature "全企業一覧" do
    scenario 'ページタイトルは表示されている' do
      visit companies_path
      expect(page).to have_title '上場企業一覧 | 配当ノーティス'
    end

    scenario '登録企業が一覧表示される' do
      Company.import FactoryBot.build_list(:company, 50)
      visit companies_path
      expect(page).to have_selector \
        'a', text: Company.find(10).company_name
    end
  end
end
