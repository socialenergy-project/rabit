require 'clustering/user_clustering.rb'

class UserClusteringScenariosController < ApplicationController
  load_and_authorize_resource
  before_action :set_user_clustering_scenario, only: [:show, :edit, :update, :destroy]

  # GET /user_clustering_scenarios
  # GET /user_clustering_scenarios.json
  def index
    @user_clustering_scenarios = UserClusteringScenario.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /user_clustering_scenarios/1
  # GET /user_clustering_scenarios/1.json
  def show
    @user_params = @user_clustering_scenario.get_params
    if @user_params.keys.size > 0
      @param_keys = @user_params.first[1].keys
      @selected_params = params[:plots]&.count ? params[:plots] :
                         @param_keys.size <= 15 ? @param_keys : []

      @results = @selected_params&.combination(2)&.map do |key1, key2|
        {
          x_label: key1,
          y_label: key2,
          dataset: @user_clustering_scenario.get_results_for_plot(key1, key2)
        }
      end
    end

    valuesHash = UserClusteringScenario.joins(:user_clustering_results, :user_clustering_parameters)
                                       .where(id: @user_clustering_scenario.id)
                                       .group(:'user_clustering_results.cluster', :'user_clustering_parameters.paramtype')
                                       .sum(:'user_clustering_parameters.value')

    clusters = @user_clustering_scenario.user_clustering_results.distinct(:cluster).pluck(:cluster)
    paramtypes = @user_clustering_scenario.user_clustering_parameters.distinct(:paramtype).pluck(:paramtype)

    p "The valuHAsh is", valuesHash
    @recommendation_params = []
    paramtypes.each do |paramtype|
      res = valuesHash.select { |(c,p),v| p == paramtype }.map { |(c,p),v| [c,v] }
      best = res.max_by {|c,v| v}
      worst = res.min_by {|c,v| v}

      if (worst[1] == 0 && best[1] > 0) || (best[1] / worst[1] >= 2)
        @recommendation_params << {
          recommendable_id: @user_clustering_scenario.id,
          recommendable_type: @user_clustering_scenario.class,
          users: User.joins(:user_clustering_results)
                     .where('user_clustering_results.user_clustering_scenario': @user_clustering_scenario,
                            'user_clustering_results.cluster': best[0]),
          parameter: paramtype,
          recommendation_type_id: RecommendationType.find_by(name: "Congradulate")&.id,
        }

        @recommendation_params << {
          recommendable_id: @user_clustering_scenario.id,
          recommendable_type: @user_clustering_scenario.class,
          users: User.joins(:user_clustering_results)
                     .where('user_clustering_results.user_clustering_scenario': @user_clustering_scenario,
                            'user_clustering_results.cluster': worst[0]),
          parameter: paramtype,
          recommendation_type_id: RecommendationType.find_by(name: "Engagement")&.id,
        }
      end
    end
  end

  # GET /user_clustering_scenarios/new
  def new
    @user_clustering_scenario = UserClusteringScenario.new
  end

  # GET /user_clustering_scenarios/1/edit
  def edit
  end

  # POST /user_clustering_scenarios
  # POST /user_clustering_scenarios.json
  def create
    @user_clustering_scenario = UserClusteringScenario.new(user_clustering_scenario_params)

    respond_to do |format|
      if @user_clustering_scenario.save && update_parameter_values
        format.html { redirect_to @user_clustering_scenario, notice: 'User clustering scenario was successfully created.' }
        format.json { render :show, status: :created, location: @user_clustering_scenario }
      else
        format.html { render :new }
        format.json { render json: @user_clustering_scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_clustering_scenarios/1
  # PATCH/PUT /user_clustering_scenarios/1.json
  def update
    respond_to do |format|
      if @user_clustering_scenario.update(user_clustering_scenario_params) && update_parameter_values
        format.html { redirect_to @user_clustering_scenario, notice: 'User clustering scenario was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_clustering_scenario }
      else
        format.html { render :edit }
        format.json { render json: @user_clustering_scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_clustering_scenarios/1
  # DELETE /user_clustering_scenarios/1.json
  def destroy
    respond_to do |format|
      begin
        @user_clustering_scenario.destroy
        format.html { redirect_to user_clustering_scenarios_url, notice: 'User clustering scenario was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to user_clustering_scenarios_url, alert: 'User clustering scenario was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_clustering_scenario
      @user_clustering_scenario = UserClusteringScenario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_clustering_scenario_params
      params.require(:user_clustering_scenario).permit(:name, :kappa, :silhouette )
    end

    def update_parameter_values # (user_clustering_scenario_params)
      ActiveRecord::Base.transaction do
      
        uc = ClusteringModule::UserClustering.new(
          @user_clustering_scenario.kappa,
          params[:user_clustering_scenario]['parameters']&.reject(&:blank?)
        )

        user_ids = (GameActivity.distinct.pluck(:user_id) + LcmsScore.distinct.pluck(:user_id)).uniq

        UserClusteringParameter.where(user_clustering_scenario: @user_clustering_scenario).delete_all
        UserClusteringParameter.create params[:user_clustering_scenario]['parameters']&.reject(&:blank?)&.product(user_ids)&.map { |parameter, user_id|
            {
              user_id: user_id,
              user_clustering_scenario: @user_clustering_scenario,
              paramtype: parameter,
              value: ClusteringModule::UserClustering.parameterTypes[parameter.to_sym][:callback].call(user_id),
            }
        }

        UserClusteringResult.where(user_clustering_scenario: @user_clustering_scenario).delete_all
        params123 = @user_clustering_scenario&.get_params&.first

        if params123 && params123.size > 1 && @user_clustering_scenario.kappa
          UserClusteringResult.create uc.run(user_ids)&.map.with_index { |cluster, i|
            cluster.map do |user|
              {
                user: User.find(user),
                user_clustering_scenario: @user_clustering_scenario,
                cluster: i,
              }
            end
          }.flatten
        else
          true
        end

      end
    end
end
