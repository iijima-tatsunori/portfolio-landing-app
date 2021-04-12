class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper
  include GroundsHelper
  include LandingsHelper
  include AccountsHelper

  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforフィルター

  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_account
    @account = Account.find(params[:id])
  end
  
  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def uncorrect_user
    redirect_to(root_url) if current_user?(@user)
  end
  
  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  def accounting_user
    redirect_to root_url unless current_user.accounting?
  end
  
  def admin_and_accounting_user
    redirect_to root_url unless current_user.accounting? || current_user.admin?
  end
  
  # 管理者は許可しない
  def invalid_admin_user
    redirect_to root_url if current_user.admin?
  end
  
  # 管理者または、アクセスしたユーザーが現在ログインしているユーザーだった場合許可
  def admin_or_correct_user
    redirect_to(root_url) unless current_user.admin? || current_user?(@user)
  end
  
  def set_one_month
    @first_day = params[:accounting_date].nil? ? Date.current.beginning_of_month : params[:accounting_date].to_date
    @last_day = @first_day.end_of_month
    @one_month = [*@first_day..@last_day]
    @this_month = @first_day.all_month
    @today = Date.current
    @this_year = @first_day.all_year
  end
  
  # before_action
    # 初期現金残高
    def cash_initial_deposit
      @cash_initial_deposit = 2000
    end
    # 初期預金残高
    def current_initial_deposit
      @current_initial_deposit = 1000
    end
    
    # 売上帳勘定科目用(account_titleのselect_box選択用)--view(new, create, edit)
    def select_account_title
      @select_account_title = ["現金",
                               "預金",
                               "買掛金",
                               "売掛金",
                               "当座預金",
                               "給料",
                               "交際費",
                               "消耗品費",
                               "車両費",
                               "材料費",
                               "修繕費",
                               "水道光熱費",
                               "通信費",
                               "旅費交通費",
                               "荷造運賃",
                               "借入金",
                               "家賃",
                               "租税公課",
                               "支払利息",
                               "固定資産除却損",
                               "受取利息",
                               "雑収入",
                               "固定資産売却益",
                               "受取手形",
                               "支払手形",
                               "商品",
                               "建物",
                               "機械装置",
                               "車両運搬具",
                               "土地",
                               "未払消費税",
                               "未払法人税等",
                               "未払費用",
                               "長期借入金",
                               "社債",
                               "退職給付引当金",
                               "その他有価証券",
                               "関連会社株式"]
    end
    # -----------------------------------------
    
    # 仕入帳勘定科目用(account_titleのselect_box選択用)--view(purchasing_new, purchasing_create, purchasing_edit)
    def purchasing_select_account_title
      @purchasing_select_account_title = ["現金",
                                         "預金",
                                         "買掛金",
                                         "売掛金",
                                         "当座預金",
                                         "給料",
                                         "交際費",
                                         "消耗品費",
                                         "車両費",
                                         "材料費",
                                         "修繕費",
                                         "水道光熱費",
                                         "通信費",
                                         "旅費交通費",
                                         "荷造運賃",
                                         "借入金",
                                         "家賃",
                                         "租税公課",
                                         "支払利息",
                                         "固定資産除却損",
                                         "受取利息",
                                         "雑収入",
                                         "固定資産売却益",
                                         "受取手形",
                                         "支払手形",
                                         "商品",
                                         "建物",
                                         "機械装置",
                                         "車両運搬具",
                                         "土地",
                                         "未払消費税",
                                         "未払法人税等",
                                         "未払費用",
                                         "長期借入金",
                                         "社債",
                                         "退職給付引当金",
                                         "その他有価証券",
                                         "関連会社株式"]
    end
    # -----------------------------------------
    
    # 現金出納帳勘定科目用(account_titleのselect_box選択用)--view(cash_new, cash_create, cash_edit)
    def cash_select_account_title
      @cash_select_account_title = ["買掛金",
                                   "売掛金",
                                   "給料",
                                   "交際費",
                                   "消耗品費",
                                   "車両費",
                                   "材料費",
                                   "修繕費",
                                   "水道光熱費",
                                   "通信費",
                                   "旅費交通費",
                                   "荷造運賃",
                                   "借入金",
                                   "家賃",
                                   "租税公課",
                                   "支払利息",
                                   "固定資産除却損",
                                   "受取利息",
                                   "雑収入",
                                   "固定資産売却益",
                                   "受取手形",
                                   "支払手形",
                                   "商品",
                                   "建物",
                                   "機械装置",
                                   "車両運搬具",
                                   "土地",
                                   "未払消費税",
                                   "未払法人税等",
                                   "未払費用",
                                   "長期借入金",
                                   "社債",
                                   "退職給付引当金",
                                   "その他有価証券",
                                   "関連会社株式"]
    end
    # -----------------------------------------
    
    # 預金出納帳勘定科目用(account_titleのselect_box選択用)--view(current_new, current_create, current_edit)
    def current_select_account_title
      @current_select_account_title = ["買掛金",
                                       "売掛金",
                                       "給料",
                                       "交際費",
                                       "消耗品費",
                                       "車両費",
                                       "材料費",
                                       "修繕費",
                                       "水道光熱費",
                                       "通信費",
                                       "旅費交通費",
                                       "荷造運賃",
                                       "借入金",
                                       "家賃",
                                       "租税公課",
                                       "支払利息",
                                       "固定資産除却損",
                                       "受取利息",
                                       "雑収入",
                                       "固定資産売却益",
                                       "受取手形",
                                       "支払手形",
                                       "商品",
                                       "建物",
                                       "機械装置",
                                       "車両運搬具",
                                       "土地",
                                       "未払消費税",
                                       "未払法人税等",
                                       "未払費用",
                                       "長期借入金",
                                       "社債",
                                       "退職給付引当金",
                                       "その他有価証券",
                                       "関連会社株式"]
    end
    # -----------------------------------------
    
    # 振替伝票勘定科目用(のselect_box選択用)--view()
    def transfer_slip_account_title
      @transfer_slip_account_title = %w[現金
                                        普通預金
                                        普通預金2
                                        売掛金
                                        当座預金
                                        定期預金
                                        郵便貯金
                                        受取手形
                                        売掛金
                                        商品
                                        製品
                                        原材料
                                        仕掛品
                                        前渡金
                                        前払費用
                                        立替金
                                        仮払金
                                        未収入金
                                        短期貸付金
                                        建物
                                        機械装置
                                        車両運搬具
                                        工具器具備品
                                        一括償却資産
                                        減価償却累計額
                                        土地
                                        電話加入権
                                        ソフトウェア
                                        敷金
                                        差入保証金
                                        長期貸付金
                                        創立費
                                        開業費
                                        買掛金
                                        支払手形
                                        短期借入金
                                        未払金
                                        未払費用
                                        前受金
                                        預り金
                                        源泉税等預り金
                                        仮受金
                                        賞与引当金
                                        役員賞与引当金
                                        未払法人税等
                                        未払事業税等
                                        未払消費税等
                                        長期借入金
                                        資本金
                                        資本準備金
                                        利益準備金
                                        別途積立金
                                        繰越利益剰余金
                                        売上値引高
                                        外注加工費
                                        期首商品棚卸高
                                        期首製品棚卸高
                                        仕入高
                                        支払利息
                                        雑損失
                                        前期利益修正損
                                        固定資産売却損
                                        法人税･住民税及び事業税
                                        給料手当
                                        役員報酬
                                        役員賞与
                                        雑給
                                        賞与
                                        退職金
                                        法定福利費
                                        福利厚生費
                                        採用教育費
                                        通信費
                                        荷造運賃
                                        水道光熱費
                                        旅費交通費
                                        広告宣伝費
                                        販売手数料
                                        交際費
                                        少額交際費
                                        会議費
                                        消耗品費
                                        事務用品費
                                        備品消耗品
                                        新聞図書費
                                        修繕費
                                        地代家賃
                                        車両費
                                        保険料
                                        租税公課
                                        諸会費
                                        賃借料
                                        支払手数料
                                        減価償却費
                                        研究開発費
                                        寄附金
                                        雑費
                                        売上高
                                        仕入値引高
                                        期末商品棚卸高
                                        受取利息
                                        雑収入
                                        営業外利益
                                        前期利益修正益
                                        固定資産売却益
                                        特別利益
                                        ]
    end
    # -----------------------------------------
    
    # 資産勘定科目用(のselect_box選択用)--view()
    def assets_account_title
      @assets_account_title = %w[現金
                                普通預金
                                普通預金2
                                売掛金
                                当座預金
                                定期預金
                                郵便貯金
                                受取手形
                                売掛金
                                商品
                                製品
                                原材料
                                仕掛品
                                前渡金
                                前払費用
                                立替金
                                仮払金
                                未収入金
                                短期貸付金
                                建物
                                機械装置
                                車両運搬具
                                工具器具備品
                                一括償却資産
                                減価償却累計額
                                土地
                                電話加入権
                                ソフトウェア
                                敷金
                                差入保証金
                                長期貸付金
                                創立費
                                開業費
                                ]
    end
    # -----------------------------------------
    
    # 負債/純資産勘定科目用(のselect_box選択用)--view()
    def liabilities_account_title
      @liabilities_account_title = %w[買掛金
                                    支払手形
                                    短期借入金
                                    未払金
                                    未払費用
                                    前受金
                                    預り金
                                    源泉税等預り金
                                    仮受金
                                    賞与引当金
                                    役員賞与引当金
                                    未払法人税等
                                    未払事業税等
                                    未払消費税等
                                    長期借入金
                                    --純資産--
                                    資本金
                                    資本準備金
                                    利益準備金
                                    別途積立金
                                    繰越利益剰余金
                                    ]
    end
    # -----------------------------------------
    
    # 費用勘定科目用(のselect_box選択用)--view()
    def cost_account_title
      @cost_account_title = %w[売上値引高
                              外注加工費
                              期首商品棚卸高
                              期首製品棚卸高
                              仕入高
                              支払利息
                              雑損失
                              前期利益修正損
                              固定資産売却損
                              法人税･住民税及び事業税
                              給料手当
                              役員報酬
                              役員賞与
                              雑給
                              賞与
                              退職金
                              法定福利費
                              福利厚生費
                              採用教育費
                              通信費
                              荷造運賃
                              水道光熱費
                              旅費交通費
                              広告宣伝費
                              販売手数料
                              交際費
                              少額交際費
                              会議費
                              消耗品費
                              事務用品費
                              備品消耗品
                              新聞図書費
                              修繕費
                              地代家賃
                              車両費
                              保険料
                              租税公課
                              諸会費
                              賃借料
                              支払手数料
                              減価償却費
                              研究開発費
                              寄附金
                              雑費
                              ]
    end
    # -----------------------------------------
    
    # 収益勘定科目用(のselect_box選択用)--view()
    def revenue_account_title
      @revenue_account_title = %w[売上高
                                仕入値引高
                                期末商品棚卸高
                                受取利息
                                雑収入
                                営業外利益
                                前期利益修正益
                                固定資産売却益
                                特別利益
                                ]
    end
    # -----------------------------------------
    
    # 税率用(のselect_box選択用)--view()
    def tax_rate
      @tax_rate = %w[対象外
                     8%
                     10%
                    ]
    end
    # -----------------------------------------
    
    # 補助勘定科目用(のselect_box選択用)--view()
    def sub_account_title
      @sub_account_title = %w[所得税
                              住民税
                              ]
    end
    # -----------------------------------------
end
