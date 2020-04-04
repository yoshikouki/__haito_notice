require 'rails_helper'

RSpec.describe Watchlist, type: :model do
  describe "バリデーション" do
    let(:user) { FactoryBot.create(:user) }
    let(:company) { FactoryBot.create(:company) }
    let(:watchlist) { Watchlist.new(user_id: user.id, local_code: company.local_code) }

    it "正当性の評価" do
      expect(watchlist).to be_valid
    end

    it "user_idは必須" do
      watchlist.user_id = ""
      expect(watchlist).to be_invalid
    end

    it "local_codeは必須" do
      watchlist.local_code = ""
      expect(watchlist).to be_invalid
    end
  end
end
