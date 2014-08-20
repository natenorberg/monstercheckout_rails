class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  before_filter :user_signed_in
  # TODO: Filter destroy so that only the current user (or admin) can cancel a reservation

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    params[:reservation][:equipment_ids] ||= []
    @reservation = Reservation.new(reservation_params)
    respond_to do |format|
      if @reservation.save
        update_quantities
        format.html { redirect_to @reservation, flash: { success: 'Reservation was successfully created.' } }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    params[:reservation][:equipment_ids] ||= []
    respond_to do |format|
      if @reservation.update(reservation_params)
        update_quantities
        format.html { redirect_to @reservation, flash: { success: 'Reservation was successfully updated.' } }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def update_quantities
      @reservation.equipment.each do |item|
        association = ReservationEquipment.where(reservation_id: @reservation.id, equipment_id: item.id).first
        association.quantity = params[:reservation][:quantity][item.id.to_s]
        association.save()
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:project,
                                          :user_id,
                                          :in_time, :out_time,
                                          :checked_out_time, :checked_in_time,
                                          :is_approved,
                                          :check_out_comments, :check_in_comments,
                                          equipment_ids: [])
    end
end
