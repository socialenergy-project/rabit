class RecommendationTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_recommendation_type, only: [:show, :edit, :update, :destroy]

  # GET /recommendation_types
  # GET /recommendation_types.json
  def index
    @recommendation_types = RecommendationType.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /recommendation_types/1
  # GET /recommendation_types/1.json
  def show
  end

  # GET /recommendation_types/new
  def new
    @recommendation_type = RecommendationType.new
  end

  # GET /recommendation_types/1/edit
  def edit
  end

  # POST /recommendation_types
  # POST /recommendation_types.json
  def create
    @recommendation_type = RecommendationType.new(recommendation_type_params)

    respond_to do |format|
      if @recommendation_type.save
        format.html { redirect_to @recommendation_type, notice: 'Recommendation type was successfully created.' }
        format.json { render :show, status: :created, location: @recommendation_type }
      else
        format.html { render :new }
        format.json { render json: @recommendation_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recommendation_types/1
  # PATCH/PUT /recommendation_types/1.json
  def update
    respond_to do |format|
      if @recommendation_type.update(recommendation_type_params)
        format.html { redirect_to @recommendation_type, notice: 'Recommendation type was successfully updated.' }
        format.json { render :show, status: :ok, location: @recommendation_type }
      else
        format.html { render :edit }
        format.json { render json: @recommendation_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recommendation_types/1
  # DELETE /recommendation_types/1.json
  def destroy
    respond_to do |format|
      begin
        @recommendation_type.destroy
        format.html { redirect_to recommendation_types_url, notice: 'Recommendation type was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to recommendation_types_url, alert: 'Recommendation type was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recommendation_type
      @recommendation_type = RecommendationType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recommendation_type_params
      params.require(:recommendation_type).permit(:name, :description)
    end
end
