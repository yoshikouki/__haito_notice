class StaticPagesController < ApplicationController

  def home
    # TDnetの最新情報を読み込み
    @recent = Td.new.recent(10)

    # ウォッチリスト登録されている企業のTD情報を取得
    if logged_in?
      @user = current_user
      @tds = Td.new.watching_tdis(@user, 10)
    end
  end
end
