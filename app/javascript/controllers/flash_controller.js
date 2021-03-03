import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  dismiss(event) {
    event.preventDefault();
    event.stopPropagation();

    this.element.style.display = "none";
  }
}
