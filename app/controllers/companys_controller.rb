class CompanysController < ApplicationController

  def show
    # 証券コードを取得し、その証券コードでTDnetから情報を取得
    security_code = params["id"]
    td_list = { "params": { "company": security_code,
                            "format": ".xml"
                          },
                "query":  { "limit": 30, 
                            #"hasXBRL": 0,
                          }
              }
    tds_hash(td_list)
  end

  def search
    # 銘柄コード検索で呼び出し
    security_code = params["ticker_symbol"]
    td_list = { "params": { "company": security_code,
                            "format": ".xml"
                          },
                "query":  { "limit": 30, 
                      #"hasXBRL": 0,
                    }
                }
    tds_hash(td_list)
    render template: 'companys/show'
  end
end
