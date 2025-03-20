class Users::Dean::StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_student, only: [ :edit, :update, :archive ]

  def index
    @active_students = Student.active.includes(:address)
    @archived_students = Student.archived.includes(:address)
  end

  def new
    @student = Student.new
    @student.build_address
  end

  def create
    if address_params
      existing_address = Address.find_by(
        street: address_params[:street],
        locality: address_params[:locality],
        postal_code: address_params[:postal_code],
        administrative_area: address_params[:administrative_area],
        country: address_params[:country]
      )
      address = existing_address || Address.create!(address_params)

      @student = Student.new(student_params.merge(address: address))

      if @student.save
        redirect_to users_dean_students_path, notice: "Student was successfully created."
      else
        @student.build_address(address_params)
        render :new, status: :unprocessable_entity
      end
    else
      @student = Student.new(student_params)
      @student.errors.add(:address, "must be provided")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if address_params
      existing_address = Address.find_by(
        street: address_params[:street],
        locality: address_params[:locality],
        postal_code: address_params[:postal_code],
        administrative_area: address_params[:administrative_area],
        country: address_params[:country]
      )
      address = existing_address || Address.create!(address_params)

      if @student.update(student_params.merge(address: address))
        redirect_to users_dean_students_path, notice: "Student was successfully updated."
      else
        @student.build_address(address_params)
        render :edit, status: :unprocessable_entity
      end
    else
      @student.errors.add(:address, "must be provided")
      render :edit, status: :unprocessable_entity
    end
  end

  def archive
    if @student.update(status: "archived")
      redirect_to users_dean_students_path, notice: "Student was successfully archived."
    else
      redirect_to users_dean_students_path, alert: "Failed to archive student."
    end
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:firstname, :lastname, :username, :phone_number, :status)
  end

  def address_params
    params.require(:student).require(:address_attributes).permit(:street, :locality, :postal_code, :administrative_area, :country)
  rescue ActionController::ParameterMissing
    nil
  end

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end
