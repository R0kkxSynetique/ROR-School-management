require "prawn"
require "prawn/table"

class GenerateReportCardsPdf
  def initialize(students)
    @students = students
    @pdf = Prawn::Document.new
  end

  def render
    @students.each_with_index do |student, index|
      @pdf.start_new_page if index > 0
      generate_student_report_card(student)
    end
    @pdf.render
  end

  private

  def generate_student_report_card(student)
    @pdf.font_size(20) { @pdf.text "Student Report Card", align: :center }
    @pdf.move_down 20

    # Student Information
    @pdf.font_size(12) do
      @pdf.text "Student: #{student.firstname} #{student.lastname}"
      @pdf.text "ID: #{student.username}"
      @pdf.text "Date: #{Date.today.strftime("%B %d, %Y")}"
    end
    @pdf.move_down 20

    # Grades Table
    grades_by_course = student.grades.includes(examination: :course)
                             .group_by { |grade| grade.examination.course }

    grades_table_data = [ [ "Course", "Examinations", "Grades", "Date" ] ]

    grades_by_course.each do |course, grades|
      grades.each_with_index do |grade, i|
        grades_table_data << [
          i == 0 ? course.name : "",
          grade.examination.title,
          grade.value.to_s,
          grade.effective_date.strftime("%B %d, %Y")
        ]
      end
    end

    @pdf.table(grades_table_data, header: true, width: @pdf.bounds.width) do |t|
      t.header = true
      t.row(0).style(background_color: "CCCCCC")
      t.columns(0..3).align = :left
      t.column_widths = {
        0 => @pdf.bounds.width * 0.25,
        1 => @pdf.bounds.width * 0.35,
        2 => @pdf.bounds.width * 0.15,
        3 => @pdf.bounds.width * 0.25
      }
    end

    # Calculate and display averages
    @pdf.move_down 20
    @pdf.text "Course Averages:", style: :bold
    @pdf.move_down 10

    grades_by_course.each do |course, grades|
      average = (grades.sum(&:value) / grades.count).round(2)
      @pdf.text "#{course.name}: #{average}"
    end

    overall_average = (grades_by_course.values.flatten.sum(&:value) /
                      grades_by_course.values.flatten.count).round(2)
    @pdf.move_down 10
    @pdf.text "Overall Average: #{overall_average}", style: :bold
  end
end
