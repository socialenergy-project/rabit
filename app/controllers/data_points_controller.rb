require 'fetch_data/fetch_data'

class DataPointsController < ApplicationController
  load_and_authorize_resource
  before_action :set_data_point, only: [:show, :edit, :update, :destroy]

  # GET /data_points
  # GET /data_points.json
  def index
    respond_to do |format|
      format.html do
        @data_points = DataPoint.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
        render :index
      end
      format.json do
        FetchData::FetchData.new(Consumer.where(id: params[:consumer_id]), params).sync
        filter = {
            timestamp: params[:start_date]&.to_datetime ..
                params[:end_date]&.to_datetime,
            interval_id: params[:interval_id]&.to_i
        }
        filter[:consumer_id] = params[:consumer_id] if params[:consumer_id]
        puts "The filter is #{filter}"
        aggr = {}
        result = (DataPoint
                         .joins(:consumer)
                         .where(filter)
                          .order(timestamp: :asc)
                         .select('consumers.name as cname',
                                 :timestamp,
                                 :consumption
                         )
                         .inject( {} ) do |res, v|
          res[v.cname] ||= []
          res[v.cname] += [[v.timestamp.to_datetime.to_s, v.consumption]]
          if v.consumption.nil? or (aggr.key?(v.timestamp.to_datetime.to_s) and aggr[v.timestamp.to_datetime.to_s].nil?)
            aggr[v.timestamp.to_datetime.to_s] = nil
          elsif aggr[v.timestamp.to_datetime.to_s]
            aggr[v.timestamp.to_datetime.to_s] += v.consumption
          else
            aggr[v.timestamp.to_datetime.to_s] = v.consumption
          end
          res
        end)
        result[:aggregate] = aggr.sort

        render json: result
      end
    end
  end

  # GET /data_points/1
  # GET /data_points/1.json
  def show
  end

  # GET /data_points/new
  def new
    @data_point = DataPoint.new
  end

  # GET /data_points/1/edit
  def edit
  end

  # POST /data_points
  # POST /data_points.json
  def create
    @data_point = DataPoint.new(data_point_params)

    respond_to do |format|
      if @data_point.save
        format.html { redirect_to @data_point, notice: 'Data point was successfully created.' }
        format.json { render :show, status: :created, location: @data_point }
      else
        format.html { render :new }
        format.json { render json: @data_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_points/1
  # PATCH/PUT /data_points/1.json
  def update
    respond_to do |format|
      if @data_point.update(data_point_params)
        format.html { redirect_to @data_point, notice: 'Data point was successfully updated.' }
        format.json { render :show, status: :ok, location: @data_point }
      else
        format.html { render :edit }
        format.json { render json: @data_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_points/1
  # DELETE /data_points/1.json
  def destroy
    respond_to do |format|
      begin
        @data_point.destroy
        format.html { redirect_to data_points_url, notice: 'Data point was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to data_points_url, alert: 'Data point was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_point
      @data_point = DataPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_point_params
      params.require(:data_point).permit(:consumer_id, :interval_id, :timestamp, :consumption, :flexibility)
    end
end
