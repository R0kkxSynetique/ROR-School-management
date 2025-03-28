import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["courseSelection"]
  
  connect() {
    this.toggleCourseSelection()
  }
  
  toggleCourseSelection() {
    const conditionType = this.element.querySelector('select[name*="[condition_type]"]').value
    const courseSelection = this.courseSelectionTarget
    
    if (conditionType === 'overall_average') {
      courseSelection.classList.add('hidden')
    } else {
      courseSelection.classList.remove('hidden')
    }
  }
  
  conditionTypeChanged(event) {
    this.toggleCourseSelection()
  }
}