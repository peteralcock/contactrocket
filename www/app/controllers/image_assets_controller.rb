class ImageAssetsController < ApplicationController
  before_action :set_image_asset, only: [:show, :edit, :update, :destroy]

  # GET /image_assets
  # GET /image_assets.json
  def index
    @image_assets = ImageAsset.all
  end

  # GET /image_assets/1
  # GET /image_assets/1.json
  def show
  end

  # GET /image_assets/new
  def new
    @image_asset = ImageAsset.new
  end

  # GET /image_assets/1/edit
  def edit
  end

  # POST /image_assets
  # POST /image_assets.json
  def create
    @image_asset = ImageAsset.new(image_asset_params)

    respond_to do |format|
      if @image_asset.save
        format.html { redirect_to @image_asset, notice: 'Image asset was successfully created.' }
        format.json { render :show, status: :created, location: @image_asset }
      else
        format.html { render :new }
        format.json { render json: @image_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /image_assets/1
  # PATCH/PUT /image_assets/1.json
  def update
    respond_to do |format|
      if @image_asset.update(image_asset_params)
        format.html { redirect_to @image_asset, notice: 'Image asset was successfully updated.' }
        format.json { render :show, status: :ok, location: @image_asset }
      else
        format.html { render :edit }
        format.json { render json: @image_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /image_assets/1
  # DELETE /image_assets/1.json
  def destroy
    @image_asset.destroy
    respond_to do |format|
      format.html { redirect_to image_assets_url, notice: 'Image asset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_asset
      @image_asset = ImageAsset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_asset_params
      params.require(:image_asset).permit(:image_url, :source_url, :keywords, :sentiment, :description, :domain, :website_id)
    end
end
