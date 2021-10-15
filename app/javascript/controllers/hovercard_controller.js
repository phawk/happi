import Controller from "./application_controller";

/*
 * Usage
 * =====
 *
 * add the following to the hoverable area
 * data-controller="hovercard"
 * data-hovercard-url-value="some-url" # Also make sure to `render layout: false`
 * data-action="mouseenter->hovercard#show mouseleave->hovercard#hide"
 *
 * Targets (add to your hovercard that gets loaded in):
 * data-hovercard-target="card"
 *
 */
export default class extends Controller {
  static targets = ["card"];
  static values = { url: String };

  show() {
    if (this.hasCardTarget) {
      this.cardTarget.classList.remove("hidden");
    } else {
      fetch(this.urlValue)
        .then((r) => r.text())
        .then((html) => {
          const fragment = document
            .createRange()
            .createContextualFragment(html);

          this.element.appendChild(fragment);
        });
    }
  }

  hide() {
    if (this.hasCardTarget) {
      this.cardTarget.classList.add("hidden");
    }
  }

  disconnect() {
    if (this.hasCardTarget) {
      this.cardTarget.remove();
    }
  }
}
