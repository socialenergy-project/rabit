class EnergyProgramsController < ApplicationController
  load_and_authorize_resource
  before_action :set_energy_program, only: [:show, :edit, :update, :destroy]

  # GET /energy_programs
  # GET /energy_programs.json
  def index
    @energy_programs = EnergyProgram.accessible_by(current_ability,:read).order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /energy_programs/1
  # GET /energy_programs/1.json
  def show
  end

  # GET /energy_programs/new
  def new
    @energy_program = EnergyProgram.new
  end

  # GET /energy_programs/1/edit
  def edit
  end

  # POST /energy_programs
  # POST /energy_programs.json
  def create
    @energy_program = EnergyProgram.new(energy_program_params)

    respond_to do |format|
      if @energy_program.save
        format.html {redirect_to @energy_program, notice: 'Energy program was successfully created.'}
        format.json {render :show, status: :created, location: @energy_program}
      else
        format.html {render :new}
        format.json {render json: @energy_program.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /energy_programs/1
  # PATCH/PUT /energy_programs/1.json
  def update
    respond_to do |format|
      if @energy_program.update(energy_program_params)
        format.html {redirect_to @energy_program, notice: 'Energy program was successfully updated.'}
        format.json {render :show, status: :ok, location: @energy_program}
      else
        format.html {render :edit}
        format.json {render json: @energy_program.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /energy_programs/1
  # DELETE /energy_programs/1.json
  def destroy
    respond_to do |format|
      begin
        @energy_program.destroy
        format.html {redirect_to energy_programs_url, notice: 'Energy program was successfully destroyed.'}
        format.json {head :no_content}
      rescue Exception => e
        format.html {redirect_to energy_programs_url, alert: 'Energy program was NOT successfully destroyed. Reason is ' + e.message}
        format.json {render json: e, status: :unprocessable_entity}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_energy_program
    @energy_program = EnergyProgram.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def energy_program_params
    params.require(:energy_program).permit(:name)
  end
end
