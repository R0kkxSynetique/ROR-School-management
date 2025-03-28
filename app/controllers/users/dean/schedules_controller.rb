class Users::Dean::SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_schedule, only: [ :edit, :update, :destroy ]

  def index
    @schedules = Schedule.includes(:course, :period, :teachers).all
  end

  def new
    @schedule = Schedule.new
    @courses = Course.active
    @teachers = Employee.where(type: "Employee", status: "active")
    @school_classes = SchoolClass.active.includes(:section)
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.school_class_ids = params[:schedule][:school_class_ids]

    if @schedule.save
      # Update the school classes' period if a period is selected
      if @schedule.period_id.present? && params[:schedule][:school_class_ids].present?
        # Only update school classes that are associated with the selected course
        course_school_classes = @schedule.course.school_classes.where(id: params[:schedule][:school_class_ids])
        course_school_classes.update_all(period_id: @schedule.period_id)
      end

      redirect_to users_dean_schedules_path, notice: "Schedule was successfully created."
    else
      @courses = Course.active
      @teachers = Employee.where(type: "Employee", status: "active")
      @school_classes = SchoolClass.active.includes(:section)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @courses = Course.active
    @teachers = Employee.where(type: "Employee", status: "active")
    @school_classes = SchoolClass.active.includes(:section)
    # Only pre-select school classes that are associated with the course
    @schedule.school_class_ids = @schedule.period&.school_classes&.joins(:courses)
      &.where(courses_school_classes: { course_id: @schedule.courses_id })&.pluck(:id)
  end

  def update
    @schedule.school_class_ids = params[:schedule][:school_class_ids]

    if @schedule.update(schedule_params)
      # Update the school classes' period if a period is selected
      if @schedule.period_id.present? && params[:schedule][:school_class_ids].present?
        # First, unassign all current school classes from this period that are associated with this course
        if @schedule.period
          @schedule.period.school_classes.joins(:courses)
            .where(courses_school_classes: { course_id: @schedule.courses_id })
            .update_all(period_id: nil)
        end
        # Then assign the new school classes that are associated with this course
        course_school_classes = @schedule.course.school_classes.where(id: params[:schedule][:school_class_ids])
        course_school_classes.update_all(period_id: @schedule.period_id)
      end

      redirect_to users_dean_schedules_path, notice: "Schedule was successfully updated."
    else
      @courses = Course.active
      @teachers = Employee.where(type: "Employee", status: "active")
      @school_classes = SchoolClass.active.includes(:section)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Unassign school classes from the period before destroying the schedule
    if @schedule.period
      # Only unassign school classes that are associated with this course
      @schedule.period.school_classes.joins(:courses)
        .where(courses_school_classes: { course_id: @schedule.courses_id })
        .update_all(period_id: nil)
    end
    @schedule.destroy
    redirect_to users_dean_schedules_path, notice: "Schedule was successfully deleted."
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:start_time, :end_time, :week_day, :courses_id, :period_id, teacher_ids: [])
  end

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end
