class Dean < Employee
  # A Dean is a special type of Employee that can manage specializations, courses, and classes
  has_many :promotion_asserments, dependent: :nullify

  def archive_course(course)
    return false unless course.is_a?(Course)
    course.update(status: "archived")
  end

  def unarchive_course(course)
    return false unless course.is_a?(Course)
    course.update(status: "active")
  end

  def archive_teacher(teacher)
    return false unless teacher.is_a?(Employee) && !teacher.is_a?(Dean)
    teacher.update(status: "archived")
  end

  def unarchive_teacher(teacher)
    return false unless teacher.is_a?(Employee) && !teacher.is_a?(Dean)
    teacher.update(status: "active")
  end

  def assign_specialization_to_professor(specialization, professor)
    return false unless professor.is_a?(Employee)
    professor.specializations << specialization
  end

  def create_school_class(attributes = {})
    SchoolClass.create(attributes)
  end

  def assign_student_to_class(student, school_class)
    return false unless student.is_a?(Student) && school_class.is_a?(SchoolClass)
    return false if school_class.students.include?(student)
    school_class.students << student
  end

  def remove_student_from_class(student, school_class)
    return false unless student.is_a?(Student) && school_class.is_a?(SchoolClass)
    school_class.students.delete(student)
  end

  def archive_school_class(school_class)
    return false unless school_class.is_a?(SchoolClass)
    school_class.archive!
  end

  def unarchive_school_class(school_class)
    return false unless school_class.is_a?(SchoolClass)
    school_class.unarchive!
  end

  def delete_school_class(school_class)
    archive_school_class(school_class)
  end

  def update_school_class(school_class, attributes)
    return false unless school_class.is_a?(SchoolClass)
    school_class.update(attributes)
  end

  def create_teacher(attributes = {})
    attributes[:type] = "Employee"
    Employee.create(attributes)
  end

  def update_teacher(teacher, attributes)
    return false unless teacher.is_a?(Employee) && !teacher.is_a?(Dean)
    teacher.update(attributes)
  end

  def create_student(attributes = {})
    Student.create(attributes)
  end

  def update_student(student, attributes)
    return false unless student.is_a?(Student)
    student.update(attributes)
  end

  def archive_student(student)
    return false unless student.is_a?(Student)
    student.update(status: "archived")
  end

  def unarchive_student(student)
    return false unless student.is_a?(Student)
    student.update(status: "active")
  end

  def can_manage_promotions?
    true
  end

  def promotion_asserments_for_section(section)
    promotion_asserments.joins(:sections).where(sections: { id: section.id })
  end

  def active_promotion_asserments
    promotion_asserments.where(active: true)
  end
end
