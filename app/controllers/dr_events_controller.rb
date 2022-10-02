# frozen_string_literal: true

class DrEventsController < ApplicationController
  load_and_authorize_resource
  before_action :set_dr_event, only: %i[show schedule edit update destroy]

  # GET /dr_events
  # GET /dr_events.json
  def index
    @dr_events = DrEvent.accessible_by(current_ability,
                                       :read).order("#{sort_column} #{sort_direction}").paginate(page: params[:page])
  end

  # GET /dr_events/1
  # GET /dr_events/1.json
  def show; end

  # GET /dr_events/new
  def new
    default_interval = Interval.find_by(duration: 1.hour.seconds)
    @dr_event = DrEvent.new(interval: default_interval,
                            starttime: default_interval.next_timestamp(DateTime.now - DateTime.now.utc_offset.seconds)&.strftime("%F %H:%M"),
                            state: :created)
    3.times { |i| @dr_event.dr_targets.build ts_offset: i }
  end

  def schedule
    respond_to do |format|
      if @dr_event.schedule! # @dr_event.save
        format.html { redirect_to @dr_event, notice: "Dr event was successfully scheduled." }
        format.json { render :show, status: :ok, location: @dr_event }
      else
        format.html { redirect_to @dr_event, alert: "Dr event was NOT successfully scheduled." }
        format.json { render json: @dr_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate
    respond_to do |format|
      if @dr_event.activate! # @dr_event.save
        format.html { redirect_to @dr_event, notice: "Dr event was successfully scheduled." }
        format.json { render :show, status: :ok, location: @dr_event }
      else
        format.html { redirect_to @dr_event, alert: "Dr event was NOT successfully scheduled." }
        format.json { render json: @dr_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel
    respond_to do |format|
      if @dr_event.cancel! # @dr_event.save
        format.html { redirect_to @dr_event, notice: "Dr event was successfully canceled." }
        format.json { render :show, status: :ok, location: @dr_event }
      else
        format.html { redirect_to @dr_event, alert: "Dr event was NOT successfully canceled." }
        format.json { render json: @dr_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /dr_events/1/edit
  def edit; end

  # POST /dr_events
  # POST /dr_events.json
  def create
    @dr_event = DrEvent.new(dr_event_params.merge(state: :ready, user_id: current_user&.id))

    respond_to do |format|
      if @dr_event.create_and_possibly_activate
        format.html { redirect_to @dr_event, notice: "Dr event was successfully created." }
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
        format.html { redirect_to @dr_event, notice: "Dr event was successfully updated." }
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
      @dr_event.destroy
      format.html { redirect_to dr_events_url, notice: "Dr event was successfully destroyed." }
      format.json { head :no_content }
    rescue StandardError => e
      format.html do
        redirect_to dr_events_url, alert: "Dr event was NOT successfully destroyed. Reason is #{e.message}"
      end
      format.json { render json: e, status: :unprocessable_entity }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dr_event
    @dr_event = DrEvent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dr_event_params
    params.require(:dr_event).permit(:name, :starttime, :interval_id, :consumer_category_id, :price, :state, :dr_type,
                                     dr_targets_attributes: %i[id ts_offset volume])
  end

  def sort_column
    :starttime
  end

  def sort_direction
    :desc
  end
end
