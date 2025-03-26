class PromotionAssermentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promotion_asserment, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_dean!

  def index
    @promotion_asserments = current_dean.promotion_asserments
  end

  def show
  end

  def new
    @promotion_asserment = current_dean.promotion_asserments.build
    @promotion_asserment.promotion_conditions.build(condition_type: "single_course")
  end

  def create
    @promotion_asserment = current_dean.promotion_asserments.build(promotion_asserment_params)

    if @promotion_asserment.save
      redirect_to @promotion_asserment, notice: "Promotion assessment was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @promotion_asserment.update(promotion_asserment_params)
      redirect_to @promotion_asserment, notice: "Promotion assessment was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @promotion_asserment.destroy
    redirect_to promotion_asserments_url, notice: "Promotion assessment was successfully deleted."
  end

  private

  def set_promotion_asserment
    @promotion_asserment = PromotionAsserment.find(params[:id])
  end

  def promotion_asserment_params
    params.require(:promotion_asserment).permit(
      :name, :description, :effective_date, :active,
      section_ids: [],
      promotion_conditions_attributes: [
        :id, :condition_type, :minimum_grade, :weight, :required,
        :_destroy, course_ids: []
      ]
    )
  end

  def authorize_dean!
    unless current_user&.person&.is_a?(Dean)
      redirect_to root_path, alert: "You are not authorized to manage promotion assessments."
    end
  end

  def current_dean
    current_user.person if current_user&.person&.is_a?(Dean)
  end
end
