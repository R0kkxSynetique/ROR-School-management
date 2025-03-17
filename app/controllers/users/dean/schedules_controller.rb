class Users::Dean::SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_schedule, only: [ :edit, :update, :destroy ]

  def index
    @schedules = Schedule.includes(:course, :school_classes).all
  end

  def new
    @schedule = Schedule.new
    @courses = Course.active
    @school_classes = SchoolClass.all
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save && create_periods
      redirect_to users_dean_schedules_path, notice: "Schedule was successfully created."
    else
      @courses = Course.active
      @school_classes = SchoolClass.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @courses = Course.active
    @school_classes = SchoolClass.all
  end

  def update
    if @schedule.update(schedule_params) && update_periods
      redirect_to users_dean_schedules_path, notice: "Schedule was successfully updated."
    else
      @courses = Course.active
      @school_classes = SchoolClass.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @schedule.destroy
    redirect_to users_dean_schedules_path, notice: "Schedule was successfully deleted."
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:start_time, :end_time, :week_day, :courses_id)
  end

  def period_params
    params.require(:schedule).permit(:start_date, :end_date, school_class_ids: [])
  end

  def create_periods
    return true unless period_params[:school_class_ids].present?

    period_params[:school_class_ids].each do |school_class_id|
      period = @schedule.periods.build(
        start_date: period_params[:start_date],
        end_date: period_params[:end_date],
        school_class_id: school_class_id
      )
      return false unless period.save
    end
    true
  end

  def update_periods
    return true unless period_params[:school_class_ids].present?

    @schedule.periods.destroy_all
    create_periods
  end

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end
