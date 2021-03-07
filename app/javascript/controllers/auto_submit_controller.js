import ApplicationController from "./application_controller";
import Rails from "@rails/ujs";

export default class extends ApplicationController {
  submit() {
    Rails.fire(this.element, "submit");
  }
}
