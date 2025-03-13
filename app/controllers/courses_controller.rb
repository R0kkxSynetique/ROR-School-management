class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: [ :show ]

  def index
    @active_courses = Course.active.includes(:room)
    @archived_courses = Course.archived.includes(:room)
  end

  def show
    @teachers = @course.people.where(type: "Employee")
    @school_classes = @course.school_classes.includes(:section)
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end
end
