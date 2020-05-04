class TdisController < ApplicationController
  def daily
    # TDを読み込み
    @tdis = Tdi.new.daily("today", 30)
  end
end
