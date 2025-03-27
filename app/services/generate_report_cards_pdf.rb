require "prawn"
require "prawn/table"

class GenerateReportCardsPdf
  def initialize(students)
    @students = students
    @pdf = Prawn::Document.new(
      page_size: "A4",
      info: {
        Title: "Student Report Card",
        Author: "School Management System",
        Subject: "Student Grades and Promotion Status",
        Keywords: "grades, report card, promotion",
        CreationDate: Time.now
      }
    )

    # Set UTF-8 encoding and use MesloLGS NF font
    @pdf.font_families.update(
      "MesloLGS" => {
        normal: Rails.root.join("app/assets/fonts/MesloLGS NF Regular.ttf").to_s,
        bold: Rails.root.join("app/assets/fonts/MesloLGS NF Bold.ttf").to_s,
        italic: Rails.root.join("app/assets/fonts/MesloLGS NF Italic.ttf").to_s,
        bold_italic: Rails.root.join("app/assets/fonts/MesloLGS NF Bold Italic.ttf").to_s
      }
    )
    @pdf.font "MesloLGS"
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
    # Header with decorative line
    @pdf.stroke_color "333333"
    @pdf.line_width 2
    @pdf.stroke_horizontal_rule
    @pdf.move_down 20

    @pdf.font_size(24) do
      @pdf.text "Student Report Card", align: :center, style: :bold
    end
    @pdf.move_down 20

    # Student Information Box
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
      @pdf.stroke_color "CCCCCC"
      @pdf.line_width 1
      @pdf.stroke_rectangle [0, @pdf.cursor], @pdf.bounds.width, 80

      @pdf.pad(15) do
        @pdf.font_size(14) do
          @pdf.text "Student Information", style: :bold
          @pdf.move_down 5
          @pdf.font_size(12) do
            @pdf.text "Name: #{student.firstname} #{student.lastname}"
            @pdf.text "ID: #{student.username}"
            @pdf.text "Date: #{Date.today.strftime("%B %d, %Y")}"
          end
        end
      end
    end
    @pdf.move_down 30

    # Grades Section
    @pdf.font_size(16) do
      @pdf.text "Academic Performance", style: :bold
      @pdf.stroke_color "333333"
      @pdf.line_width 1
      @pdf.stroke_horizontal_rule
    end
    @pdf.move_down 15

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
      t.row(0).style(background_color: "333333", text_color: "FFFFFF", font_style: :bold)
      t.columns(0..3).align = :left
      t.column_widths = {
        0 => @pdf.bounds.width * 0.25,
        1 => @pdf.bounds.width * 0.35,
        2 => @pdf.bounds.width * 0.15,
        3 => @pdf.bounds.width * 0.25
      }
      t.row(0).padding = 8
      t.cells.padding = 5
      t.cells.borders = [:bottom]
      t.row(0).borders = [:bottom]
    end

    # Averages Section
    @pdf.move_down 20
    @pdf.font_size(14) do
      @pdf.text "Course Averages", style: :bold
      @pdf.move_down 10

      grades_by_course.each do |course, grades|
        average = (grades.sum(&:value) / grades.count).round(2)
        @pdf.text "#{course.name}: #{average}", style: :italic
      end

      overall_average = (grades_by_course.values.flatten.sum(&:value) /
                        grades_by_course.values.flatten.count).round(2)
      @pdf.move_down 10
      @pdf.text "Overall Average: #{overall_average}", style: :bold_italic
    end

    # Promotion Conditions Section
    @pdf.move_down 30
    @pdf.font_size(16) do
      @pdf.text "Promotion Status", style: :bold
      @pdf.stroke_color "333333"
      @pdf.line_width 1
      @pdf.stroke_horizontal_rule
    end
    @pdf.move_down 15

    current_section = student.school_classes.active.first&.section

    if current_section.nil?
      @pdf.font_size(12) do
        @pdf.text "No active section found for this student.", style: :italic
      end
    else
      promotion_assessments = current_section.promotion_asserments
                                          .where(active: true)
                                          .where("effective_date <= ?", Date.today)
                                          .order(effective_date: :desc)

      if promotion_assessments.empty?
        @pdf.font_size(12) do
          @pdf.text "No active promotion assessments found for #{current_section.name}.", style: :italic
        end
      else
        promotion_assessments.each do |assessment|
          # Assessment Header Box
          @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
            @pdf.stroke_color "CCCCCC"
            @pdf.line_width 1
            @pdf.stroke_rectangle [0, @pdf.cursor], @pdf.bounds.width, 60

            @pdf.pad(15) do
              @pdf.font_size(14) do
                @pdf.text assessment.name, style: :bold
                @pdf.text "Effective Date: #{assessment.effective_date.strftime("%B %d, %Y")}", style: :italic
              end
            end
          end
          @pdf.move_down 15

          # Conditions Table
          conditions_data = [["Type", "Required", "Min Grade", "Weight", "Status"]]

          assessment.promotion_conditions.each do |condition|
            condition_met = condition.evaluate_student(student)
            status_color = condition_met ? "00FF00" : "FF0000"
            status_text = condition_met ? "✓ Met" : "✗ Not Met"

            conditions_data << [
              condition.condition_type.titleize,
              condition.required? ? "Yes" : "No",
              condition.minimum_grade.to_s,
              condition.weight.to_s,
              status_text
            ]
          end

          @pdf.table(conditions_data, header: true, width: @pdf.bounds.width) do |t|
            t.header = true
            t.row(0).style(background_color: "333333", text_color: "FFFFFF", font_style: :bold)
            t.columns(0..4).align = :left
            t.column_widths = {
              0 => @pdf.bounds.width * 0.25,
              1 => @pdf.bounds.width * 0.15,
              2 => @pdf.bounds.width * 0.15,
              3 => @pdf.bounds.width * 0.15,
              4 => @pdf.bounds.width * 0.30
            }
            t.row(0).padding = 8
            t.cells.padding = 5
            t.cells.borders = [:bottom]
            t.row(0).borders = [:bottom]
          end

          # Course Details
          assessment.promotion_conditions.each do |condition|
            next unless condition.courses.any?

            @pdf.move_down 10
            @pdf.font_size(12) do
              @pdf.text "Courses for #{condition.condition_type.titleize} Condition:", style: :bold
              courses_data = [["Course Name", "Current Average"]]

              condition.courses.each do |course|
                course_grades = student.grades.joins(:examination)
                                     .where(examinations: { course_id: course.id })
                average = course_grades.any? ? (course_grades.sum(&:value) / course_grades.count).round(2) : "N/A"
                courses_data << [course.name, average.to_s]
              end

              @pdf.table(courses_data, header: true, width: @pdf.bounds.width) do |t|
                t.header = true
                t.row(0).style(background_color: "EEEEEE", font_style: :bold)
                t.columns(0..1).align = :left
                t.column_widths = {
                  0 => @pdf.bounds.width * 0.7,
                  1 => @pdf.bounds.width * 0.3
                }
                t.cells.padding = 5
                t.cells.borders = [:bottom]
                t.row(0).borders = [:bottom]
              end
            end
          end

          # Overall Status Box
          overall_status = assessment.evaluate_student(student)
          overall_status_color = overall_status ? "00FF00" : "FF0000"
          overall_status_text = overall_status ? "✓ Eligible for Promotion" : "✗ Not Eligible for Promotion"

          @pdf.move_down 15
          @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
            @pdf.stroke_color overall_status_color
            @pdf.line_width 2
            @pdf.stroke_rectangle [0, @pdf.cursor], @pdf.bounds.width, 40

            @pdf.pad(10) do
              @pdf.font_size(14) do
                @pdf.text "Overall Status:", style: :bold
                @pdf.text overall_status_text, color: overall_status_color, style: :bold
              end
            end
          end
          @pdf.move_down 20
        end
      end
    end

    # Footer
    @pdf.move_down 20
    @pdf.stroke_color "333333"
    @pdf.line_width 2
    @pdf.stroke_horizontal_rule
    @pdf.move_down 10
    @pdf.font_size(10) do
      @pdf.text "Generated on #{Time.current.strftime("%B %d, %Y at %I:%M %p")}", align: :center, style: :italic
    end
  end
end
