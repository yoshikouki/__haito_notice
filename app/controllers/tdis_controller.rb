class TdisController < ApplicationController
  def daily
    # TDを読み込み
    # ticker_symbol = "today"
    @tdis = Tdi.new.daily("today", 30)
  end
end
