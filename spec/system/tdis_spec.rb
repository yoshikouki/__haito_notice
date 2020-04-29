require 'rails_helper'

RSpec.describe "Tdis", type: :system do
  before do
    driven_by(:rack_test)
    create_webmock("today.xml?limit=30", "recent_tdis.xml")
  end

  it "本日分のTD情報" do
    visit daily_path
    expect(page).to have_content "テスト株式会社1"
    expect(page).to have_content "テストタイトル30"
  end
end
