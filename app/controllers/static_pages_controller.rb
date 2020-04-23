class StaticPagesController < ApplicationController

  def home
    # TDnetの最新情報を読み込み
    @recent = get_tds("recent", 10 )

    # ウォッチリスト登録されている企業のTD情報を取得
    if logged_in?
      @user = current_user
      lcs = []
      wls = @user.watchlists
      if wls.empty?
        @tds = []
      else
        wls.each{ |wl| lcs << wl[:local_code] }
        param = lcs.join("-")
        @feed = get_tds(param, 10)
      end
    end
  end
end
