import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["title", "content", "titleError", "contentError"]
  connect() {
    console.log("conneced to ARTICLE")
  }



  create(event){
    let isValid = true;

    if(this.titleTarget.value.trim() === ""){
      isValid = false;
      this.titleErrorTarget.classList.remove("hidden")
    } else {
      this.titleErrorTarget.classList.add("hidden")
    }

    if(this.contentTarget.value.trim() === ""){
      isValid = false;
      this.contentErrorTarget.classList.remove("hidden")
    } else {
      this.contentErrorTarget.classList.add("hidden")
    }
    if(!isValid){
      event.preventDefault()
    }
  }

}
