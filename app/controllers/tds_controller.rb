class TdsController < ApplicationController
  def daily
    # TDを読み込み
    # ticker_symbol = "today"
    @tds = Td.new.daily("today", 30)
  end
end
