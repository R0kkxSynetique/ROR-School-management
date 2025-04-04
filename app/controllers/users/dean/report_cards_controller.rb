class Users::Dean::ReportCardsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!

  def index
    @school_classes = SchoolClass.includes(students: { grades: { examination: :course } })
  end

  def generate
    if params[:student_ids].blank?
      redirect_to users_dean_report_cards_path, alert: "Please select at least one student to generate report cards."
      return
    end

    @students = Student.find(params[:student_ids])
    respond_to do |format|
      format.pdf do
        pdf = ::GenerateReportCardsPdf.new(@students)
        send_data pdf.render, filename: "report_cards.pdf",
                            type: "application/pdf",
                            disposition: "inline"
      end
    end
  end

  private

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end
