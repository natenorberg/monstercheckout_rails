class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy, :approve, :deny, :checkout]
  before_filter :user_signed_in
  before_filter :current_user_or_admin, only: [:destroy]
  before_filter :user_is_admin, only: [:approve, :deny]
  before_filter :user_is_monitor, only: [:checkout]

  # GET /reservations
  # GET /reservations.json
  def index
    @user_reservations = Reservation.where(user: current_user)
    if current_user.is_admin?
      @awaiting_approval = Reservation.where(status: 'requested')
      @all_reservations = Reservation.all
      render :admin_index
    end
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
    format_time_input
    params[:reservation][:equipment_ids] ||= []
    @reservation = Reservation.new(reservation_params)
    @reservation.status = :requested
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
    format_time_input
    params[:reservation][:equipment_ids] ||= []
    respond_to do |format|
      if @reservation.update(reservation_params)
        update_quantities
        reset_approval_status
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

  # GET /reservations/1/approve
  # GET /reservations/1/approve.json
  def approve
    @reservation.is_approved = true
    @reservation.status = :approved
    @reservation.admin_response_time = Time.now
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, flash: { success: 'Reservation has been approved' } }
        format.json { render :show, status: :ok, location: @reservation }
      else  
        format.html { render :show }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /reservations/1/deny
  # GET /reservations/1/deny.json
  def deny
    @reservation.is_denied = true
    @reservation.status = :denied
    @reservation.admin_response_time = Time.now
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, flash: { error: 'Reservation has been denied' } }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :show }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /reservations/1/checkout
  # GET /reservations/1/checkout.json
  def checkout
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def format_time_input
      if params[:datetime_format]
        params[:reservation][:out_time] = DateTime.strptime(params[:reservation][:out_time], '%m/%d/%Y %I:%M %p')
        params[:reservation][:in_time] = DateTime.strptime(params[:reservation][:in_time], '%m/%d/%Y %I:%M %p')
      end
    end

    def update_quantities
      @reservation.equipment.each do |item|
        association = ReservationEquipment.where(reservation_id: @reservation.id, equipment_id: item.id).first
        association.quantity = params[:reservation][:quantity][item.id.to_s]
        association.save()
      end
    end

    def reset_approval_status
      @reservation.is_approved = false
      @reservation.is_denied = false
      @reservation.status = :requested
      @reservation.save
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
