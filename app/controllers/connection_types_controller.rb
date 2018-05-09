class ConnectionTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_connection_type, only: [:show, :edit, :update, :destroy]

  # GET /connection_types
  # GET /connection_types.json
  def index
    @connection_types = ConnectionType.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /connection_types/1
  # GET /connection_types/1.json
  def show
  end

  # GET /connection_types/new
  def new
    @connection_type = ConnectionType.new
  end

  # GET /connection_types/1/edit
  def edit
  end

  # POST /connection_types
  # POST /connection_types.json
  def create
    @connection_type = ConnectionType.new(connection_type_params)

    respond_to do |format|
      if @connection_type.save
        format.html { redirect_to @connection_type, notice: 'Connection type was successfully created.' }
        format.json { render :show, status: :created, location: @connection_type }
      else
        format.html { render :new }
        format.json { render json: @connection_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /connection_types/1
  # PATCH/PUT /connection_types/1.json
  def update
    respond_to do |format|
      if @connection_type.update(connection_type_params)
        format.html { redirect_to @connection_type, notice: 'Connection type was successfully updated.' }
        format.json { render :show, status: :ok, location: @connection_type }
      else
        format.html { render :edit }
        format.json { render json: @connection_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /connection_types/1
  # DELETE /connection_types/1.json
  def destroy
    respond_to do |format|
      begin
        @connection_type.destroy
        format.html { redirect_to connection_types_url, notice: 'Connection type was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to connection_types_url, alert: 'Connection type was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connection_type
      @connection_type = ConnectionType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def connection_type_params
      params.require(:connection_type).permit(:name)
    end
end
