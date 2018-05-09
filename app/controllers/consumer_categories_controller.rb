class ConsumerCategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_consumer_category, only: [:show, :edit, :update, :destroy]

  # GET /consumer_categories
  # GET /consumer_categories.json
  def index
    @consumer_categories = ConsumerCategory.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
  end

  # GET /consumer_categories/1
  # GET /consumer_categories/1.json
  def show
  end

  # GET /consumer_categories/new
  def new
    @consumer_category = ConsumerCategory.new
  end

  # GET /consumer_categories/1/edit
  def edit
  end

  # POST /consumer_categories
  # POST /consumer_categories.json
  def create
    @consumer_category = ConsumerCategory.new(consumer_category_params)

    respond_to do |format|
      if @consumer_category.save
        format.html { redirect_to @consumer_category, notice: 'Consumer category was successfully created.' }
        format.json { render :show, status: :created, location: @consumer_category }
      else
        format.html { render :new }
        format.json { render json: @consumer_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consumer_categories/1
  # PATCH/PUT /consumer_categories/1.json
  def update
    respond_to do |format|
      if @consumer_category.update(consumer_category_params)
        format.html { redirect_to @consumer_category, notice: 'Consumer category was successfully updated.' }
        format.json { render :show, status: :ok, location: @consumer_category }
      else
        format.html { render :edit }
        format.json { render json: @consumer_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consumer_categories/1
  # DELETE /consumer_categories/1.json
  def destroy
    respond_to do |format|
      begin
        @consumer_category.destroy
        format.html { redirect_to consumer_categories_url, notice: 'Consumer category was successfully destroyed.' }
        format.json { head :no_content }
      rescue Exception => e
        format.html { redirect_to consumer_categories_url, alert: 'Consumer category was NOT successfully destroyed. Reason is ' + e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consumer_category
      @consumer_category = ConsumerCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consumer_category_params
      params.require(:consumer_category).permit(:name, :description, :real_time)
    end
end
