class ScenariosController < ApplicationController
  load_and_authorize_resource
  before_action :set_scenario, only: [:stderr, :show, :edit, :update, :destroy]

  # GET /scenarios
  # GET /scenarios.json
  def index
    @scenarios = Scenario.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  def stderr
    send_data(@scenario.stderr,
              filename: "Scenario_#{@scenario.id}_stderr.txt",
              type: "text/plain")
  end

  # GET /scenarios/1
  # GET /scenarios/1.json
  def show
    if @scenario.stderr
      respond_to do |format|
        format.html { flash.now[:alert] = (("#{@scenario.error_message} " || "") + view_context.link_to('Donload error log', stderr_scenario_path(@scenario), download: true)).html_safe }
        format.json do
          @error = {
              message: @scenario.error_message,
              link: URI.join(root_url(:only_path => false), stderr_scenario_path(@scenario))
          }
        end
      end
    end

    @plot_data = [:energy_cost, :user_welfare, :retailer_profit, :total_welfare, :total_bill, :total_consumption].map do |column|
      [column, @scenario.energy_programs.map do |ep|
        [ep.name, @scenario.results.where(energy_program_id: ep.id).order(timestamp: :asc).pluck(:timestamp, column)]
      end.to_h]
    end.to_h
    # @plot_data = {energy_cost: @scenario.results.order(timestamp: :asc).pluck(:timestamp, :energy_cost)}

  end

  # GET /scenarios/new
  def new
    init = view_context.chart_cookies
    @scenario = Scenario.new(params[:scenario] ? scenario_params : {starttime: init[:start_date],
        endtime: init[:end_date],
        interval_id: init[:interval_id]})
  end

  # GET /scenarios/1/edit
  def edit
  end

  # POST /scenarios
  # POST /scenarios.json
  def create
    @scenario = Scenario.new(scenario_params.merge(user: current_user))

    respond_to do |format|
      if @scenario.save
        format.html { redirect_to @scenario, notice: 'Scenario was successfully created.' }
        format.json { show; render :show, status: :created, location: @scenario }
      else
        format.html { render :new}
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scenarios/1
  # PATCH/PUT /scenarios/1.json
  def update
    respond_to do |format|
      if @scenario.update(scenario_params)
        format.html { redirect_to @scenario, notice: 'Scenario was successfully updated.' }
        format.json { show; render :show, status: :ok, location: @scenario }
      else
        format.html { render :edit }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.json
  def destroy
    respond_to do |format|
      begin
        @scenario.destroy
        format.html {redirect_to scenarios_url, notice: 'Scenario was successfully destroyed.'}
        format.json {head :no_content}
      rescue Exception => e
        format.html {redirect_to scenarios_url, alert: 'Scenario was NOT successfully destroyed. Reason is ' + e.message}
        format.json {render json: e, status: :unprocessable_entity}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_scenario
    @scenario = Scenario.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def scenario_params
    permitted = [:name, :description, :starttime, :endtime, :interval_id, :ecc_type_id, :energy_cost_parameter, :profit_margin_parameter, :flexibility_id, :number_of_clusters, :gamma_parameter, {energy_program_ids: []}, {consumer_ids: []}]
    permitted.push(:user_id) if current_user.has_role? :admin
    params.require(:scenario).permit(*permitted)
  end

  def sort_column
    field_exists?(params[:sort]) ? params[:sort] : field_exists?("updated_at") ? "updated_at" : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
