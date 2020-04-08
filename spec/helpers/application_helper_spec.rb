require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#full_title" do
    it "ページタイトルのデフォルト" do
      expect(full_title).to eq '配当ノーティス'
    end

    it "引数を渡す" do
      title = full_title("テスト画面")
      expect(title).to eq 'テスト画面 | 配当ノーティス'
    end
  end
end
