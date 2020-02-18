class CompanysController < ApplicationController
  def show
    # 証券コードを取得し、その証券コードでTDnetから情報を取得
    security_code = params["id"]
    td_list = { "company": security_code,
                "query":  { "limit": 30, 
                            #"hasXBRL": 0,
                }
              }
    tds_hash(td_list)
  end
end
