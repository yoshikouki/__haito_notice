class StaticPagesController < ApplicationController

  def home
    # TDnetの最新情報を読み込み
    @recent = Tdi.new.recent(10)

    # ウォッチリスト登録されている企業のTD情報を取得
    if logged_in?
      @user = current_user
      @tdis = Tdi.new.watching_tdis(@user, 10)
    end
  end
end
