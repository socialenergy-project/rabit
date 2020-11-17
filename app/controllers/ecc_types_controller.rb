class EccTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_ecc_type, only: %i[show edit update destroy]

  # GET /ecc_types
  # GET /ecc_types.json
  def index
    @ecc_types = EccType.accessible_by(current_ability,:read).order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
  end

  # GET /ecc_types/1
  # GET /ecc_types/1.json
  def show; end

  # GET /ecc_types/new
  def new
    @ecc_type = if params[:consumer].blank?
                  EccType.new
                else
                  consumer = Consumer.find(params[:consumer].to_i)
                  EccType.new(consumer_id: consumer.id,
                              name: "SLA for #{consumer.name}",
                              max_activation_time_per_activation: "01:00:00",
                              max_activation_time_per_day: "01:00:00",
                              minimum_activation_time: "01:00:00")
                end
  end

  # GET /ecc_types/1/edit
  def edit; end

  # POST /ecc_types
  # POST /ecc_types.json
  def create
    @ecc_type = EccType.new(ecc_type_params)

    respond_to do |format|
      if @ecc_type.save
        format.html { redirect_to @ecc_type, notice: 'Ecc type was successfully created.' }
        format.json { render :show, status: :created, location: @ecc_type }
      else
        format.html { render :new }
        format.json { render json: @ecc_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ecc_types/1
  # PATCH/PUT /ecc_types/1.json
  def update
    respond_to do |format|
      if @ecc_type.update(ecc_type_params)
        format.html { redirect_to @ecc_type, notice: 'Ecc type was successfully updated.' }
        format.json { render :show, status: :ok, location: @ecc_type }
      else
        format.html { render :edit }
        format.json { render json: @ecc_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ecc_types/1
  # DELETE /ecc_types/1.json
  def destroy
    respond_to do |format|
      consumer = @ecc_type.consumer
      begin
        @ecc_type.destroy
        format.html { redirect_to (consumer ? consumer_path(consumer) : ecc_types_url), notice: 'Ecc type was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to ecc_types_url, alert: 'Ecc type was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
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
    params.require(:ecc_type).permit(:consumer_id, :name, :ramp_up_rate, :ramp_down_rate, :max_activation_time_per_activation, :max_activation_time_per_day, :energy_up_per_day, :energy_down_per_day, :minimum_activation_time, :max_activations_per_day, ecc_terms_attributes: [:id, :value, :price_per_mw, :_destroy, { ecc_factors_attributes: %i[id _destroy period start stop] }])
  end
end
