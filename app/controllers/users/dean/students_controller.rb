class Users::Dean::StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_student, only: [ :edit, :update, :destroy, :archive, :unarchive ]

  def index
    @active_students = Student.active.includes(:user, :address)
    @archived_students = Student.archived.includes(:user, :address)
  end

  def new
    @student = Student.new
    @student.build_address
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to users_dean_students_path, notice: "Student was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @student.update(student_params)
      redirect_to users_dean_students_path, notice: "Student was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy
    redirect_to users_dean_students_path, notice: "Student was successfully deleted."
  end

  def archive
    @student.archive!
    redirect_to users_dean_students_path, notice: "Student was successfully archived."
  end

  def unarchive
    @student.unarchive!
    redirect_to users_dean_students_path, notice: "Student was successfully unarchived."
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(
      :username, :firstname, :lastname, :email, :phone_number,
      address_attributes: [ :street, :locality, :postal_code, :administrative_area, :country ]
    )
  end

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end
