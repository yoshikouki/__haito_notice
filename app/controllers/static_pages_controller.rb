class StaticPagesController < ApplicationController

  def home
    # TDnetの最新情報を読み込み
    ticker_symbol = "recent"
    @recent = get_tds(ticker_symbol, 10 )

    # ウォッチリスト登録されている企業のTD情報を取得
    @user = current_user
    lcs = []
    wls = @user.watchlists
    if wls.empty?
      @tds = false
    else
      wls.each{ |wl| lcs << wl[:local_code] }
      param = lcs.join("-")
      @feed = get_tds(param, 10)
    end
  end
end
