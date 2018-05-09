class EccTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_ecc_type, only: [:show, :edit, :update, :destroy]

  # GET /ecc_types
  # GET /ecc_types.json
  def index
    @ecc_types = EccType.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /ecc_types/1
  # GET /ecc_types/1.json
  def show
  end

  # GET /ecc_types/new
  def new
    @ecc_type = EccType.new
  end

  # GET /ecc_types/1/edit
  def edit
  end

  # POST /ecc_types
  # POST /ecc_types.json
  def create
    @ecc_type = EccType.new(ecc_type_params)

    respond_to do |format|
      if @ecc_type.save
        format.html {redirect_to @ecc_type, notice: 'Ecc type was successfully created.'}
        format.json {render :show, status: :created, location: @ecc_type}
      else
        format.html {render :new}
        format.json {render json: @ecc_type.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /ecc_types/1
  # PATCH/PUT /ecc_types/1.json
  def update
    respond_to do |format|
      if @ecc_type.update(ecc_type_params)
        format.html {redirect_to @ecc_type, notice: 'Ecc type was successfully updated.'}
        format.json {render :show, status: :ok, location: @ecc_type}
      else
        format.html {render :edit}
        format.json {render json: @ecc_type.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /ecc_types/1
  # DELETE /ecc_types/1.json
  def destroy
    respond_to do |format|
      begin
        @ecc_type.destroy
        format.html {redirect_to ecc_types_url, notice: 'Ecc type was successfully destroyed.'}
        format.json {head :no_content}
      rescue Exception => e
        format.html {redirect_to ecc_types_url, alert: 'Ecc type was NOT successfully destroyed. Reason is ' + e.message}
        format.json {render json: e, status: :unprocessable_entity}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ecc_type
    @ecc_type = EccType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ecc_type_params
    params.require(:ecc_type).permit(:name)
  end
end
