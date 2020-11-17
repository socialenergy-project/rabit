class IntervalsController < ApplicationController
  load_and_authorize_resource
  before_action :set_interval, only: [:show, :edit, :update, :destroy]

  # GET /intervals
  # GET /intervals.json
  def index
    @intervals = Interval.accessible_by(current_ability,:read).order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /intervals/1
  # GET /intervals/1.json
  def show
  end

  # GET /intervals/new
  def new
    @interval = Interval.new
  end

  # GET /intervals/1/edit
  def edit
  end

  # POST /intervals
  # POST /intervals.json
  def create
    @interval = Interval.new(interval_params)

    respond_to do |format|
      if @interval.save
        format.html { redirect_to @interval, notice: 'Interval was successfully created.' }
        format.json { render :show, status: :created, location: @interval }
      else
        format.html { render :new }
        format.json { render json: @interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /intervals/1
  # PATCH/PUT /intervals/1.json
  def update
    respond_to do |format|
      if @interval.update(interval_params)
        format.html { redirect_to @interval, notice: 'Interval was successfully updated.' }
        format.json { render :show, status: :ok, location: @interval }
      else
        format.html { render :edit }
        format.json { render json: @interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /intervals/1
  # DELETE /intervals/1.json
  def destroy
    respond_to do |format|
      begin
        @interval.destroy
        format.html { redirect_to intervals_url, notice: 'Interval was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to intervals_url, alert: 'Interval was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interval
      @interval = Interval.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interval_params
      params.require(:interval).permit(:name, :duration)
    end
end
