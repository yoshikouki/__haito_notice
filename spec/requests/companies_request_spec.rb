require 'rails_helper'

RSpec.describe "Companies", type: :request do
  feature "全企業一覧" do
    scenario 'ページタイトルは表示されている' do
      visit companies_path
      expect(page).to have_title '上場企業一覧（全企業） | 配当ノーティス'
    end
  end
end
