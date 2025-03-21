class DeanPolicy
  attr_reader :user, :dean

  def initialize(user, dean)
    @user = user
    @dean = dean
  end

  def manage_courses?
    user.person.is_a?(Dean)
  end

  def manage_specializations?
    user.person.is_a?(Dean)
  end

  def manage_school_classes?
    user.person.is_a?(Dean)
  end

  def manage_students?
    user.person.is_a?(Dean)
  end

  def manage_promotion_asserments?
    user.person.is_a?(Dean)
  end
end
