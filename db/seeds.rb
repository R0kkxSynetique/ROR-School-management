# Clean the database first to avoid duplicates
# Disable foreign key checks to avoid constraint violations
ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = OFF")

# Delete all tables in order
[
  'grades_people',
  'courses_school_classes',
  'people_school_classes',
  'school_classes_students',
  'courses_people',
  'people_specializations',
  'promotion_asserments_sections',
  'courses_specializations',
  'schedules_teachers'
].each do |table|
  ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
end

[
  Grade,
  Examination,
  Period,
  Schedule,
  SchoolClass,
  Course,
  PromotionAsserment,
  Section,
  Room,
  Specialization,
  User,
  Person,
  Address
].each do |model|
  model.delete_all
end

# Re-enable foreign key checks
ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON")

puts "Creating standalone data..."

# Create addresses
addresses = 5.times.map do |i|
  Address.create!(
    street: Faker::Address.street_address,
    locality: Faker::Address.city,
    postal_code: Faker::Address.zip_code,
    administrative_area: Faker::Address.state,
    country: Faker::Address.country
  )
end

# Create rooms
rooms = [ "101", "102", "201", "202", "301", "302", "Lab1", "Lab2" ].map do |room_number|
  Room.create!(
    name: "SC#{room_number}"
  )
end

# Create sections
sections = [
  { name: "IT", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "Media", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "Polymechanic", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "Business", description: Faker::Lorem.paragraph(sentence_count: 2) }
].map { |section| Section.create!(section) }

# Create specializations
specializations = [
  { name: "Web development", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "Internet of Things", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "Cyber security", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "Graphic design", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "Mechanical engineering", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "Digital Marketing", description: Faker::Lorem.paragraph(sentence_count: 2) }
].map { |spec| Specialization.create!(spec) }

# Create courses with rooms assigned
courses = [
  { name: "MAW2.1", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "ROR1", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "PRW3", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "FRA", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "MKG", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "MNY", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "DBS1", description: Faker::Lorem.paragraph(sentence_count: 2) },
  { name: "NET1", description: Faker::Lorem.paragraph(sentence_count: 2) }
].map { |course| Course.create!(course.merge(status: "active", room: rooms.sample)) }

# Create school classes
school_classes = sections.flat_map do |section|
  2.times.map do |i|
    SchoolClass.create!(
      uid: "CLS-#{section.name.first(3)}-#{rand(100..999)}",
      name: "#{section.name} Class #{i + 1}",
      section: section
    )
  end
end

# Create initial admin and users
admin_person = Person.create!(
  username: "admin",
  lastname: "Admin",
  firstname: "System",
  phone_number: "+41 #{rand(70..79)} #{rand(100..999)} #{rand(10..99)} #{rand(10..99)}",
  status: "active",
  type: "Employee",
  address: addresses.first,
  iban: Faker::Bank.iban(country_code: 'de')
)

admin_user = User.create!(
  email: "admin@school.edu",
  password: "password123",
  password_confirmation: "password123"
)
admin_person.update!(user: admin_user)

# Create deans
deans = 2.times.map do |i|
  dean = Person.create!(
    username: "dean#{i}",
    lastname: Faker::Name.last_name,
    firstname: Faker::Name.first_name,
    phone_number: "+41 #{rand(70..79)} #{rand(100..999)} #{rand(10..99)} #{rand(10..99)}",
    status: "active",
    type: "Dean",
    address: addresses.sample,
    iban: Faker::Bank.iban(country_code: 'de')
  )

  user = User.create!(
    email: "dean#{i}@school.edu",
    password: "password123",
    password_confirmation: "password123"
  )
  dean.update!(user: user)
  dean
end

# Create teachers
teachers = 8.times.map do |i|
  teacher = Person.create!(
    username: "teacher#{i}",
    lastname: Faker::Name.last_name,
    firstname: Faker::Name.first_name,
    phone_number: "+41 #{rand(70..79)} #{rand(100..999)} #{rand(10..99)} #{rand(10..99)}",
    status: "active",
    type: "Employee",
    address: addresses.sample,
    iban: Faker::Bank.iban(country_code: 'de')
  )

  user = User.create!(
    email: "teacher#{i}@school.edu",
    password: "password123",
    password_confirmation: "password123"
  )
  teacher.update!(user: user)
  teacher
end

# Create students
students = 20.times.map do |i|
  student = Person.create!(
    username: "student#{i}",
    lastname: Faker::Name.last_name,
    firstname: Faker::Name.first_name,
    phone_number: "+41 #{rand(70..79)} #{rand(100..999)} #{rand(10..99)} #{rand(10..99)}",
    status: "active",
    type: "Student",
    address: addresses.sample
  )

  user = User.create!(
    email: "student#{i}@school.edu",
    password: "password123",
    password_confirmation: "password123"
  )
  student.update!(user: user)
  student
end

puts "Creating relationships..."

# Associate courses with school classes (each class gets 3-5 courses)
school_classes.each do |school_class|
  school_class.courses << courses.sample(rand(3..5))
end

# Assign teachers to courses (each teacher teaches 2-4 courses)
teachers.each do |teacher|
  teacher.courses << courses.sample(rand(2..4))
end

# Create schedules
courses.each do |course|
  rand(2..4).times do
    time_slot = [
      { start: "08:00", end: "09:30" },
      { start: "10:00", end: "11:30" },
      { start: "13:00", end: "14:30" },
      { start: "15:00", end: "16:30" }
    ].sample

    # Get teachers assigned to this course
    course_teachers = course.people.where(type: 'Employee')
    next if course_teachers.empty? # Skip if no teachers are assigned

    Schedule.create!(
      start_time: time_slot[:start],
      end_time: time_slot[:end],
      week_day: rand(1..5),
      courses_id: course.id,
      teachers: course_teachers.sample(1) # Always assign at least one teacher
    )
  end
end

# Create periods (independent of schedules and school classes)
10.times do
  start_date = Faker::Date.between(from: Date.today, to: 1.month.from_now)
  Period.create!(
    start_date: start_date,
    end_date: Faker::Date.between(from: start_date + 2.months, to: start_date + 6.months)
  )
end

# Assign students to school classes (each student in 1-2 classes)
students.each do |student|
  student.school_classes << school_classes.sample(rand(1..2))
end

# Create examinations and grades
courses.each do |course|
  course.people.where(type: 'Employee').each do |teacher|
    2.times do
      exam = Examination.create!(
        title: "#{course.name} #{Faker::Educator.course_name}",
        expected_date: Faker::Date.between(from: 1.month.from_now, to: 4.months.from_now),
        person: teacher,
        course: course
      )

      # Create grades for students in the course's school classes
      course.school_classes.flat_map(&:students).uniq.each do |student|
        Grade.create!(
          value: rand(3.5..6.0).round(1),
          effective_date: exam.expected_date,
          examination: exam,
          student: student
        )
      end
    end
  end
end

puts "Creating promotion assessments..."
# Create promotion assessments with various condition types
sections.each do |section|
  # Create 2-3 promotion assessments per section
  rand(2..3).times do |i|
    promotion = PromotionAsserment.create!(
      name: "#{section.name} Promotion #{Date.today.year} - Set #{i + 1}",
      description: Faker::Lorem.paragraph(sentence_count: 3),
      effective_date: Faker::Date.between(from: Date.today, to: 1.month.from_now),
      active: true,
      dean: deans.sample
    )

    # Add section association
    promotion.sections << section

    # Create overall average condition (always present)
    PromotionCondition.create!(
      promotion_asserment: promotion,
      condition_type: 'overall_average',
      minimum_grade: Faker::Number.between(from: 3.5, to: 4.5).round(1),
      weight: Faker::Number.between(from: 0.8, to: 1.0).round(1),
      required: true
    )

    # Create single course conditions for important courses
    section_courses = section.school_classes.flat_map(&:courses).uniq
    section_courses.sample(2).each do |course|
      PromotionCondition.create!(
        promotion_asserment: promotion,
        condition_type: 'single_course',
        minimum_grade: Faker::Number.between(from: 3.0, to: 4.0).round(1),
        weight: Faker::Number.between(from: 0.6, to: 0.8).round(1),
        required: true,
        courses: [ course ]
      )
    end

    # Create one multiple courses condition
    PromotionCondition.create!(
      promotion_asserment: promotion,
      condition_type: 'multiple_courses',
      minimum_grade: Faker::Number.between(from: 3.5, to: 4.5).round(1),
      weight: Faker::Number.between(from: 0.4, to: 0.6).round(1),
      required: false,
      courses: section_courses.sample(3)
    )
  end
end

# Assign specializations to relevant people
specializations.each do |specialization|
  # Assign to some teachers
  specialization.people << teachers.sample(rand(1..3))
  # Assign to some students
  specialization.people << students.sample(rand(3..6))
end

puts "Seed data created successfully!"
