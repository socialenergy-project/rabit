require 'clustering/clustering_module'


class ClusteringsController < ApplicationController
  load_and_authorize_resource
  include MapHelper

  before_action :set_clustering, only: [:show, :edit, :update, :destroy]

  # GET /clusterings
  # GET /clusterings.json
  def index
    @clusterings = Clustering.accessible_by(current_ability,:read).order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /clusterings/1
  # GET /clusterings/1.json
  def show
    @hash = build_map(@clustering.communities.map(&:consumers).flatten, @clustering)
  end

  # GET /clusterings/new
  def new
    @clustering = Clustering.new
  end

  # GET /clusterings/1/edit
  def edit
  end

  # POST /clusterings
  # POST /clusterings.json
  def create
    @clustering = Clustering.new(clustering_params)

    respond_to do |format|
      if @clustering.save
        format.html { redirect_to @clustering, notice: 'Clustering was successfully created.' }
        format.json { render :show, status: :created, location: @clustering }
      else
        format.html { render :new }
        format.json { render json: @clustering.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clusterings/1
  # PATCH/PUT /clusterings/1.json
  def update
    respond_to do |format|
      if @clustering.update(clustering_params)
        format.html { redirect_to @clustering, notice: 'Clustering was successfully updated.' }
        format.json { render :show, status: :ok, location: @clustering }
      else
        format.html { render :edit }
        format.json { render json: @clustering.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clusterings/1
  # DELETE /clusterings/1.json
  def destroy
    respond_to do |format|
      begin
        @clustering.destroy
        format.html { redirect_to clusterings_url, notice: 'Clustering was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to clusterings_url, alert: 'Clustering was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  helper_method :algorithms

  private

    def algorithms
      ClusteringModule.algorithms
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_clustering
      @clustering = Clustering.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clustering_params
      params.require(:clustering).permit(:name, :description)
    end
end
