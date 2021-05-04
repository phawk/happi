import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  connect() {
    this.editor = this.element.querySelector("trix-editor").editor;
  }

  snippet(event) {
    this.editor.setSelectedRange([0, 0]);
    this.editor.insertHTML(event.target.dataset.html);
  }
}
