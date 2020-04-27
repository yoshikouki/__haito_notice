class TdsController < ApplicationController
  def daily
    # TDを読み込み
    # ticker_symbol = "today"
    @tds = Td.new.recent_tds
  end
end
