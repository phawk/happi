import ApplicationController from "./application_controller";

/*
 * Usage
 * =====
 *
 * add data-controller="slugify" to common ancestor or form tag
 *
 * Action (add to the title input):
 * data-action="slugify#change"
 *
 * Target (add to the slug input):
 * data-slugify-target="slugField"
 *
 */
export default class extends ApplicationController {
  static targets = ["slugField"];

  change(event) {
    const { value } = event.target;
    this.slugFieldTarget.value = value.toLowerCase().replace(/[^a-z0-9]/, "");
  }
}
