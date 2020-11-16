class DrPlanActionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_dr_plan_action, only: [:show, :edit, :update, :destroy]

  # GET /dr_plan_actions
  # GET /dr_plan_actions.json
  def index
    @dr_plan_actions = DrPlanAction.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /dr_plan_actions/1
  # GET /dr_plan_actions/1.json
  def show
  end

  # GET /dr_plan_actions/new
  def new
    @dr_plan_action = DrPlanAction.new
  end

  # GET /dr_plan_actions/1/edit
  def edit
  end

  # POST /dr_plan_actions
  # POST /dr_plan_actions.json
  def create
    @dr_plan_action = DrPlanAction.new(dr_plan_action_params)

    respond_to do |format|
      if @dr_plan_action.save
        format.html { redirect_to @dr_plan_action, notice: 'Dr plan action was successfully created.' }
        format.json { render :show, status: :created, location: @dr_plan_action }
      else
        format.html { render :new }
        format.json { render json: @dr_plan_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dr_plan_actions/1
  # PATCH/PUT /dr_plan_actions/1.json
  def update
    respond_to do |format|
      if @dr_plan_action.update(dr_plan_action_params)
        format.html { redirect_to @dr_plan_action, notice: 'Dr plan action was successfully updated.' }
        format.json { render :show, status: :ok, location: @dr_plan_action }
      else
        format.html { render :edit }
        format.json { render json: @dr_plan_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dr_plan_actions/1
  # DELETE /dr_plan_actions/1.json
  def destroy
    respond_to do |format|
      begin
        @dr_plan_action.destroy
        format.html { redirect_to dr_plan_actions_url, notice: 'Dr plan action was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to dr_plan_actions_url, alert: 'Dr plan action was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dr_plan_action
      @dr_plan_action = DrPlanAction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dr_plan_action_params
      params.require(:dr_plan_action).permit(:dr_target_id, :consumer_id, :volume_planned, :price_per_mw)
    end
end
