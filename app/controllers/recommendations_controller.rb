require 'fetch_data/recommendation_client'

class RecommendationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_recommendation, only: [:show, :edit, :update, :destroy, :send_messages, :delete_messages]

  # GET /recommendations
  # GET /recommendations.json
  def index
    @recommendations = Recommendation.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /recommendations/1
  # GET /recommendations/1.json
  def show
  end

  # GET /recommendations/new
  def new
    @recommendation = Recommendation.new(params[:recommendation] ? recommendation_params : {})
  end

  # GET /recommendations/1/edit
  def edit
    if @recommendation.messages.count > 0
      respond_to do |format|
        format.html { redirect_to @recommendation, alert: 'Messages have already been sent, delete existing ones first' }
        format.json { render json: {errors: 'Messages have already been sent, delete existing ones first' }, status: :unprocessable_entity }
      end
    end
  end

  # POST /recommendations
  # POST /recommendations.json
  def create
    @recommendation = Recommendation.new(recommendation_params)

    respond_to do |format|
      if @recommendation.save
        format.html { redirect_to @recommendation, notice: 'Recommendation was successfully created.' }
        format.json { render :show, status: :created, location: @recommendation }
      else
        format.html { render :new }
        format.json { render json: @recommendation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recommendations/1
  # PATCH/PUT /recommendations/1.json
  def update
    respond_to do |format|
      if @recommendation.update(recommendation_params)
        format.html { redirect_to @recommendation, notice: 'Recommendation was successfully updated.' }
        format.json { render :show, status: :ok, location: @recommendation }
      else
        format.html { render :edit }
        format.json { render json: @recommendation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recommendations/1
  # DELETE /recommendations/1.json
  def destroy
    respond_to do |format|
      begin
        @recommendation.destroy
        format.html { redirect_to params[:redirect] || recommendations_url, notice: 'Recommendation was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to recommendations_url, alert: 'Recommendation was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  def send_messages
    if @recommendation.messages.count == 0
      Message.create(@recommendation.draft_messages.map do |m|
        {
            recipient: m[:recipient],
            recommendation: @recommendation,
            content: m[:message],
            status: :sent
        }
      end)
      @recommendation.status = :sent
      @recommendation.save

      rcl = FetchData::RecommendationClient.new
      rcl.post_recommendation(@recommendation)

      respond_to do |format|
        format.html { redirect_to @recommendation, notice: 'Messages were sent.' }
        format.json { render :show, status: :ok, location: @recommendation }
      end
    else
      respond_to do |format|
        format.html { redirect_to @recommendation, alert: 'Messages have already been sent, delete existing ones first' }
        format.json { render json: {error: 'Messages have already been sent, delete existing ones first'}, status: :unprocessable_entity }
      end
    end
  end

  def delete_messages
    if @recommendation.messages.count > 0
      @recommendation.messages.destroy_all
      @recommendation.status = :created
      @recommendation.save
      respond_to do |format|
        format.html { redirect_to @recommendation, notice: 'Messages were deleted.' }
        format.json { render :show, status: :ok, location: @recommendation }
      end
    else
      respond_to do |format|
        format.html { redirect_to @recommendation, alert: 'No messages to delete' }
        format.json { render json: {error: 'No messages to delete'}, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recommendation
      @recommendation = Recommendation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recommendation_params
      if params[:recommendation][:recommendable_type].blank? and ! params[:recommendation][:recommendable_id].blank?
        params[:recommendation][:recommendable_type], params[:recommendation][:recommendable_id] = params[:recommendation][:recommendable_id].split(/_/)
      end
      params.require(:recommendation).permit(:status, :recommendation_type_id, :recommendable_id, :recommendable_type, :parameter, :custom_message, consumer_ids: [])
    end
end
