class Dean < Employee
  # A Dean is a special type of Employee that can manage specializations, courses, and classes
  def archive_course(course)
    return false unless course.is_a?(Course)
    course.update(status: "archived")
  end

  def unarchive_course(course)
    return false unless course.is_a?(Course)
    course.update(status: "active")
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

  def delete_school_class(school_class)
    return false unless school_class.is_a?(SchoolClass)
    school_class.destroy
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

  def delete_teacher(teacher)
    return false unless teacher.is_a?(Employee) && !teacher.is_a?(Dean)
    teacher.destroy
  end
end
