# Clean the database first to avoid duplicates
# Delete grades first as they depend on examinations and students
Grade.delete_all

# Delete join table associations next
ActiveRecord::Base.connection.execute("DELETE FROM courses_school_classes")
ActiveRecord::Base.connection.execute("DELETE FROM people_school_classes")
ActiveRecord::Base.connection.execute("DELETE FROM school_classes_students")
ActiveRecord::Base.connection.execute("DELETE FROM courses_people")
ActiveRecord::Base.connection.execute("DELETE FROM people_specializations")
ActiveRecord::Base.connection.execute("DELETE FROM grades_people")
ActiveRecord::Base.connection.execute("DELETE FROM promotion_asserments_sections")

# Delete dependent records
Examination.delete_all
Period.delete_all
Schedule.delete_all

# Delete main tables with foreign key dependencies
SchoolClass.delete_all
Course.delete_all
PromotionAsserment.delete_all
Section.delete_all
Room.delete_all
Specialization.delete_all

# Delete people and users last since they have complex relationships
Person.delete_all
User.delete_all
Address.delete_all

puts "Creating standalone data..."

# Create addresses
addresses = 5.times.map do |i|
  Address.create!(
    street: "#{rand(100..999)} #{[ 'Main St', 'Oak Ave', 'Maple Rd', 'Cedar Ln', 'Pine St' ].sample}",
    locality: [ "Downtown", "Uptown", "Midtown", "West End", "East Side" ].sample,
    postal_code: rand(10000..99999).to_s,
    administrative_area: [ "State A", "State B", "State C" ].sample,
    country: [ "Country A", "Country B" ].sample
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
  { name: "IT", description: "Information technology and software development" },
  { name: "Media", description: "Digital media and graphic design" },
  { name: "Polymechanic", description: "Mechanical engineering and robotics" },
  { name: "Business", description: "Business administration and management" }
].map { |section| Section.create!(section) }

# Create specializations
specializations = [
  { name: "Web development", description: "Web application development and design" },
  { name: "Internet of Things", description: "IoT and embedded systems" },
  { name: "Cyber security", description: "Network security and ethical hacking" },
  { name: "Graphic design", description: "Digital media and graphic design" },
  { name: "Mechanical engineering", description: "Mechanical engineering and robotics" },
  { name: "Digital Marketing", description: "Online marketing and social media" }
].map { |spec| Specialization.create!(spec) }

# Create courses with rooms assigned
courses = [
  { name: "MAW2.1", description: "Software architecture exploration" },
  { name: "ROR1", description: "Ruby on rails introduction" },
  { name: "PRW3", description: "Advanced use of web frontend framework" },
  { name: "FRA", description: "French classes" },
  { name: "MKG", description: "Marketing analysis" },
  { name: "MNY", description: "Machinery" },
  { name: "DBS1", description: "Database Systems" },
  { name: "NET1", description: "Network Fundamentals" }
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
  phone_number: "078 123 45 67",
  status: "active",
  type: "Employee",
  address: addresses.first,
  iban: "DE89370400440532013000"
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
    phone_number: "+41 #{format('%02d', 76 + i)} #{format('%03d', rand(100..999))} #{format('%02d', rand(10..99))} #{format('%02d', rand(10..99))}",
    status: "active",
    type: "Dean",
    address: addresses.sample,
    iban: "DE89370400440532099#{format('%03d', i+1)}"
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
    phone_number: "0"+format('%02d', 77 + (i % 3)) + " " + format('%03d', rand(100..999)) + " " + format('%02d', rand(10..99)) + " " + format('%02d', rand(10..99)),
    status: "active",
    type: "Employee",
    address: addresses.sample,
    iban: "DE89370400440532013#{format('%03d', i+1)}"
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
    phone_number: format('%02d', 76 + (i % 4)) + " " + format('%03d', rand(100..999)) + " " + format('%02d', rand(10..99)) + " " + format('%02d', rand(10..99)),
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

# Assign teachers to courses (each teacher teaches 2-4 courses) - Moved this up
teachers.each do |teacher|
  teacher.courses << courses.sample(rand(2..4))
end

# Create schedules and periods
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

    schedule = Schedule.create!(
      start_time: time_slot[:start],
      end_time: time_slot[:end],
      week_day: rand(1..5),
      courses_id: course.id,
      teachers: course_teachers.sample(rand(1..course_teachers.count)) # Assign one or more teachers from the course
    )

    # Create periods for different school classes
    school_classes.sample(rand(1..3)).each do |school_class|
      Period.create!(
        start_date: Date.today,
        end_date: [ 3, 4, 6 ].sample.months.from_now,
        schedule_id: schedule.id,
        school_class_id: school_class.id
      )
    end
  end
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
        title: "#{course.name} #{[ 'Midterm', 'Final', 'Quiz', 'Project' ].sample}",
        expected_date: rand(1..4).months.from_now,
        person: teacher,
        course: course
      )

      # Create grades for students in the course's school classes
      course.school_classes.flat_map(&:students).uniq.each do |student|
        Grade.create!(
          value: (rand(30..60) / 10.0).round(1), # Generates values between 3.0 and 6.0 with 0.1 precision
          effective_date: Date.today,
          examination: exam,
          student: student,
          teachers: [ teacher ]  # Include the teacher directly in the creation
        )
      end
    end
  end
end

# Create and associate promotion requirements
sections.each do |section|
  promotion = PromotionAsserment.create!(
    effective_date: Date.today,
    condition: [ "Minimum grade average of 4.0",
               "Pass all core subjects with minimum 3.5",
               "Complete required projects with grade 4.0 or higher" ].sample
  )
  promotion.sections << section
end

# Assign specializations to relevant people
specializations.each do |specialization|
  # Assign to some teachers
  specialization.people << teachers.sample(rand(1..3))
  # Assign to some students
  specialization.people << students.sample(rand(3..6))
end

puts "Seed data created successfully!"
