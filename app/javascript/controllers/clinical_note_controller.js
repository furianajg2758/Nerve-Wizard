import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "note"]

  toggle(event) {
    event.preventDefault()
    
    // 1. Toggle the visibility of the note container
    this.containerTarget.classList.toggle("d-none")

    // 2. Update the button text based on visibility
    // event.currentTarget refers to the button that was clicked
    if (this.containerTarget.classList.contains("d-none")) {
      event.currentTarget.innerText = "Generate Clinical Note"
    } else {
      event.currentTarget.innerText = "Hide Clinical Note"
    }
  }

  copy(event) {
    const text = this.noteTarget.innerText
    
    navigator.clipboard.writeText(text).then(() => {
      // Temporary UI feedback on the button itself
      const originalText = event.currentTarget.innerText
      event.currentTarget.innerText = "Copied!"
      
      // Revert the button text after 2 seconds
      setTimeout(() => {
        event.currentTarget.innerText = originalText
      }, 2000)
    })
  }
}