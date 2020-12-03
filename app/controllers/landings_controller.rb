class LandingsController < ApplicationController
  before_action :set_landing, only: [:show, :edit, :update, :destroy]

  def new
    @landing = Landing.new
    @weathers = ["晴れ",
                 "晴れ時々曇り",
                 "晴れ時々雨",
                 "曇り",
                 "曇り時々晴れ",
                 "曇り時々雨",
                 "雨",
                 "大雨",
                 "雷雨",
                 "嵐",
                 "大嵐",
                 "雪",
                 "大雪"]
                       
    @fish_species = ["鯖",
                     "若子",
                     "鮭",
                     "するめ",
                     "セズ",
                     "鮑口開",
                     "子イカ",
                     "鯛",
                     "鰯",
                     "汐子",
                     "セグロ",
                     "鯵"]
                     
  @wind = ["風あり",
           "風なし"]
           
  @wave = ["波あり",
           "波なし"]
  end

  def create
    @landing = Landing.new(landing_params)
    if @landing.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to new_landing_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @landing.update_attributes(landing_params)
      flash[:success] = "水揚げ情報を更新しました。"
      redirect_to landings_url
    else
      render :edit
    end
  end

  def destroy
    @landing.destroy
    flash[:success] = "水揚げ情報を一件削除しました。"
    redirect_to landings_url
  end
  
  def show
  end
  
  def index
    @landings = Landing.all
  end
  
  private

    def landing_params
      params.require(:landing).permit(:landing_date,
                                      :landing_time,
                                      :weather,
                                      :water_temperature,
                                      :fish_species,
                                      :landing_amount,
                                      :wind,
                                      :wave,
                                      :remarks,
                                      :size_etc,
                                      :unit_price,
                                      :purchase,
                                      :shipping_destination
                                      )
    end
    
    def set_landing
      @landing = Landing.find(params[:id])
    end
end
