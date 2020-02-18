class StaticPagesController < ApplicationController

  def home
    # TDnetの最新情報を読み込み
    security_code = "recent"
    recent_td = { "params": { "company": security_code,
                              "format":   ".xml"
                  },
                  "query":  { "limit":    30, 
                              #"hasXBRL": 0,
                  }
                }
    tds_hash(recent_td)
  end
end
