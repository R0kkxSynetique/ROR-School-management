class Users::GradesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_student!

  def index
    @grades = current_user.person.grades.includes(examination: :course)
  end

  private

  def ensure_student!
    unless current_user.person.is_a?(Student)
      redirect_to root_path, alert: "Access denied. Students only."
    end
  end
end
