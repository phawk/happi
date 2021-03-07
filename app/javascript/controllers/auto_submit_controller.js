import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  submit() {
    this.element.submit();
  }
}
