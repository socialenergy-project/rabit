class SmartPlugsController < ApplicationController
  load_and_authorize_resource
  before_action :set_smart_plug, only: [:show, :edit, :update, :destroy]

  # GET /smart_plugs
  # GET /smart_plugs.json
  def index
    @smart_plugs = SmartPlug.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /smart_plugs/1
  # GET /smart_plugs/1.json
  def show
  end

  # GET /smart_plugs/new
  def new
    @smart_plug = SmartPlug.new
  end

  # GET /smart_plugs/1/edit
  def edit
  end

  # POST /smart_plugs
  # POST /smart_plugs.json
  def create
    @smart_plug = SmartPlug.new(smart_plug_params)

    respond_to do |format|
      if @smart_plug.save
        format.html { redirect_to @smart_plug, notice: 'Smart plug was successfully created.' }
        format.json { render :show, status: :created, location: @smart_plug }
      else
        format.html { render :new }
        format.json { render json: @smart_plug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /smart_plugs/1
  # PATCH/PUT /smart_plugs/1.json
  def update
    respond_to do |format|
      if @smart_plug.update(smart_plug_params)
        format.html { redirect_to @smart_plug, notice: 'Smart plug was successfully updated.' }
        format.json { render :show, status: :ok, location: @smart_plug }
      else
        format.html { render :edit }
        format.json { render json: @smart_plug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /smart_plugs/1
  # DELETE /smart_plugs/1.json
  def destroy
    respond_to do |format|
      begin
        @smart_plug.destroy
        format.html { redirect_to smart_plugs_url, notice: 'Smart plug was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to smart_plugs_url, alert: 'Smart plug was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_smart_plug
      @smart_plug = SmartPlug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def smart_plug_params
      params.require(:smart_plug).permit(:consumer_id, :name, :mqtt_name)
    end
end
