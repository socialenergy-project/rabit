class BuildingTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_building_type, only: [:show, :edit, :update, :destroy]

  # GET /building_types
  # GET /building_types.json
  def index
    @building_types = BuildingType.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /building_types/1
  # GET /building_types/1.json
  def show
  end

  # GET /building_types/new
  def new
    @building_type = BuildingType.new
  end

  # GET /building_types/1/edit
  def edit
  end

  # POST /building_types
  # POST /building_types.json
  def create
    @building_type = BuildingType.new(building_type_params)

    respond_to do |format|
      if @building_type.save
        format.html { redirect_to @building_type, notice: 'Building type was successfully created.' }
        format.json { render :show, status: :created, location: @building_type }
      else
        format.html { render :new }
        format.json { render json: @building_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /building_types/1
  # PATCH/PUT /building_types/1.json
  def update
    respond_to do |format|
      if @building_type.update(building_type_params)
        format.html { redirect_to @building_type, notice: 'Building type was successfully updated.' }
        format.json { render :show, status: :ok, location: @building_type }
      else
        format.html { render :edit }
        format.json { render json: @building_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /building_types/1
  # DELETE /building_types/1.json
  def destroy
    respond_to do |format|
      begin
        @building_type.destroy
        format.html { redirect_to building_types_url, notice: 'Building type was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to building_types_url, alert: 'Building type was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building_type
      @building_type = BuildingType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def building_type_params
      params.require(:building_type).permit(:name)
    end
end
