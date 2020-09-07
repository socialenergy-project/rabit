require 'fetch_data/flexgrid_client'

class ConsumersController < ApplicationController
  load_and_authorize_resource
  before_action :set_consumer, only: [:show, :edit, :update, :destroy]
  helper_method :category_name

  include MapHelper

  # GET /consumers
  # GET /consumers.json
  def index
    @consumers = Consumer.accessible_by(current_ability,:read).category(params[:category]).order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  def import
    raise "Wrong category" unless params[:category].to_i == 4
    Consumer.import FetchData::FlexgridClient.prosumers, params[:category]
    redirect_to consumers_path(category: params[:category])
  end

  # GET /consumers/1
  # GET /consumers/1.json
  def show
    @hash = build_map([@consumer], Clustering.find(@consumer.consumer_category.id))
                                            # This is a hack, we happen to have the same IDs
  end

  # GET /consumers/new
  def new
    @consumer = Consumer.new(consumer_category_id: params[:category])
  end

  # GET /consumers/1/edit
  def edit
  end

  # POST /consumers
  # POST /consumers.json
  def create
    @consumer = Consumer.new(consumer_params)

    respond_to do |format|
      if @consumer.save
        format.html { redirect_to @consumer, notice: 'Consumer was successfully created.' }
        format.json { render :show, status: :created, location: @consumer }
      else
        format.html { render :new }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consumers/1
  # PATCH/PUT /consumers/1.json
  def update
    respond_to do |format|
      if @consumer.update(consumer_params)
        format.html { redirect_to @consumer, notice: 'Consumer was successfully updated.' }
        format.json { render :show, status: :ok, location: @consumer }
      else
        format.html { render :edit }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consumers/1
  # DELETE /consumers/1.json
  def destroy
    respond_to do |format|
      begin
        @consumer.destroy
        format.html { redirect_to consumers_url, notice: 'Consumer was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to consumers_url, alert: 'Consumer was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consumer
      @consumer = Consumer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consumer_params
      params.require(:consumer).permit(:name, :location, :edms_id, :energy_program_id, :building_type_id, :connection_type_id, :location_x, :location_y, :feeder_id, :consumer_category_id, user_ids: [])
    end

    def category_name(category)
      [ConsumerCategory.find_by(id: category)&.name, 'Consumers'].compact.join(" ")
    end
end
