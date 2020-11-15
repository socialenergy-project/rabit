class DrEventsController < ApplicationController
  load_and_authorize_resource
  before_action :set_dr_event, only: [:show, :schedule, :edit, :update, :destroy]

  # GET /dr_events
  # GET /dr_events.json
  def index
    @dr_events = DrEvent.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /dr_events/1
  # GET /dr_events/1.json
  def show
  end

  # GET /dr_events/new
  def new
    default_interval = Interval.find_by(duration: 1.hour.seconds)
    @dr_event = DrEvent.new(interval: default_interval,
                            starttime: default_interval.next_timestamp(DateTime.now)&.strftime("%F %H:%M"),
                            state: :created)
    3.times {|i| @dr_event.dr_targets.build ts_offset: i}
  end

  def schedule
    respond_to do |format|


      if false #@dr_event.save
        format.html { redirect_to @dr_event, notice: 'Dr event was successfully updated.' }
        format.json { render :show, status: :ok, location: @dr_event }
      else
        format.html { redirect_to @dr_event, alert: 'Dr event was NOT successfully updated.' }
        format.json { render json: @dr_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /dr_events/1/edit
  def edit
  end

  # POST /dr_events
  # POST /dr_events.json
  def create
    @dr_event = DrEvent.new(dr_event_params)

    respond_to do |format|
      if @dr_event.save
        format.html { redirect_to @dr_event, notice: 'Dr event was successfully created.' }
        format.json { render :show, status: :created, location: @dr_event }
      else
        format.html { render :new }
        format.json { render json: @dr_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dr_events/1
  # PATCH/PUT /dr_events/1.json
  def update
    respond_to do |format|
      if @dr_event.update(dr_event_params)
        format.html { redirect_to @dr_event, notice: 'Dr event was successfully updated.' }
        format.json { render :show, status: :ok, location: @dr_event }
      else
        format.html { render :edit }
        format.json { render json: @dr_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dr_events/1
  # DELETE /dr_events/1.json
  def destroy
    respond_to do |format|
      begin
        @dr_event.destroy
        format.html { redirect_to dr_events_url, notice: 'Dr event was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to dr_events_url, alert: 'Dr event was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dr_event
      @dr_event = DrEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dr_event_params
      params.require(:dr_event).permit(:name, :starttime, :interval_id, :price, :state, :dr_type, dr_targets_attributes: [ :id, :ts_offset, :volume,])
    end
end
