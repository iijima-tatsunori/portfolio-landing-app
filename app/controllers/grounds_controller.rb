class GroundsController < ApplicationController
  before_action :set_ground, only: [:show, :edit, :update, :destroy]

  def index
    @grounds = Ground.paginate(page: params[:page])
  end

  def show
  end

  def new
    @ground = Ground.new
  end

  def create
    @ground = Ground.new(ground_params)
    if @ground.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to grounds_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @ground.update_attributes(ground_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to grounds_url
    else
      render :edit      
    end
  end

  def destroy
    @ground.destroy
    flash[:success] = "#{@ground.fishing_ground_name}のデータを削除しました。"
    redirect_to grounds_url
  end

  private

    def ground_params
      params.require(:ground).permit(:fishing_ground_name)
    end

    # beforeフィルター

    # paramsハッシュからユーザーを取得します。
    def set_ground
      @ground = Ground.find(params[:id])
    end
end
