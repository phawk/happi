import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = ["slugField"];

  change(event) {
    const { value } = event.target;
    this.slugFieldTarget.value = value.toLowerCase().replace(/[^a-z0-9]/, "");
  }
}
