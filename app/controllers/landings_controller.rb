class LandingsController < ApplicationController
  
  before_action :set_landing, only: [:show, :edit, :update, :destroy]
  before_action :set_ground, only: [:new, :create, :show, :edit, :update]
  before_action :logged_in_user, only: [:new, :create, :show, :index, :edit, :update, :destroy]
  
  def pre_new
    @grounds = Ground.all
  end
  
  def new
    @landing = Landing.new
  end

  def create
    @landing = Landing.new(landing_params)
    @landing.ground_id = params[:ground_id]
    @landing.landing_fishing_ground_name = Ground.find(params[:ground_id]).fishing_ground_name
    if @landing.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to landing_index_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @landing.update_attributes(landing_params)
      flash[:success] = "水揚げ情報を更新しました。"
      redirect_to landing_index_url
    else
      render :edit
    end
  end

  def destroy
    @landing.destroy
    flash[:success] = "#{@landing.landing_fishing_ground_name}の#{l(@landing.landing_date, format: :short)}の水揚げ情報を一件削除しました。"
    redirect_to landing_index_url
  end
  
  def show
  end
  
  def index
    @search_params = landing_search_params
    @landings = Landing.search(@search_params).includes(:ground)
    @grounds = Ground.all
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
    
    
    def landing_search_params
      params.fetch(:search, {}).permit(:landing_date, :landing_fishing_ground_name)
    end

    def set_landing
      @landing = Landing.find(params[:id])
    end
    
    def set_ground
      @ground = Ground.find(params[:ground_id])
    end
    
end
