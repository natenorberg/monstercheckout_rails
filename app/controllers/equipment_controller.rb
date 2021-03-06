class EquipmentController < ApplicationController
  before_action :set_equipment,  only: [:show, :edit, :update, :destroy, :history]
  before_filter :user_signed_in,  only: [:new, :edit, :create, :update, :destroy]
  before_filter :user_is_admin,  only: [:new, :edit, :create, :update, :destroy, :history]

  # GET /equipment
  # GET /equipment.json
  def index
    @equipment = Equipment.all
  end

  # GET /equipment/1
  # GET /equipment/1.json
  def show
  end

  # GET /equipment/new
  def new
    @equipment = Equipment.new
    @categories = Category.all.map { |c| [c.name, c.id] }
  end

  # GET /equipment/1/edit
  def edit
    @categories = Category.all.map { |c| [c.name, c.id] }
  end

  # POST /equipment
  # POST /equipment.json
  def create
    @equipment = Equipment.new(equipment_params)

    respond_to do |format|
      if @equipment.save
        format.html {
          if @equipment.is_kit?
            redirect_to new_equipment_sub_item_path(@equipment), notice: 'Please enter the items that make up this kit'
          else
            redirect_to @equipment, notice: 'Equipment was successfully created.'
          end
        }
        format.json { render :show, status: :created, location: @equipment }
      else
        format.html { render :new }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipment/1
  # PATCH/PUT /equipment/1.json
  def update
    respond_to do |format|
      if @equipment.update(equipment_params)
        format.html { redirect_to @equipment, notice: 'Equipment was successfully updated.' }
        format.json { render :show, status: :ok, location: @equipment }
      else
        format.html { render :edit }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment/1
  # DELETE /equipment/1.json
  def destroy
    @equipment.destroy
    respond_to do |format|
      format.html { redirect_to equipment_index_url, notice: 'Equipment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /equipment/1/history
  def history
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment
      @equipment = Equipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_params
      params.require(:equipment).permit(:name, :brand, :quantity, :condition, :description, :is_kit, :category_id, permission_ids: [])
    end
end
