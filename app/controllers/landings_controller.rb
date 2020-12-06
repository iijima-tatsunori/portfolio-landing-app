class LandingsController < ApplicationController
  before_action :set_landing, only: [:show, :edit, :update, :destroy]
  before_action :set_ground, only: [:new, :create]
  
  def new
    @landing = Landing.new
  end

  def create
    @landing = Landing.new(landing_params)
    @landing.ground_id = params[:ground_id]
    if @landing.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to new_ground_landing_url
    else
      render :new if @landing.invalid?
    end
  end

  def edit
  end

  def update
    edit_landing_params.each do |id, item|
      landing = Landing.find(id)
      if landing.update_attributes(item)
        flash[:success] = "水揚げ情報を更新しました。"
        redirect_to landings_url
      else
        render :edit
      end
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
                                      :shipping_destination,
                                      :ground_id
                                      )
    end

    def edit_landing_params
      params.require(:ground).permit(landing: [:landing_date,
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
                                               :shipping_destination])[:landings]
    end
    
    def set_landing
      @landing = Landing.find(params[:id])
    end
    
    def set_ground
      @ground = Ground.find(params[:ground_id])
    end
    
end
