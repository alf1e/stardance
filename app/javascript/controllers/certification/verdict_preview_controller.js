import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "modal",
    "verdict",
    "feedbackBlock",
    "feedback",
    "noFeedback",
    "confirmBtn",
  ];

  intercept(event) {
    if (this._confirmed) {
      this._confirmed = false;
      return;
    }

    event.preventDefault();
    this._buildPreview(event.target);
    this._open();
  }

  confirm() {
    this._confirmed = true;
    this._close();

    const form = this.element.querySelector("form.review-form");
    form?.requestSubmit();
  }

  cancel() {
    this._close();
  }

  _buildPreview(form) {
    const checked = form.querySelector("input[name$='[status]']:checked");
    const verdict = checked?.value ?? null;

    if (this.hasVerdictTarget) {
      const labels = { approved: "Approve ✓", returned: "Reject ✗" };
      this.verdictTarget.textContent = verdict
        ? (labels[verdict] ?? verdict)
        : "—";
      this.verdictTarget.dataset.verdict = verdict ?? "";
    }

    const feedbackEl = form.querySelector("textarea[name$='[feedback]']");
    const text = feedbackEl?.value.trim() ?? "";

    if (
      this.hasFeedbackTarget &&
      this.hasFeedbackBlockTarget &&
      this.hasNoFeedbackTarget
    ) {
      if (text) {
        this.feedbackTarget.textContent = text;
        this.feedbackBlockTarget.hidden = false;
        this.noFeedbackTarget.hidden = true;
      } else {
        this.feedbackBlockTarget.hidden = true;
        this.noFeedbackTarget.hidden = false;
      }
    }
  }

  _open() {
    if (!this.hasModalTarget) return;

    const dialog = this.modalTarget;
    if (typeof dialog.showModal === "function") {
      dialog.showModal();
    } else {
      dialog.setAttribute("open", "");
    }

    this._onCancel = (e) => {
      e.preventDefault();
      this.cancel();
    };
    this._onBackdropClick = (e) => {
      const rect = dialog.getBoundingClientRect();
      const outside =
        e.clientX < rect.left ||
        e.clientX > rect.right ||
        e.clientY < rect.top ||
        e.clientY > rect.bottom;
      if (outside) this.cancel();
    };
    dialog.addEventListener("cancel", this._onCancel);
    dialog.addEventListener("click", this._onBackdropClick);

    if (this.hasConfirmBtnTarget) this.confirmBtnTarget.focus();
  }

  _close() {
    if (!this.hasModalTarget) return;

    const dialog = this.modalTarget;
    dialog.removeEventListener("cancel", this._onCancel);
    dialog.removeEventListener("click", this._onBackdropClick);

    if (typeof dialog.close === "function") {
      dialog.close();
    } else {
      dialog.removeAttribute("open");
    }
  }
}
