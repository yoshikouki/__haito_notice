class StaticPagesController < ApplicationController

  def home
    
    td_list = { "company": "recent",
                "query":  { "limit": 30, 
                            #"hasXBRL": 0,
                }
              }
    tds_hash(td_list)
  end
end
