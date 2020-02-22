class CompaniesController < ApplicationController

  def show
    # 証券コードを取得し、その証券コードでTDnetから情報を取得
    ticker_symbol = params["id"]
    get_tds(ticker_symbol, 30)
  end
  
  # 銘柄コード検索で呼び出し
  def search
    redirect_to "/companiess/#{params['ticker_symbol']}"
  end
end

