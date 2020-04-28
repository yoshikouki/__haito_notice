class StaticPagesController < ApplicationController

  def home
    # TDnetの最新情報を読み込み
    @recent = Td.new.recent(10)

    # ウォッチリスト登録されている企業のTD情報を取得
    if logged_in?
      @user = current_user
      wls = @user.watchlists
      if wls.empty?
        @tds = []
      else
        lcs = []
        wls.each{ |wl| lcs << wl[:local_code] }
        param = lcs.join("-")
        @tds = Td.new.company(param, 10)
      end
    end
  end
end
