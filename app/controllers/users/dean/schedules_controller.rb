class Users::Dean::SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_schedule, only: [ :edit, :update, :destroy ]

  def index
    @schedules = Schedule.includes(:course, :school_classes, :teachers).all
  end

  def new
    @schedule = Schedule.new
    @courses = Course.active
    @teachers = Employee.where(type: "Employee", status: "active")
  end

  def create
    @schedule = Schedule.new(schedule_params)

    if @schedule.save
      redirect_to users_dean_schedules_path, notice: "Schedule was successfully created."
    else
      @courses = Course.active
      @teachers = Employee.where(type: "Employee", status: "active")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @courses = Course.active
    @teachers = Employee.where(type: "Employee", status: "active")
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to users_dean_schedules_path, notice: "Schedule was successfully updated."
    else
      @courses = Course.active
      @teachers = Employee.where(type: "Employee", status: "active")
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
    params.require(:schedule).permit(:start_time, :end_time, :week_day, :courses_id, teacher_ids: [])
  end

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end
