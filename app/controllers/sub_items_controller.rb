class SubItemsController < ApplicationController
  before_action :set_kit
  before_action :set_sub_item, only: [:show, :edit, :update, :destroy]

  # GET /sub_items
  # GET /sub_items.json
  def index
    @sub_items = SubItem.all
  end

  # GET /sub_items/1
  # GET /sub_items/1.json
  def show
    redirect_to @kit
  end

  # GET /sub_items/new
  def new
    @sub_item = @kit.sub_items.build
  end

  # GET /sub_items/1/edit
  def edit
  end

  # POST /sub_items
  # POST /sub_items.json
  def create
    @sub_item = SubItem.new(sub_item_params)
    @sub_item.kit = @kit
    respond_to do |format|
      if @sub_item.save
        format.html { redirect_to @kit, notice: 'Sub item was successfully created.' }
        format.json { render :show, status: :created, location: @sub_item }
      else
        format.html { render :new }
        format.json { render json: @sub_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_items/1
  # PATCH/PUT /sub_items/1.json
  def update
    respond_to do |format|
      if @sub_item.update(sub_item_params)
        format.html { redirect_to @kit, notice: 'Sub item was successfully updated.' }
        format.json { render :show, status: :ok, location: @sub_item }
      else
        format.html { render :edit }
        format.json { render json: @sub_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_items/1
  # DELETE /sub_items/1.json
  def destroy
    @sub_item.destroy
    respond_to do |format|
      format.html { redirect_to @kit, notice: 'Sub item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kit
      @kit = Equipment.find(params[:equipment_id])
    end

    def set_sub_item
      @sub_item = SubItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_item_params
      params.require(:sub_item).permit(:name, :brand, :kit, :description, :is_optional)
    end
end
