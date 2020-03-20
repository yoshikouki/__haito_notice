class TdsController < ApplicationController
  def daily
    # TDを読み込み
    ticker_symbol = "today"
    get_tds(ticker_symbol, 30 )
  end
end
