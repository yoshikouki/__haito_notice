class StaticPagesController < ApplicationController

  def home
    # TDnetの最新情報を読み込み
    ticker_symbol = "recent"
    get_tds(ticker_symbol, 30)
  end
end
