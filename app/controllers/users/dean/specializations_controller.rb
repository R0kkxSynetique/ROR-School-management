class Users::Dean::SpecializationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_specialization, only: [ :edit, :update, :destroy ]

  def index
    @specializations = Specialization.includes(:people).all
  end

  def new
    @specialization = Specialization.new
    @teachers = Employee.where(type: "Employee", status: "active")
  end

  def create
    @specialization = Specialization.new(specialization_params)

    if @specialization.save
      redirect_to users_dean_specializations_path, notice: "Specialization was successfully created."
    else
      @teachers = Employee.where(type: "Employee", status: "active")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @teachers = Employee.where(type: "Employee", status: "active")
  end

  def update
    if @specialization.update(specialization_params)
      redirect_to users_dean_specializations_path, notice: "Specialization was successfully updated."
    else
      @teachers = Employee.where(type: "Employee", status: "active")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @specialization.destroy
    redirect_to users_dean_specializations_path, notice: "Specialization was successfully deleted."
  end

  private

  def set_specialization
    @specialization = Specialization.find(params[:id])
  end

  def specialization_params
    params.require(:specialization).permit(:name, :description, person_ids: [])
  end

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end
