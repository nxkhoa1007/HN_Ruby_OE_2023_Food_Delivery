import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
  }

  close(e) {
    e.preventDefault();
    const modal = $("#close-btn").data("modal-id");
    $("#" + modal).empty();
  }
}
