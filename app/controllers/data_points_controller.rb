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

        duration = params[:duration]&.to_i&.seconds
        puts "duration:", duration
        timerange = params[:type] == "Real-time" ?
                        DateTime.now - duration..DateTime.now + duration / 5.0 :
                        params[:start_date]&.to_datetime..params[:end_date]&.to_datetime

        filter = {
            timestamp: timerange,
            interval_id: params[:interval_id]&.to_i
        }

        timestamps_per_line = Interval.find(params[:interval_id]&.to_i)
                                  .timestamps(timerange.first, timerange.last)

        timestamps_total = params[:consumer] || params[:ecc_type] ?
                               timestamps_per_line.count :
                               timestamps_per_line.count < 700 ?
                                   Community.find(params[:community])&.consumers&.count * timestamps_per_line.count :
                                   timestamps_per_line.count

        if timestamps_per_line.count > 50 * 365
          render json: {errors: "To many datapoints for single request"}, status: :bad_request
        else
          render json: if params[:consumer]
                         consumer = Consumer.find(params[:consumer])
                         helpers.chart_cookies(consumer) unless params[:nocookies]
                         FetchData::FetchData.new([consumer], params).sync
                         consumer.data_points.joins(:consumer).where(filter)
                             .group('consumers.name')
                             .select('consumers.name as con',
                                     'array_agg(timestamp ORDER BY data_points.timestamp asc) as tims',
                                     'array_agg(consumption ORDER BY data_points.timestamp ASC) as cons')
                             .map {|d| [d.con, d.tims.zip(d.cons)]}.to_h
                       elsif params[:ecc_type]
                         ecc_type = EccType.find(params[:ecc_type]&.to_i)
                         helpers.chart_cookies(ecc_type) unless params[:nocookies]
                         valid_timestamps = ecc_type.get_valid_timestamps(timestamps_per_line)
                         {
                             '': timestamps_per_line.map {|t| [t, valid_timestamps.include?(t) ? 0.9 : nil ]}
                         }
                       else
                         community = Community.find(params[:community])
                         helpers.chart_cookies(community) unless params[:nocookies]
                         FetchData::FetchData.new(community.consumers, params).sync

                         if timestamps_total < 6000
                           aggr = []
                           res = DataPoint.joins(consumer: :communities)
                                     .where(filter.merge 'communities.id': community.id)
                                     .group('communities.id')
                                     .group('consumers.name')
                                     .select('consumers.name as con',
                                             'count(data_points.id) as num',
                                             'array_agg(timestamp ORDER BY data_points.timestamp asc) as tims',
                                             'array_agg(consumption ORDER BY data_points.timestamp ASC) as cons')
                                     .map { |d|
                            #  aggr = d.tims.map {|t| [t, 0]} if aggr.size == 0
                            #  aggr = aggr.zip(d.cons).map {|(a, b), d| [a, ((b.nil? or d.nil?) ? nil : b + d)]}
                             [d.con, d.tims.zip(d.cons)]
                           }.to_h
                           res["aggregate"] = get_aggregate(filter, community, res.size)
                           res
                         else
                           {
                               "aggregate" => DataPoint.joins(consumer: :communities)
                                                  .where(filter.merge 'communities.id': community.id)
                                                  .group('communities.id')
                                                  .group('timestamp')
                                                  .order(timestamp: :asc)
                                                  .select('communities.id as com, timestamp, case when sum(case when consumption is null then 1 else 0 end) > 0 then null else sum(consumption) end as cons')
                                                  .map {|d| [d.timestamp, d.cons]}
                           }
                         end
                       end
        end
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
        format.html {redirect_to @data_point, notice: 'Data point was successfully created.'}
        format.json {render :show, status: :created, location: @data_point}
      else
        format.html {render :new}
        format.json {render json: @data_point.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /data_points/1
  # PATCH/PUT /data_points/1.json
  def update
    respond_to do |format|
      if @data_point.update(data_point_params)
        format.html {redirect_to @data_point, notice: 'Data point was successfully updated.'}
        format.json {render :show, status: :ok, location: @data_point}
      else
        format.html {render :edit}
        format.json {render json: @data_point.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /data_points/1
  # DELETE /data_points/1.json
  def destroy
    respond_to do |format|
      begin
        @data_point.destroy
        format.html {redirect_to data_points_url, notice: 'Data point was successfully destroyed.'}
        format.json {head :no_content}
      rescue Exception => e
        format.html {redirect_to data_points_url, alert: 'Data point was NOT successfully destroyed. Reason is ' + e.message}
        format.json {render json: e, status: :unprocessable_entity}
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

  def get_aggregate(filter, community, res_size)
    DataPoint.joins(consumer: :communities)
    .where(filter.merge 'communities.id': community.id)
    .group('communities.id')
    .group('timestamp')
    .order(timestamp: :asc)
    .select('COUNT(data_points.id) as num, communities.id as com, timestamp, case when sum(case when consumption is null then 1 else 0 end) > 0 then null else sum(consumption) end as cons')
    .having('COUNT(data_points.id) = ?', res_size)
    .map {|d|[d.timestamp, d.cons]}
  end
end
