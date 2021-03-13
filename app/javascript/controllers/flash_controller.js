import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  connect() {
    setTimeout(() => {
      this.hideAlert();
    }, 3000);
  }

  dismiss(event) {
    event.preventDefault();
    event.stopPropagation();

    this.hideAlert();
  }

  hideAlert() {
    this.element.style.display = "none";
  }
}
