module Users
  module Dean
    class PromotionAssermentsController < Users::DeanController
      before_action :set_promotion_asserment, only: [ :edit, :update, :destroy ]

      def index
        @promotion_asserments = PromotionAsserment.all
      end

      def new
        @promotion_asserment = PromotionAsserment.new
        @sections = Section.all
        @courses = Course.all
        @variables = PromotionAsserment::VARIABLES
        @operators = PromotionAsserment::VALID_OPERATORS
      end

      def create
        @promotion_asserment = PromotionAsserment.new(promotion_asserment_params)
        if @promotion_asserment.save
          redirect_to users_dean_promotion_asserments_path, notice: "Promotion requirement was successfully created."
        else
          @sections = Section.all
          @courses = Course.all
          @variables = PromotionAsserment::VARIABLES
          @operators = PromotionAsserment::VALID_OPERATORS
          render :new
        end
      end

      def edit
        @sections = Section.all
        @courses = Course.all
        @variables = PromotionAsserment::VARIABLES
        @operators = PromotionAsserment::VALID_OPERATORS
      end

      def update
        if @promotion_asserment.update(promotion_asserment_params)
          redirect_to users_dean_promotion_asserments_path, notice: "Promotion requirement was successfully updated."
        else
          @sections = Section.all
          @courses = Course.all
          @variables = PromotionAsserment::VARIABLES
          @operators = PromotionAsserment::VALID_OPERATORS
          render :edit
        end
      end

      def destroy
        @promotion_asserment.destroy
        redirect_to users_dean_promotion_asserments_path, notice: "Promotion requirement was successfully deleted."
      end

      private

      def set_promotion_asserment
        @promotion_asserment = PromotionAsserment.find(params[:id])
      end

      def promotion_asserment_params
        params.require(:promotion_asserment).permit(
          :effective_date,
          :condition_variable,
          :condition_operator,
          :condition_value,
          course_ids: [],
          section_ids: []
        )
      end
    end
  end
end
