import ApplicationController from "./application_controller";
import { useMutation } from "stimulus-use";

export default class extends ApplicationController {
  static targets = ["list", "emptyMessage"];
  static classes = ["hide"];

  connect() {
    useMutation(this, {
      element: this.listTarget,
      childList: true,
    });
  }

  mutate(entries) {
    for (const mutation of entries) {
      if (mutation.type === "childList") {
        console.log("A child node has been added or removed.");
        if (this.listTarget.children.length > 0) {
          // hide empty state
          this.emptyMessageTarget.classList.add(this.hideClass);
        } else {
          // show empty state
          this.emptyMessageTarget.classList.remove(this.hideClass);
        }
      } else if (mutation.target === this.element) {
        console.log("The root element of this controller was modified.");
      } else if (mutation.type === "attributes") {
        console.log(
          "The " + mutation.attributeName + " attribute was modified."
        );
      }
    }
  }
}
