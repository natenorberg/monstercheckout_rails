class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy, :approve, :deny, :checkout, :checkout_update, :checkin, :checkin_update]
  before_action :set_equipment, only: [:new, :create, :edit]
  before_filter :user_signed_in
  before_filter :current_user_or_admin, only: [:destroy]
  before_filter :user_is_admin, only: [:approve, :deny]
  before_filter :user_is_monitor, only: [:checkout, :checkout_update, :checkin, :checkin_update]
  before_filter :reservation_can_be_checked_out, only: [:checkout, :checkout_update]
  before_filter :reservation_can_be_checked_in, only: [:checkin, :checkin_update]

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
    @conflicts = conflicts
    @reservation = Reservation.new(reservation_params)
    @reservation.status = :requested
    respond_to do |format|
      if @conflicts.any?
        @reservation.errors.add(:base, 'There are conflicts')
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      elsif @reservation.save
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

  def checkout_update
    params[:reservation][:checked_out_time] = Time.now
    params[:reservation][:checked_out_by_id] = current_user.id

    respond_to do |format|
      if @reservation.update(reservation_params)
        @reservation.status = :out
        @reservation.save
        format.html { redirect_to @reservation, flash: { success: 'Reservation is checked out' } }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :checkout }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def checkin_update
    params[:reservation][:checked_in_time] = Time.now
    params[:reservation][:checked_in_by_id] = current_user.id

    respond_to do |format|
      if @reservation.update(reservation_params)
        if @reservation.checked_in_time > @reservation.in_time
          @reservation.returned_late!
        else
          @reservation.returned!
        end
        
        format.html { redirect_to @reservation, flash: { success: 'Reservation is checked in' } }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :checkin }
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

  # GET /reservations/1/checkin
  # GET /reservations/1/checkin.json
  def checkin
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def set_equipment
      @equipment = current_user.allowed_equipment
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

    def reservation_can_be_checked_out
      redirect_to root_path unless @reservation.approved?
    end

    def reservation_can_be_checked_in
      redirect_to root_path unless @reservation.can_checkin?
    end

    def conflicts
      # Get the other reservations to check agains
      # TODO: Be more selective here
      if params[:id]
        other_reservations = Reservation.where.not(id: params[:id])
      else
        other_reservations = Reservation.all
      end

      overlapping_reservations = []
      other_reservations.each do |reservation|
        if overlap(reservation, params[:reservation][:out_time], params[:reservation][:in_time])
          overlapping_reservations << reservation        
        end
      end

      conflicting_equipment(params[:reservation][:equipment_ids], params[:reservation][:quantity], overlapping_reservations)
    end

    # TODO: This logic probably belongs in its own class
    def overlap(reservation, start_time, end_time)
      if start_time < reservation.out_time
        # New reservation starts before other one
        if end_time < reservation.in_time
          return false # Other reservation returned before new one checked out
        else
          return true
        end

      else
        if start_time > reservation.in_time
          return false # Reservation is returned before requested out_time
        else
          return true
        end
      end
    end

    def conflicting_equipment(equipment_ids, quantities, other_reservations)
      equipment = Equipment.where(:id => equipment_ids)
      conflicts = {}
      total_quantities = {}

      equipment.each do |item|
        # Start with the total number of each item and substract the quantities from the reservations
        # that overlap. If this goes below 0, then there's a conflict
        total_quantities[item.id] = item.quantity - quantities[item.id.to_s].to_i
      end

      # Triple nested loops are bad, but they can't be very deep in this scenario and I'm not sure there's another way
      other_reservations.each do |reservation|
        reservation.reservation_equipment.each do |other_item|
          equipment.each do |item|

            if item == other_item.equipment
              total_quantities[item.id] -= other_item.quantity

              if total_quantities[item.id] < 0
                conflicts[item.id] = reservation
              end
            end

          end
        end
      end

      conflicts
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:project,
                                          :user_id,
                                          :in_time, :out_time,
                                          :checked_out_time, :checked_in_time,
                                          :checked_out_by_id, :checked_in_by_id,
                                          :is_approved,
                                          :check_out_comments, :check_in_comments,
                                          equipment_ids: [])
    end
end
