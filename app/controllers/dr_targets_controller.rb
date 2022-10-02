class DrTargetsController < ApplicationController
  load_and_authorize_resource
  before_action :set_dr_target, only: [:show, :edit, :update, :destroy]

  # GET /dr_targets
  # GET /dr_targets.json
  def index
    @dr_targets = DrTarget.accessible_by(current_ability,:read).order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /dr_targets/1
  # GET /dr_targets/1.json
  def show
  end

  # GET /dr_targets/new
  def new
    @dr_target = DrTarget.new
  end

  # GET /dr_targets/1/edit
  def edit
  end

  # POST /dr_targets
  # POST /dr_targets.json
  def create
    @dr_target = DrTarget.new(dr_target_params)

    respond_to do |format|
      if @dr_target.save
        format.html { redirect_to @dr_target, notice: 'Dr target was successfully created.' }
        format.json { render :show, status: :created, location: @dr_target }
      else
        format.html { render :new }
        format.json { render json: @dr_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dr_targets/1
  # PATCH/PUT /dr_targets/1.json
  def update
    respond_to do |format|
      if @dr_target.update(dr_target_params)
        format.html { redirect_to @dr_target, notice: 'Dr target was successfully updated.' }
        format.json { render :show, status: :ok, location: @dr_target }
      else
        format.html { render :edit }
        format.json { render json: @dr_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dr_targets/1
  # DELETE /dr_targets/1.json
  def destroy
    respond_to do |format|
      begin
        @dr_target.destroy
        format.html { redirect_to dr_targets_url, notice: 'Dr target was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to dr_targets_url, alert: 'Dr target was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dr_target
      @dr_target = DrTarget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dr_target_params
      params.require(:dr_target).permit(:dr_event_id, :ts_offset, :volume, :cleared_price)
    end
end
