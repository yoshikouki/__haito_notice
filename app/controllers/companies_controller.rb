class CompaniesController < ApplicationController

  def index
    @companies = Company.all
  end

  def show
    # 証券コードを取得し、その証券コードでTDnetから情報を取得
    ticker_symbol = params["id"]
    get_tds(ticker_symbol, 30)
  end
  
  # 銘柄コード検索で呼び出し
  def search
    redirect_to "/companies/#{params['ticker_symbol']}"
  end

  # CompaniesDBをCSV(Excel)で更新
  def import_from 
    # fileは、tmpへ自動的に一時保存
    uploaded_file = params[:file]
    if uploaded_file.original_filename == "data_j.xls"
      Company.import(uploaded_file)
    else
      @error = "ファイルが不正です。"
    end
    redirect_to companies_url
  end

  private

    def fileupload_param(params)
      params.require(:import_from).permit(:file)
    end
end

