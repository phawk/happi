import ApplicationController from "./application_controller";
import { useClickOutside } from "stimulus-use";

/*
 * Usage
 * =====
 *
 * add data-controller="toggle" to common ancestor
 *
 * Action:
 * data-action="toggle#toggle"
 *
 * Targets:
 * data-toggle-target="toggleable" data-css-class="class-to-toggle"
 *
 */
export default class extends ApplicationController {
  static targets = ["toggleable"];

  connect() {
    useClickOutside(this);
  }

  toggle(e) {
    e.preventDefault();

    this.toggleableTargets.forEach((target) => {
      target.classList.toggle(target.dataset.cssClass);
    });
  }

  clickOutside(event) {
    if (this.data.get("clickOutside") === "add") {
      this.toggleableTargets.forEach((target) => {
        target.classList.add(target.dataset.cssClass);
      });
    } else if (this.data.get("clickOutside") === "remove") {
      this.toggleableTargets.forEach((target) => {
        target.classList.remove(target.dataset.cssClass);
      });
    }
  }
}
