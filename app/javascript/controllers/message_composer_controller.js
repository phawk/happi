import ApplicationController from "./application_controller";

/*
 * Usage
 * =====
 *
 * add this to the messages form:
 * data-controller="message-composer"
 *
 * Action (add this to your snippets):
 * data-action="click->message-composer#snippet" data-html="content..."
 *
 */
export default class extends ApplicationController {
  connect() {
    this.editor = this.element.querySelector("trix-editor").editor;
  }

  snippet(event) {
    this.editor.setSelectedRange([0, 0]);
    this.editor.insertHTML(event.target.dataset.html);
  }
}
