import ApplicationController from "./application_controller";
import { Turbo } from "@hotwired/turbo-rails";

/*
 * Usage
 * =====
 *
 * add data-controller="navigation-select" to common ancestor
 *
 * Action:
 * data-action="change->navigation-select#change"
 *
 */
export default class extends ApplicationController {
  change(event) {
    const url = event.target.value;
    Turbo.visit(url);
  }
}
