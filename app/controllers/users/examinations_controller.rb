class Users::ExaminationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_teacher!
  before_action :set_examination, only: [ :show, :edit, :update, :destroy ]

  def index
    @examinations = current_user.person.examinations.includes(:course)
  end

  def show
    @grades = @examination.grades.includes(:student)
  end

  def new
    @examination = Examination.new
    @available_courses = current_user.person.courses.active
  end

  def create
    @examination = Examination.new(examination_params)
    @examination.person = current_user.person

    if @examination.save
      redirect_to users_examination_path(@examination), notice: "Examination was successfully created."
    else
      @available_courses = current_user.person.courses.active
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_courses = current_user.person.courses.active
  end

  def update
    if @examination.update(examination_params)
      redirect_to users_examination_path(@examination), notice: "Examination was successfully updated."
    else
      @available_courses = current_user.person.courses.active
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @examination.destroy
    redirect_to users_examinations_path, notice: "Examination was successfully deleted."
  end

  private

  def set_examination
    @examination = current_user.person.examinations.find(params[:id])
  end

  def examination_params
    params.require(:examination).permit(:title, :expected_date, :course_id)
  end

  def ensure_teacher!
    unless current_user.person.is_a?(Employee)
      redirect_to root_path, alert: "Access denied. Teachers only."
    end
  end
end
