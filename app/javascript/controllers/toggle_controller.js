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
 * Optionally add a group to perform toggle on subset of targets...
 * data-toggle-group="menu"
 *
 * Targets:
 * data-toggle-target="toggleable" data-css-class="class-to-toggle"
 * Optionally add a group when using group with action...
 * data-toggle-group="menu"
 *
 */
export default class extends ApplicationController {
  static targets = ["toggleable"];

  connect() {
    useClickOutside(this);
  }

  toggle(e) {
    e.preventDefault();

    const { toggleGroup } = e.currentTarget.dataset;

    this.toggleableTargets.forEach((target) => {
      if (toggleGroup && target.dataset.toggleGroup === toggleGroup) {
        target.classList.toggle(target.dataset.cssClass);
      } else if (!toggleGroup) {
        target.classList.toggle(target.dataset.cssClass);
      }
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
