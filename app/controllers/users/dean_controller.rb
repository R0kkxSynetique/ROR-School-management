class Users::DeanController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_dean
  before_action :set_course, only: [ :archive_course ]
  before_action :set_school_class, only: [ :assign_student, :new_student_assignment, :edit_class, :update_class, :delete_class, :remove_student ]
  before_action :set_teacher, only: [ :edit_teacher, :update_teacher, :delete_teacher ]

  def dashboard
    @recent_classes = SchoolClass.order(created_at: :desc).limit(5)
  end

  def school_classes_index
    @school_classes = SchoolClass.includes(:section).all
  end

  def new_class
    @school_class = SchoolClass.new
  end

  def create_class
    @school_class = @dean.create_school_class(school_class_params)
    if @school_class.persisted?
      redirect_to school_class_path(@school_class), notice: "Class was successfully created."
    else
      render :new_class, status: :unprocessable_entity
    end
  end

  def edit_class
  end

  def update_class
    if @school_class.update(school_class_params)
      redirect_to school_class_path(@school_class), notice: "Class was successfully updated."
    else
      render :edit_class, status: :unprocessable_entity
    end
  end

  def delete_class
    @school_class.destroy
    redirect_to users_dean_school_classes_path, notice: "Class was successfully deleted."
  end

  def new_specialization_assignment
    @professors = Employee.where.not(type: "Dean")
    @specializations = Specialization.all
  end

  def assign_specialization
    professor = Employee.find(params[:professor_id])
    specialization = Specialization.find(params[:specialization_id])

    if @dean.assign_specialization_to_professor(specialization, professor)
      redirect_to users_dean_dashboard_path, notice: "Specialization was successfully assigned to #{professor.firstname} #{professor.lastname}."
    else
      redirect_to users_dean_dashboard_path, alert: "Failed to assign specialization."
    end
  end

  def new_student_assignment
    @students = Student.where.not(id: @school_class.student_ids)
  end

  def assign_student
    student = Student.find(params[:student_id])
    if @dean.assign_student_to_class(student, @school_class)
      redirect_to school_class_path(@school_class), notice: "Student was successfully assigned to class."
    else
      redirect_to school_class_path(@school_class), alert: "Failed to assign student to class."
    end
  end

  def remove_student
    student = Student.find(params[:student_id])
    if @dean.remove_student_from_class(student, @school_class)
      redirect_to school_class_path(@school_class), notice: "Student was successfully removed from class."
    else
      redirect_to school_class_path(@school_class), alert: "Failed to remove student from class."
    end
  end

  def archive_course
    if @dean.archive_course(@course)
      redirect_to courses_path, notice: "Course was successfully archived."
    else
      redirect_to courses_path, alert: "Failed to archive course."
    end
  end

  def teachers_index
    @teachers = Employee.where.not(type: "Dean").includes(:user)
  end

  def new_teacher
    @teacher = Employee.new
    load_specializations
  end

  def create_teacher
    @teacher = @dean.create_teacher(teacher_params)
    if @teacher.persisted?
      @teacher.specialization_ids = params[:employee][:specialization_ids] if params[:employee][:specialization_ids]
      redirect_to users_dean_teachers_path, notice: "Teacher was successfully created."
    else
      load_specializations
      render :new_teacher, status: :unprocessable_entity
    end
  end

  def edit_teacher
    load_specializations
  end

  def update_teacher
    if @dean.update_teacher(@teacher, teacher_params)
      @teacher.specialization_ids = params[:employee][:specialization_ids] if params[:employee][:specialization_ids]
      redirect_to users_dean_teachers_path, notice: "Teacher was successfully updated."
    else
      load_specializations
      render :edit_teacher, status: :unprocessable_entity
    end
  end

  def delete_teacher
    if @dean.delete_teacher(@teacher)
      redirect_to users_dean_teachers_path, notice: "Teacher was successfully deleted."
    else
      redirect_to users_dean_teachers_path, alert: "Failed to delete teacher."
    end
  end

  private

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end

  def set_dean
    @dean = current_user.person
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_school_class
    @school_class = SchoolClass.find(params[:id] || params[:school_class_id])
  end

  def set_teacher
    @teacher = Employee.where.not(type: "Dean").find(params[:id])
  end

  def school_class_params
    params.require(:school_class).permit(:name, :uid, :section_id)
  end

  def teacher_params
    params.require(:employee).permit(:firstname, :lastname, :username, :phone_number, :iban)
  end

  def load_specializations
    @specializations = Specialization.all
  end
end
