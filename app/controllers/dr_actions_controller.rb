class DrActionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_dr_action, only: %i[show edit update destroy]

  # GET /dr_actions
  # GET /dr_actions.json
  def index
    @dr_actions = DrAction.order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
  end

  # GET /dr_actions/1
  # GET /dr_actions/1.json
  def show; end

  # GET /dr_actions/new
  def new
    @dr_action = DrAction.new
  end

  # GET /dr_actions/1/edit
  def edit; end

  # POST /dr_actions
  # POST /dr_actions.json
  def create
    @dr_action = DrAction.new(dr_action_params)

    respond_to do |format|
      if @dr_action.save
        format.html { redirect_to @dr_action, notice: 'Dr action was successfully created.' }
        format.json { render :show, status: :created, location: @dr_action }
      else
        format.html { render :new }
        format.json { render json: @dr_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dr_actions/1
  # PATCH/PUT /dr_actions/1.json
  def update
    respond_to do |format|
      if @dr_action.update(dr_action_params)
        format.html { redirect_to @dr_action, notice: 'Dr action was successfully updated.' }
        format.json { render :show, status: :ok, location: @dr_action }
      else
        format.html { render :edit }
        format.json { render json: @dr_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dr_actions/1
  # DELETE /dr_actions/1.json
  def destroy
    respond_to do |format|
      @dr_action.destroy
      format.html { redirect_to dr_actions_url, notice: 'Dr action was successfully destroyed.' }
      format.json { head :no_content }
    rescue Exception => e
      format.html { redirect_to dr_actions_url, alert: 'Dr action was NOT successfully destroyed. Reason is ' + e.message }
      format.json { render json: e, status: :unprocessable_entity }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dr_action
    @dr_action = DrAction.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dr_action_params
    params.require(:dr_action).permit(:dr_target_id, :consumer_id, :volume_planned, :volume_actual, :price_per_mw)
  end
end
