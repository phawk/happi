import ApplicationController from "./application_controller";

/*
 * Usage
 * =====
 *
 * add data-controller="auto-submit" to your <form> element
 *
 * Action (add this to a <select> field):
 * data-action="change->auto-submit#submit"
 *
 */
export default class extends ApplicationController {
  submit() {
    this.element.requestSubmit()
  }
}
