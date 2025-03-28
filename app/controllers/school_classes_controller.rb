class SchoolClassesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_school_class, only: [ :show ]

  def show
    @students = @school_class.students.includes(:user)
    @courses = @school_class.courses.includes(:room)
  end

  private

  def set_school_class
    @school_class = SchoolClass.find(params[:id])
  end
end
