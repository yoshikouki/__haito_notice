class CompaniesController < ApplicationController

  before_action :sector_list, only:[:index, :sectors]

  def index
    @companies = Company.order(:tsi_code).page(params[:page]).per(50)
  end

  def show
    # 証券コードを取得し、その証券コードでTDnetから情報を取得
    ticker_symbol = params["id"]
    unless get_tds(ticker_symbol, 30)
      redirect_to controller: 'static_pages', action: 'home' 
    end
  end
  
  # 銘柄コード検索で呼び出し
  def search
    redirect_to "/companies/#{params['ticker_symbol']}"
  end

  # 東証33業種で検索
  def sectors
    tsi_code = params[:id]
    @companies = Company.where(tsi_code: tsi_code).page(params[:page]).per(50)
    redirect_to companies_url if @companies.empty?
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

    def sector_list
      #Listリンク用に:tsi_codeを引き抜く
      @tsi = Company.select(:tsi_code, :topix_sector_indices).distinct
      # List表示用
      @tsi_count = Company.group(:topix_sector_indices).count
      #@sector_list = tsi_count.sort_by{ |_, v| v }.reverse.to_h
    end
end

