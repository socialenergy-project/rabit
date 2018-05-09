require 'clustering/clustering_module'

class ClScenariosController < ApplicationController
  load_and_authorize_resource
  before_action :set_cl_scenario, only: [:show, :edit, :update, :destroy]
  include MapHelper


  # GET /cl_scenarios
  # GET /cl_scenarios.json
  def index
    @cl_scenarios = ClScenario.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  def stderr
    send_data(@cl_scenario.stderr,
              filename: "ClScenario_#{@cl_scenario.id}_stderr.txt",
              type: "text/plain")
  end

  # GET /cl_scenarios/1
  # GET /cl_scenarios/1.json
  def show
    @hash = build_map(@cl_scenario.clustering&.communities&.map(&:consumers)&.flatten, @cl_scenario&.clustering)

    if @cl_scenario.stderr
      respond_to do |format|
        format.html { flash.now[:alert] = (("#{@cl_scenario.error_message} " || "") + view_context.link_to('Donload error log', stderr_cl_scenario_path(@cl_scenario), download: true)).html_safe }
        format.json do
          @error = {
              message: @cl_scenario.error_message,
              link: URI.join(root_url(:only_path => false), stderr_scenario_path(@cl_scenario))
          }
        end
      end
    end
  end

  # GET /cl_scenarios/new
  def new
    init = view_context.chart_cookies
    @cl_scenario = ClScenario.new(params[:cl_scenario] ? cl_scenario_params : {starttime: init[:start_date],
                                  endtime: init[:end_date],
                                  interval_id: init[:interval_id]})
    logger.debug  "Cookies are #{view_context.chart_cookies}"
    # @cl_scenario = view_context.chart_cookies
  end

  # GET /cl_scenarios/1/edit
  def edit
  end

  # POST /cl_scenarios
  # POST /cl_scenarios.json
  def create
    @cl_scenario = ClScenario.new(cl_scenario_params.merge(user: current_user))

    respond_to do |format|
      if @cl_scenario.save
        format.html { redirect_to @cl_scenario, notice: 'Cl scenario was successfully created.' }
        format.json { render :show, status: :created, location: @cl_scenario }
      else
        format.html { render :new }
        format.json { render json: @cl_scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cl_scenarios/1
  # PATCH/PUT /cl_scenarios/1.json
  def update
    respond_to do |format|
      if @cl_scenario.update(cl_scenario_params)
        format.html { redirect_to @cl_scenario, notice: 'Cl scenario was successfully updated.' }
        format.json { render :show, status: :ok, location: @cl_scenario }
      else
        format.html { render :edit }
        format.json { render json: @cl_scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cl_scenarios/1
  # DELETE /cl_scenarios/1.json
  def destroy
    respond_to do |format|
      begin
        @cl_scenario.destroy
        format.html { redirect_to cl_scenarios_url, notice: 'Cl scenario was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to cl_scenarios_url, alert: 'Cl scenario was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  helper_method :algorithms

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cl_scenario
      @cl_scenario = ClScenario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cl_scenario_params
      permitted = [:name, :algorithm, :kappa, :starttime, :endtime, :interval_id, :clustering_id, {consumer_ids: []}, :cost_parameter, {energy_program_ids: []}, :flexibility_id]
      permitted.push(:user_id) if current_user.has_role? :admin
      params.require(:cl_scenario).permit(*permitted)
    end

    def algorithms
      ClusteringModule.algorithms
    end

    def sort_column
      field_exists?(params[:sort]) ? params[:sort] : field_exists?("updated_at") ? "updated_at" : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
