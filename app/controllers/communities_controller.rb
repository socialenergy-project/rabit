class CommunitiesController < ApplicationController
  load_and_authorize_resource
  before_action :set_community, only: [:show, :edit, :update, :destroy]
  before_action :get_community_members, only: [:new, :edit]
  include MapHelper

  # GET /communities
  # GET /communities.json
  def index
    @communities = Community.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /communities/1
  # GET /communities/1.json
  def show
    @hash = build_map(@community.consumers.to_a, @community.clustering)
  end

  # GET /communities/new
  def new
    @community = Community.new
  end

  # GET /communities/1/edit
  def edit
  end

  # POST /communities
  # POST /communities.json
  def create
    @community = Community.new(community_params)

    respond_to do |format|
      if @community.save
        format.html { redirect_to @community, notice: 'Community was successfully created.' }
        format.json { render :show, status: :created, location: @community }
      else
        format.html { render :new }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communities/1
  # PATCH/PUT /communities/1.json
  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to @community, notice: 'Community was successfully updated.' }
        format.json { render :show, status: :ok, location: @community }
      else
        format.html { render :edit }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communities/1
  # DELETE /communities/1.json
  def destroy
    respond_to do |format|
      begin
        @community.destroy
        format.html { redirect_to communities_url, notice: 'Community was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to communities_url, alert: 'Community was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_params
      params.require(:community).permit(:name, :description, :clustering_id, consumer_ids: [])
    end

    def get_community_members
      @clustering_info = Clustering.all.map do |c|
        [c.id, c.communities.reject{|com| com == @community}.map(&:consumer_ids).flatten]
      end.to_h
    end
end
