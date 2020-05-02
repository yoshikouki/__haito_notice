class CompaniesController < ApplicationController

  before_action :sector_list, only:[:index, :sectors]

  def index
    @companies = Company.order(:tsi_code)
                        .page(params[:page])
                        .per(50)
  end

  def show
    # 証券コードを取得し、その証券コードでTDnetから情報を取得
    local_code = params["id"]
    @tdis = Tdi.new.company(local_code, 30)
    unless @tdis
      flash[:warning] = "銘柄コードが不正です"
      redirect_to root_path
    else
      @company = Company.find_by(local_code: local_code)
    end
  end
  
  # 銘柄コード検索で呼び出し
  def search
    redirect_to company_path(params[:local_code])
  end

  # 東証33業種で検索
  def sectors
    tsi_code = params[:id]
    @companies = Company.where(tsi_code: tsi_code)
                        .page(params[:page])
                        .per(50)
    if @companies.empty?
      flash[:warning] = "セクターコードが不正です"
      redirect_to companies_url 
    end
  end

  # CompaniesDBをCSV(Excel)で更新
  def import_from 
    # fileは、tmpへ自動的に一時保存
    uploaded_file = params[:file]
    if uploaded_file.original_filename == "data_j.xls"
      Company.import(uploaded_file)
    else
      flash.now[:danger] = "ファイルが不正です。"
    end
    redirect_to companies_url
  end

  private

    def fileupload_param(params)
      params.require(:company).permit(:file)
    end

    def sector_list
      #Listリンク用に:tsi_codeを引き抜く
      @tsi = Company.select(:tsi_code, :topix_sector_indices).distinct
      # List表示用
      @tsi_count = Company.group(:topix_sector_indices).count
      #@sector_list = tsi_count.sort_by{ |_, v| v }.reverse.to_h
    end
end

