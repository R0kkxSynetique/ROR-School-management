class Users::TeacherGradesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_teacher!
  before_action :set_examination
  before_action :set_grade, only: [ :edit, :update, :destroy ]

  def index
    @grades = @examination.grades.includes(:student)
  end

  def new
    @grade = @examination.grades.build
    @available_students = available_students
  end

  def create
    @grade = @examination.grades.build(grade_params)
    @grade.grades_people.build(person: current_user.person)

    if @grade.save
      redirect_to users_examination_path(@examination), notice: "Grade was successfully created."
    else
      @available_students = available_students
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_students = available_students
  end

  def update
    if @grade.update(grade_params)
      redirect_to users_examination_path(@examination), notice: "Grade was successfully updated."
    else
      @available_students = available_students
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @grade.destroy
    redirect_to users_examination_path(@examination), notice: "Grade was successfully deleted."
  end

  private

  def set_examination
    @examination = current_user.person.examinations.find(params[:examination_id])
  end

  def set_grade
    @grade = @examination.grades.find(params[:id])
  end

  def grade_params
    params.require(:grade).permit(:value, :effective_date, :student_id)
  end

  def ensure_teacher!
    unless current_user.person.is_a?(Employee)
      redirect_to root_path, alert: "Access denied. Teachers only."
    end
  end

  def available_students
    @examination.course.school_classes.flat_map(&:students).uniq
  end
end
