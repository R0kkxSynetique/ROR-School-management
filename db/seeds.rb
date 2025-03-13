# Clean the database first to avoid duplicates
Grade.delete_all
Examination.delete_all
Period.delete_all
Schedule.delete_all
# Delete join table associations first
ActiveRecord::Base.connection.execute("DELETE FROM courses_school_classes")
ActiveRecord::Base.connection.execute("DELETE FROM people_school_classes")
ActiveRecord::Base.connection.execute("DELETE FROM school_classes_students")
ActiveRecord::Base.connection.execute("DELETE FROM courses_people")
ActiveRecord::Base.connection.execute("DELETE FROM people_specializations")
ActiveRecord::Base.connection.execute("DELETE FROM promotion_asserments_sections")
# Now delete the main tables
SchoolClass.delete_all
Course.delete_all
PromotionAsserment.delete_all
Section.delete_all
Room.delete_all
Specialization.delete_all
# Delete users and related records last due to foreign key dependencies
User.delete_all
Person.delete_all
Address.delete_all

# Create addresses first
addresses = [
  Address.create!(
    street: "123 Main St",
    locality: "Downtown",
    postal_code: "12345",
    administrative_area: "State",
    country: "Country"
  ),
  Address.create!(
    street: "456 Oak Ave",
    locality: "Uptown",
    postal_code: "67890",
    administrative_area: "State",
    country: "Country"
  )
]

# Create initial admin person first
admin_person = Person.create!(
  username: "admin",
  lastname: "Admin",
  firstname: "System",
  phone_number: "123-456-7890",
  status: "active",
  type: "Employee",
  address: addresses.first,
  iban: "DE89370400440532013000"
)

# Then create admin user
admin_user = User.create!(
  email: "admin@school.edu",
  password: "password123",
  password_confirmation: "password123"
)

# Link admin person to user
admin_person.update!(user: admin_user)

# Create rooms
rooms = [
  Room.create!(name: "101"),
  Room.create!(name: "102"),
  Room.create!(name: "Lab 1"),
  Room.create!(name: "Auditorium")
]

# Create sections
sections = [
  Section.create!(name: "Computer Science", description: "Technology and programming focused education"),
  Section.create!(name: "Mathematics", description: "Advanced mathematical studies"),
  Section.create!(name: "Physics", description: "Physical sciences and experiments")
]

# Create specializations
specializations = [
  Specialization.create!(name: "Web Development", description: "Focus on web technologies"),
  Specialization.create!(name: "Data Science", description: "Focus on data analysis and ML"),
  Specialization.create!(name: "Network Security", description: "Focus on cybersecurity")
]

# Create courses
courses = rooms.map.with_index do |room, i|
  Course.create!(
    name: "Course #{i + 1}",
    description: "Description for Course #{i + 1}",
    status: "active",
    room_id: room.id
  )
end

# Create school classes
school_classes = sections.map do |section|
  SchoolClass.create!(
    uid: "CLS-#{section.name.first(3)}-#{rand(100..999)}",
    name: "#{section.name} Class",
    section_id: section.id
  )
end

# Associate courses with school classes
school_classes.each do |school_class|
  school_class.courses << courses.sample(2)
end

# Create schedules and periods
courses.each do |course|
  schedule = Schedule.create!(

    start_time: "09:00",
    end_time: "10:30",
    week_day: rand(1..5),
    courses_id: course.id
  )

  Period.create!(
    start_date: Date.today,
    end_date: 4.months.from_now,
    schedule_id: schedule.id,
    school_class_id: school_classes.first.id
  )
end

# Create teachers first
5.times do |i|
  teacher = Person.create!(
    username: "teacher#{i}",
    lastname: "Teacher#{i}",
    firstname: "Name#{i}",
    phone_number: "555-000-#{format('%04d', i)}",
    status: "active",
    type: "Employee",
    address: addresses.sample,
    iban: "DE89370400440532013#{format('%03d', i+1)}"
  )

  # Then create and link user
  user = User.create!(
    email: "teacher#{i}@school.edu",
    password: "password123",
    password_confirmation: "password123"
  )

  teacher.update!(user: user)
end

# Create students first
5.times do |i|
  student = Person.create!(
    username: "student#{i}",
    lastname: "Student#{i}",
    firstname: "Name#{i}",
    phone_number: "555-111-#{format('%04d', i)}",
    status: "active",
    type: "Student",
    address: addresses.sample
  )

  # Then create and link user
  user = User.create!(
    email: "student#{i}@school.edu",
    password: "password123",
    password_confirmation: "password123"
  )

  student.update!(user: user)
end

# Create some examinations and grades
teacher = Person.where(type: "Employee").first
students = Person.where(type: "Student")

courses.each do |course|
  exam = Examination.create!(
    title: "#{course.name} Midterm",
    expected_date: 2.months.from_now,
    person: teacher,
    course: course
  )

  students.each do |student|
    Grade.create!(
      value: rand(60..100),
      effective_date: Date.today,
      examination_id: exam.id,
      student_id: student.id
    )
  end
end

# Create promotion requirements
promotion = PromotionAsserment.create!(
  effective_date: Date.today,
  condition: "Minimum grade average of 70%"
)

# Associate promotion requirements with sections
sections.each do |section|
  promotion.sections << section
end

puts "Seed data created successfully!"
