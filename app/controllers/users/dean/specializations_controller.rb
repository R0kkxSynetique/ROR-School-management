class Users::Dean::SpecializationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_specialization, only: [ :edit, :update, :archive, :unarchive ]

  def index
    @active_specializations = Specialization.where(archived: false)
    @archived_specializations = Specialization.where(archived: true)
  end

  def new
    @specialization = Specialization.new
  end

  def create
    @specialization = Specialization.new(specialization_params)

    if @specialization.save
      redirect_to users_dean_specializations_path, notice: "Specialization was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @specialization.update(specialization_params)
      redirect_to users_dean_specializations_path, notice: "Specialization was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def archive
    @specialization.update(archived: true)
    redirect_to users_dean_specializations_path, notice: "Specialization was successfully archived."
  end

  def unarchive
    @specialization.update(archived: false)
    redirect_to users_dean_specializations_path, notice: "Specialization was successfully unarchived."
  end

  private

  def set_specialization
    @specialization = Specialization.find(params[:id])
  end

  def specialization_params
    params.require(:specialization).permit(:name, :description)
  end

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end
