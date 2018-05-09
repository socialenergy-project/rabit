class FlexibilitiesController < ApplicationController
  load_and_authorize_resource
  before_action :set_flexibility, only: [:show, :edit, :update, :destroy]

  # GET /flexibilities
  # GET /flexibilities.json
  def index
    @flexibilities = Flexibility.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /flexibilities/1
  # GET /flexibilities/1.json
  def show
  end

  # GET /flexibilities/new
  def new
    @flexibility = Flexibility.new
  end

  # GET /flexibilities/1/edit
  def edit
  end

  # POST /flexibilities
  # POST /flexibilities.json
  def create
    @flexibility = Flexibility.new(flexibility_params)

    respond_to do |format|
      if @flexibility.save
        format.html { redirect_to @flexibility, notice: 'Flexibility was successfully created.' }
        format.json { render :show, status: :created, location: @flexibility }
      else
        format.html { render :new }
        format.json { render json: @flexibility.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flexibilities/1
  # PATCH/PUT /flexibilities/1.json
  def update
    respond_to do |format|
      if @flexibility.update(flexibility_params)
        format.html { redirect_to @flexibility, notice: 'Flexibility was successfully updated.' }
        format.json { render :show, status: :ok, location: @flexibility }
      else
        format.html { render :edit }
        format.json { render json: @flexibility.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flexibilities/1
  # DELETE /flexibilities/1.json
  def destroy
    respond_to do |format|
      begin
        @flexibility.destroy
        format.html { redirect_to flexibilities_url, notice: 'Flexibility was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to flexibilities_url, alert: 'Flexibility was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flexibility
      @flexibility = Flexibility.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flexibility_params
      params.require(:flexibility).permit(:name)
    end
end
