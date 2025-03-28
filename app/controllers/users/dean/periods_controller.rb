class Users::Dean::PeriodsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_period, only: [ :show, :edit, :update, :destroy ]

  def index
    @periods = Period.includes(:schedules, :school_classes).all
  end

  def show
    @unassigned_schedules = Schedule.includes(:course, :teachers).where(period: nil)
    @unassigned_school_classes = SchoolClass.active.includes(:section).where(period: nil)
  end

  def new
    @period = Period.new
    @unassigned_schedules = Schedule.includes(:course, :teachers).where(period: nil)
    @unassigned_school_classes = SchoolClass.active.includes(:section).where(period: nil)
  end

  def create
    @period = Period.new(period_params)

    if @period.save
      # Update the associations
      Schedule.where(id: params[:schedule_ids]).update_all(period_id: @period.id) if params[:schedule_ids]
      SchoolClass.where(id: params[:school_class_ids]).update_all(period_id: @period.id) if params[:school_class_ids]

      redirect_to users_dean_periods_path, notice: "Period was successfully created."
    else
      @unassigned_schedules = Schedule.includes(:course, :teachers).where(period: nil)
      @unassigned_school_classes = SchoolClass.active.includes(:section).where(period: nil)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @unassigned_schedules = Schedule.includes(:course, :teachers).where(period: [nil, @period.id])
    @unassigned_school_classes = SchoolClass.active.includes(:section).where(period: [nil, @period.id])
  end

  def update
    if @period.update(period_params)
      # First, unassign all current associations
      @period.schedules.update_all(period_id: nil)
      @period.school_classes.update_all(period_id: nil)

      # Then update with new associations
      Schedule.where(id: params[:schedule_ids]).update_all(period_id: @period.id) if params[:schedule_ids]
      SchoolClass.where(id: params[:school_class_ids]).update_all(period_id: @period.id) if params[:school_class_ids]

      redirect_to users_dean_periods_path, notice: "Period was successfully updated."
    else
      @unassigned_schedules = Schedule.includes(:course, :teachers).where(period: [nil, @period.id])
      @unassigned_school_classes = SchoolClass.active.includes(:section).where(period: [nil, @period.id])
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Unassign all associations before destroying
    @period.schedules.update_all(period_id: nil)
    @period.school_classes.update_all(period_id: nil)
    @period.destroy

    redirect_to users_dean_periods_path, notice: "Period was successfully deleted."
  end

  private

  def set_period
    @period = Period.includes(:schedules, :school_classes).find(params[:id])
  end

  def period_params
    params.require(:period).permit(:start_date, :end_date, schedule_ids: [], school_class_ids: [])
  end

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end
