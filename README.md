# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

[{"publishingOffice"=>"盛岡地方気象台", 
  "reportDatetime"=>"2021-05-03T17:00:00+09:00",
  "timeSeries"=>[
                 {"timeDefines"=>["2021-05-03T17:00:00+09:00", "2021-05-04T00:00:00+09:00", "2021-05-05T00:00:00+09:00"], 
                        "areas"=>[{"area"=>{"name"=>"内陸", "code"=>"030010"}, 
                                  "weatherCodes"=>["200", "101", "200"], 
                                  "weathers"=>["くもり", "晴れ　朝晩　くもり", "くもり"], 
                                  "winds"=>["西の風　やや強く", "西の風", "南の風"]
                                  }, 
                                  
                                  {"area"=>{"name"=>"沿岸北部", "code"=>"030020"}, 
                                  "weatherCodes"=>["200", "100", "200"], 
                                  "weathers"=>["くもり", "晴れ", "くもり"], 
                                  "winds"=>["西の風　やや強く", "西の風　日中　北東の風　海上　では　はじめ　西の風　やや強く", "南の風"], 
                                  "waves"=>["１．５メートル", "１．５メートル　後　１メートル", "１メートル　後　３メートル"]
                                  }, 
                                  
                                  {"area"=>{"name"=>"沿岸南部", "code"=>"030030"}, 
                                  "weatherCodes"=>["211", "100", "200"], 
                                  "weathers"=>["くもり　夜　晴れ", "晴れ", "くもり"], 
                                  "winds"=>["北西の風　やや強く", "北西の風", "南の風"], 
                                  "waves"=>["１．５メートル", "１．５メートル　後　１メートル", "１メートル　後　３メートル"]
                                  }
                                 ]
                   }, 
                    
                   {"timeDefines"=>["2021-05-03T18:00:00+09:00", "2021-05-04T00:00:00+09:00", "2021-05-04T06:00:00+09:00", "2021-05-04T12:00:00+09:00", "2021-05-04T18:00:00+09:00"], 
                          "areas"=>[{"area"=>{"name"=>"内陸", "code"=>"030010"}, "pops"=>["10", "0", "0", "0", "0"]}, 
                                    {"area"=>{"name"=>"沿岸北部", "code"=>"030020"}, "pops"=>["10", "0", "0", "0", "0"]}, 
                                    {"area"=>{"name"=>"沿岸南部", "code"=>"030030"}, "pops"=>["10", "0", "0", "0", "0"]}
                                   ]
                    }, 
                    {"timeDefines"=>["2021-05-04T00:00:00+09:00", "2021-05-04T09:00:00+09:00"], 
                            "areas"=>[{"area"=>{"name"=>"盛岡", "code"=>"33431"}, "temps"=>["6", "20"]}, 
                                      {"area"=>{"name"=>"宮古", "code"=>"33472"}, "temps"=>["6", "21"]}, 
                                      {"area"=>{"name"=>"大船渡", "code"=>"33877"}, "temps"=>["8", "22"]}, 
                                      {"area"=>{"name"=>"二戸", "code"=>"33071"}, "temps"=>["4", "20"]}, 
                                      {"area"=>{"name"=>"一関", "code"=>"33911"}, "temps"=>["6", "23"]}
                                    ]
                    }
                ]
  }, 
  
  {"publishingOffice"=>"盛岡地方気象台", 
  "reportDatetime"=>"2021-05-03T17:00:00+09:00", 
  "timeSeries"=>[
                 {"timeDefines"=>["2021-05-04T00:00:00+09:00", "2021-05-05T00:00:00+09:00", "2021-05-06T00:00:00+09:00", "2021-05-07T00:00:00+09:00", "2021-05-08T00:00:00+09:00", "2021-05-09T00:00:00+09:00", "2021-05-10T00:00:00+09:00"], 
                        "areas"=>[{"area"=>{"name"=>"内陸", "code"=>"030010"}, 
                                    "weatherCodes"=>["101", "200", "101", "201", "200", "200", "201"], 
                                    "pops"=>["", "40", "20", "30", "40", "40", "30"], 
                                    "reliabilities"=>["", "", "A", "B", "C", "B", "B"]
                                  }, 
                                  {"area"=>{"name"=>"沿岸", "code"=>"030100"}, 
                                    "weatherCodes"=>["100", "200", "101", "201", "200", "200", "201"], 
                                    "pops"=>["", "30", "20", "30", "40", "40", "30"], 
                                    "reliabilities"=>["", "", "A", "B", "C", "B", "A"]
                                  }
                                 ]
                  }, 
                  
                  {"timeDefines"=>["2021-05-04T00:00:00+09:00", "2021-05-05T00:00:00+09:00", "2021-05-06T00:00:00+09:00", "2021-05-07T00:00:00+09:00", "2021-05-08T00:00:00+09:00", "2021-05-09T00:00:00+09:00", "2021-05-10T00:00:00+09:00"], 
                        "areas"=>[{"area"=>{"name"=>"盛岡", "code"=>"33431"}, 
                                  "tempsMin"=>["", "9", "10", "6", "12", "10", "9"], 
                                  "tempsMinUpper"=>["", "10", "12", "9", "13", "13", "11"], 
                                  "tempsMinLower"=>["", "6", "8", "4", "8", "8", "5"], 
                                  "tempsMax"=>["", "22", "23", "23", "20", "19", "19"], 
                                  "tempsMaxUpper"=>["", "24", "25", "27", "24", "23", "23"], 
                                  "tempsMaxLower"=>["", "20", "21", "21", "17", "15", "15"]
                                  }, 
                        
                                  {"area"=>{"name"=>"宮古", "code"=>"33472"}, 
                                  "tempsMin"=>["", "8", "10", "8", "10", "9", "8"], 
                                  "tempsMinUpper"=>["", "10", "12", "10", "13", "12", "11"], 
                                  "tempsMinLower"=>["", "6", "8", "6", "7", "6", "5"], 
                                  "tempsMax"=>["", "22", "24", "22", "20", "20", "19"], 
                                  "tempsMaxUpper"=>["", "24", "26", "24", "24", "23", "23"], 
                                  "tempsMaxLower"=>["", "19", "22", "20", "17", "17", "15"]
                                  }
                                 ]
                  }
                 ],"tempAverage"=>{"areas"=>[{"area"=>{"name"=>"盛岡", "code"=>"33431"}, "min"=>"7.1", "max"=>"18.7"}, 
                                             {"area"=>{"name"=>"宮古", "code"=>"33472"}, "min"=>"7.3", "max"=>"17.7"}
                                            ]
                                  }, 
                   "precipAverage"=>{"areas"=>[{"area"=>{"name"=>"盛岡", "code"=>"33431"}, "min"=>"11.8", "max"=>"32.1"}, 
                                               {"area"=>{"name"=>"宮古", "code"=>"33472"}, "min"=>"5.0", "max"=>"20.9"}
                                              ]
                                    }
  }
]


{"timeDefines"=>["2021-05-07T09:00:00+09:00", "2021-05-07T00:00:00+09:00", "2021-05-08T00:00:00+09:00", "2021-05-08T09:00:00+09:00"], 
"areas"=>[{"area"=>{"name"=>"盛岡", "code"=>"33431"}, "temps"=>["22", "22", "10", "21"]}, 
{"area"=>{"name"=>"宮古", "code"=>"33472"}, "temps"=>["24", "24", "10", "24"]}, 
{"area"=>{"name"=>"大船渡", "code"=>"33877"}, "temps"=>["21", "21", "10", "23"]}, 
{"area"=>{"name"=>"二戸", "code"=>"33071"}, "temps"=>["25", "25", "12", "21"]}, 
{"area"=>{"name"=>"一関", "code"=>"33911"}, "temps"=>["23", "23", "9", "24"]}]}]}


}]}, {"timeDefines"=>["2021-05-07T12:00:00+09:00", 
                    "2021-05-07T18:00:00+09:00", 
                    "2021-05-08T00:00:00+09:00", 
                    "2021-05-08T06:00:00+09:00", 
                    "2021-05-08T12:00:00+09:00", 
                    "2021-05-08T18:00:00+09:00"]
                    
                    
借方
  <!--現金 cash_deposits-->
  <!--普通預金 cash_deposits-->
  <!--普通預金2 cash_deposits-->
  <!--当座預金 cash_deposits-->
  <!--定期預金 cash_deposits-->
  <!--郵便貯金 cash_deposits-->
  <!--受取手形 trade_receivables-->
  <!--売掛金 trade_receivables-->
  <!--商品 inventories-->
  <!--製品 inventories-->
  <!--原材料 inventories-->
  <!--仕掛品 inventories-->
  <!--前払金 other_current_assets-->
  <!--前払費用 other_current_assets-->
  <!--立替金 other_current_assets-->
  <!--仮払金 other_current_assets-->
  <!--仮払消費税 left_consumption_tax-->
  <!--未収入金 other_current_assets-->
  <!--短期貸付金 other_current_assets-->
  <!--有価証券 other_current_assets-->
  <!--建物 tangible_fixed_assets-->
  <!--機械装置 tangible_fixed_assets-->
  <!--車両運搬具 tangible_fixed_assets-->
  <!--工具器具備品 tangible_fixed_assets-->
  <!--一括償却資産 tangible_fixed_assets-->
  <!--減価償却累計額 tangible_fixed_assets-->
  <!--土地 tangible_fixed_assets-->
  <!--電話加入権 intangible_fixed_assets-->
  <!--ソフトウェア intangible_fixed_assets-->
  <!--敷金　他固定資産-->
  <!--差入保証金　他固定資産-->
  <!--長期貸付金　他固定資産-->
  <!--創立費 deferred_assets-->
  <!--開業費 deferred_assets-->
<!--営業外費用  売上割引-->
  
  <!--外注加工費 outsourcing_cost-->
  <!--期首商品棚卸高 beginning_of_term-->
  <!--仕入 purchase-->
  
  <!--雑損失 miscellaneous_losses-->
  <!--火災損失 fire_loss-->
  
  <!--前期利益修正損　特別損失-->
  
  <!--固定資産売却損 gain_on_sales_of_fixed_assets-->
  <!--法人税･住民税及び事業税 corporate_inhabitant_and_enterprise_taxes-->
  <!--給料手当 salary-->
  
<!--販売費及一般管理費-->
<!--  役員報酬-->
<!--  役員賞与-->
<!--  専従者給与-->
<!--  雑給-->
<!--  賞与手当-->
<!--  退職金-->
<!--  法定福利費-->
<!--  福利厚生費-->
<!--  採用教育費-->
<!--  通信費-->
<!--  荷造運賃-->
<!--  水道光熱費-->
<!--  旅費交通費-->
<!--  広告宣伝費-->
<!--  販売手数料-->
<!--  接待交際費-->
<!--  少額交際費-->
<!--  会議費-->
<!--  消耗品費-->
<!--  事務用品費-->
<!--  備品消耗品-->
<!--  新聞図書費-->
<!--  修繕費-->
<!--------------------->
  <!--地代家賃 rent_paid-->
  
  <!--建物付属設備　固定資産-->
  <!--車両費　販売費及一般管理費-->
  <!--支払保険料　他流動資産-->
  <!--租税公課　販売費及一般管理費-->
  <!--諸会費　販売費及一般管理費-->
  <!--賃借料　販売費及一般管理費-->
  <!--支払手数料　販売費及一般管理費-->
  
  <!--支払利息 interest_expense-->
  <!--社債利息 interest_on_bonds-->
  <!--有価証券評価損 loss_on_valuation_of_marketable_securities-->
  <!--貸倒金 allowance_for_doubtful_accounts-->
  <!--減価償却費 depreciation_and_amortization-->
  <!--研究開発費 営業外費用-->
  <!--寄附金 営業外費用-->
  <!--雑費　営業外費用-->
  
  
  
  
  貸方
    <!--買掛金 accounts_payable_trades-->
    <!--支払手形 accounts_payable_trades-->
    <!--短期借入金 other_current_liabilities-->
    <!--未払金 other_current_liabilities-->
    <!--未払費用 other_current_liabilities-->
    <!--前受金 other_current_liabilities-->
    <!--預り金 other_current_liabilities-->
    <!--源泉税等預り金 other_current_liabilities-->
    <!--仮受金 other_current_liabilities-->
    <!--仮受消費税 right_consumption_tax-->
    <!--賞与引当金 other_current_liabilities-->
    <!--役員賞与引当金 other_current_liabilities-->
    <!--未払法人税等 other_current_liabilities-->
    <!--未払事業税等 other_current_liabilities-->
    <!--未払消費税等 accrued_consumption_tax-->
    <!--長期借入金 fixed_liabilities-->
    <!--資本金 capital_stocks-->
    <!--資本剰余金 capital_stocks-->
    <!--資本準備金 capital_stocks-->
    <!--別途積立金　純資産-->
    <!--売上 amount_of_sales-->
    <!--仕入値引　PL営業外収益-->
    <!--期末商品棚卸高 end_of_term-->
    <!--受取利息 interest_income-->
    <!--有価証券利息 interest_on_marketable_securities-->
    <!--有価証券売却益 gain_on_sales_of_marketable_securities-->
    <!--受取配当金 dividend_income-->
    <!--雑収入　収益-->
    <!--前期利益修正益　特別利益-->
    <!--固定資産売却益　収益-->
    
    
     # 資産勘定科目用()--view()　借方
    # def assets_account_title
    #   @assets_account_title = %w[現金
    #                             普通預金
    #                             普通預金2
    #                             当座預金
    #                             定期預金
    #                             郵便貯金
    #                             受取手形
    #                             売掛金
    #                             商品
    #                             製品
    #                             原材料
    #                             仕掛品
    #                             前払金
    #                             前払費用
    #                             立替金
    #                             仮払金
    #                             仮払消費税
    #                             未収入金
    #                             短期貸付金
    #                             建物
    #                             機械装置
    #                             車両運搬具
    #                             工具器具備品
    #                             一括償却資産
    #                             減価償却累計額
    #                             土地
    #                             電話加入権
    #                             ソフトウェア
    #                             敷金
    #                             差入保証金
    #                             長期貸付金
    #                             創立費
    #                             開業費
    #                             ]
    # end
    # -----------------------------------------
    
    # 負債/純資産勘定科目用()--view()　貸方
    # def liabilities_account_title
    #   @liabilities_account_title = %w[買掛金
    #                                 支払手形
    #                                 短期借入金
    #                                 未払金
    #                                 未払費用
    #                                 前受金
    #                                 預り金
    #                                 源泉税等預り金
    #                                 仮受金
    #                                 仮受消費税
    #                                 賞与引当金
    #                                 役員賞与引当金
    #                                 未払法人税等
    #                                 未払事業税等
    #                                 未払消費税等
    #                                 長期借入金
    #                                 --純資産--
    #                                 資本金
    #                                 資本準備金
    #                                 利益準備金
    #                                 別途積立金
    #                                 繰越利益剰余金
    #                                 ]
    # end
    # -----------------------------------------
    
    # 費用勘定科目用()--view()　借方
    # def cost_account_title
    #   @cost_account_title = %w[売上値引高
    #                           外注加工費
    #                           期首商品棚卸高
    #                           期首製品棚卸高
    #                           仕入高
    #                           雑損失
    #                           前期利益修正損
    #                           固定資産売却損
    #                           法人税･住民税及び事業税
    #                           給料手当
    #                           役員報酬
    #                           役員賞与
    #                           専従者給与
    #                           雑給
    #                           賞与
    #                           退職金
    #                           法定福利費
    #                           福利厚生費
    #                           採用教育費
    #                           通信費
    #                           荷造運賃
    #                           水道光熱費
    #                           旅費交通費
    #                           広告宣伝費
    #                           販売手数料
    #                           交際費
    #                           少額交際費
    #                           会議費
    #                           消耗品費
    #                           事務用品費
    #                           備品消耗品
    #                           新聞図書費
    #                           修繕費
    #                           地代家賃
    #                           車両費
    #                           保険料
    #                           租税公課
    #                           諸会費
    #                           賃借料
    #                           支払手数料
    #                           減価償却費
    #                           研究開発費
    #                           寄附金
    #                           雑費
    #                           ]
    # end
    # -----------------------------------------
    
    # 収益勘定科目用()--view()　貸方
    # def revenue_account_title
    #   @revenue_account_title = %w[売上高
    #                             仕入値引高
    #                             期末商品棚卸高
    #                             受取利息
    #                             雑収入
    #                             営業外利益
    #                             前期利益修正益
    #                             固定資産売却益
    #                             特別利益
    #                             ]
    # end