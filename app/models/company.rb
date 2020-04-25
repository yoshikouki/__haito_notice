class Company < ApplicationRecord

  validates :local_code,    presence:     true,
                            numericality: { only_integer: true }
  validates :company_name, :market_division, :pub_date, presence: true
  
  
  require 'rails/all'
  require 'csv'
  require 'roo'
  require 'roo-xls'
  
  # 企業一覧Excel（東証）のヘッダーとテーブルカラム名の対応表
  HEADER_TO_SYM_MAP = {
    "日付" => :pub_date, 
    "コード" => :local_code, 
    "銘柄名" => :company_name, 
    "市場・商品区分" => :market_division, 
    "33業種コード" => :tsi_code, 
    "33業種区分" => :topix_sector_indices, 
    "17業種コード" => :t17_code, 
    "17業種区分" => :topix_17, 
    "規模コード" => :sc_code, 
    "規模区分" => :size_classification
  }

  def self.import_file(file)
    # ExcelファイルをRooを使用して開く
    data = open_spreadsheet(file)
    # Excelファイルのヘッダー行（日本語）を取得
    header_jp = data.row(1)
    unless header_jp == HEADER_TO_SYM_MAP.keys
      return false
    end
    header = Array.new
    # ヘッダー行を、対応するテーブルカラム名に変換
    header_jp.each{ |jp| header << HEADER_TO_SYM_MAP[jp]}
    (2..data.last_row).each do |i|
      # {カラム名 => 値, ...} のハッシュを作成する
      row = Hash[[header, data.row(i)].transpose]
      # local_codeが見つかればレコードを呼び出し、見つからなければ作成
      company = find_by(local_code: row[:local_code].to_int) || new
      # CSVからデータを取得し、設定する
      company.attributes = row.to_hash.slice(*updatable_attributes)
      # 保存する
      company.save
    end
  end

  # Gem Rooを使ってアップロードしたファイルを開く
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv'  then Roo::Csv.new(file.path)
    when '.xls'  then Roo::Excel.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    when '.ods'  then Roo::OpenOffice.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    HEADER_TO_SYM_MAP.keys
  end

  private_class_method :open_spreadsheet, :updatable_attributes

end
