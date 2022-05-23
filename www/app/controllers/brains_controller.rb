class BrainsController < ApplicationController
  before_action :set_brain, only: [:show, :edit, :update, :destroy]

  # GET /brains
  # GET /brains.json
  def index
    @brains = Brain.all
  end

  # GET /brains/1
  # GET /brains/1.json
  def show
  end

  # GET /brains/new
  def new
    @brain = Brain.new
  end

  # GET /brains/1/edit
  def edit
  end

  # POST /brains
  # POST /brains.json
  def create
    @brain = Brain.new(brain_params)

    respond_to do |format|
      if @brain.save
        format.html { redirect_to @brain, notice: 'Brain was successfully created.' }
        format.json { render :show, status: :created, location: @brain }
      else
        format.html { render :new }
        format.json { render json: @brain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brains/1
  # PATCH/PUT /brains/1.json
  def update
    respond_to do |format|
      if @brain.update(brain_params)
        format.html { redirect_to @brain, notice: 'Brain was successfully updated.' }
        format.json { render :show, status: :ok, location: @brain }
      else
        format.html { render :edit }
        format.json { render json: @brain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brains/1
  # DELETE /brains/1.json
  def destroy
    @brain.destroy
    respond_to do |format|
      format.html { redirect_to brains_url, notice: 'Brain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brain
      @brain = Brain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brain_params
      params.require(:brain).permit(:user_id, :name, :brain_type, :brain_gender, :brain_aiml, :aiml_id, :speed, :aiml_file)
    end
end
