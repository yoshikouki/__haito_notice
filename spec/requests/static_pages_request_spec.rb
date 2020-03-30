require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "#home" do
    context "未ログイン時" do
      it "ログインリンクが表示"
    end

    context "ログイン時" do
      it "マイページリンクが表示"
      it "ウォッチがなかった場合はウォッチするボタンを表示"
    end
  end
end
