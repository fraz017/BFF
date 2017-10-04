class Admin::AvailableCategoriesController < Admin::AppController
  before_action :set_available_category, only: [:show, :edit, :update, :destroy]

  # GET /available_categories
  # GET /available_categories.json
  def index
    @available_categories = AvailableCategory.all
  end

  # GET /available_categories/1
  # GET /available_categories/1.json
  def show
  end

  # GET /available_categories/new
  def new
    @available_category = AvailableCategory.new
  end

  # GET /available_categories/1/edit
  def edit
  end

  # POST /available_categories
  # POST /available_categories.json
  def create
    @available_category = AvailableCategory.new(available_category_params)

    respond_to do |format|
      if @available_category.save
        format.html { redirect_to admin_available_categories_path, notice: 'Available category was successfully created.' }
        format.json { render :show, status: :created, location: @available_category }
      else
        format.html { render :new }
        format.json { render json: @available_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /available_categories/1
  # PATCH/PUT /available_categories/1.json
  def update
    respond_to do |format|
      if @available_category.update(available_category_params)
        format.html { redirect_to admin_available_categories_path, notice: 'Available category was successfully updated.' }
        format.json { render :show, status: :ok, location: @available_category }
      else
        format.html { render :edit }
        format.json { render json: @available_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /available_categories/1
  # DELETE /available_categories/1.json
  def destroy
    @available_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_available_categories_path, notice: 'Available category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_available_category
      @available_category = AvailableCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def available_category_params
      params.require(:available_category).permit(:name, :color, :icon)
    end
end
