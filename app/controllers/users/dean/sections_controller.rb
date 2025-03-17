class Users::Dean::SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_section, only: [ :edit, :update, :destroy ]

  def index
    @sections = Section.all
  end

  def new
    @section = Section.new
  end

  def create
    @section = Section.new(section_params)
    if @section.save
      redirect_to users_dean_sections_path, notice: "Section was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @section.update(section_params)
      redirect_to users_dean_sections_path, notice: "Section was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @section.school_classes.any?
      redirect_to users_dean_sections_path, alert: "Cannot delete section that has classes."
    else
      @section.destroy
      redirect_to users_dean_sections_path, notice: "Section was successfully deleted."
    end
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:name, :description)
  end

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end
