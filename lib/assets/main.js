export function init(ctx, payload) {
  ctx.importCSS("styles.css");

  ctx.root.innerHTML = html`
    <form>
      <h3>Fetch rows from a Google Sheet</h3>

      <div class="col">
        <label for="spreadsheet_id">Spreadsheet ID</label>
        <input
          type="text"
          size="45"
          name="spreadsheet_id"
          id="spreadsheet_id"
          autocomplete="off"
        />
      </div>

      <div class="col">
        <label for="range">Range</label>
        <input type="text" name="range" id="range" autocomplete="off" />
      </div>

      <div class="col">
        <label for="result_variable">Assign result to</label>
        <input
          type="text"
          name="result_variable"
          id="result_variable"
          autocomplete="off"
        />
      </div>

      <h4>Output format</h4>
      <div class="row radio-group">
        <div class="row">
          <input type="radio" name="output_format" id="rows" value="rows" checked />
          <label for="rows">Rows</label>
        </div>
        <div class="row">
          <input type="radio" name="output_format" id="kv" value="kv" />
          <label for="kv">Key-value pairs</label>
        </div>
        <div class="row">
          <input type="radio" name="output_format" id="kv_atoms" value="kv_atoms" />
          <label for="kv_atoms">Key-value pairs with atom keys</label>
        </div>
      </div>

      <h4>Authorization (choose one)</h4>
      <div class="col">
        <label for="key_env">Google API key</label>
        <input
          class="choose-env"
          role="button"
          type="text"
          size="30"
          name="key_env"
          id="key_env"
          autocomplete="off"
          data-suggested-env="GOOGLE_SHEETS_API_KEY"
          readonly
        />
      </div>

      <div class="col">
        <label for="google_application_credentials_env"
          >Google application credentials</label
        >
        <input
          class="clickable choose-env"
          role="button"
          type="text"
          size="30"
          name="google_application_credentials_env"
          id="google_application_credentials_env"
          autocomplete="off"
          data-suggested-env="GOOGLE_APPLICATION_CREDENTIALS"
          readonly
        />
      </div>
    </form>
  `;

  const form = ctx.root.querySelector("form");

  function dispatchFormChange() {
    form.dispatchEvent(new Event("change"));
  }

  /**
   * Delegate secret selection to Livebook and update the provided input
   * element with the name of the selected secret.
   */
  function selectSecret(inputElement) {
    const suggestedEnv = inputElement.getAttribute("data-suggested-env");
    ctx.selectSecret((v) => {
      inputElement.value = v;
      dispatchFormChange();
    }, suggestedEnv);
  }

  form.addEventListener("change", () => {
    const formData = new FormData(form);

    ctx.pushEvent("form-updated", Object.fromEntries(formData));
  });

  /** Register input controls for secret selection (authorization env vars). */
  ctx.root.querySelectorAll("input.choose-env").forEach((inputElement) => {
    inputElement.addEventListener("click", (e) => selectSecret(e.target));
    inputElement.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        selectSecret(inputElement);
      } else if (e.key === "Backspace" || e.key === "Delete") {
        inputElement.value = "";
        dispatchFormChange();
      }
    });
  });

  /** Prepopulate inputs with cached values provided by the server. */
  Object.entries(payload).forEach(([input_name, input_value]) => {
    ctx.root.querySelectorAll(`input[name="${input_name}"]`).forEach((input) => {
      if (input.type === "radio" && input.value === input_value) {
        input.checked = true;
      } else if (input.type === "text") {
        input.value = input_value;
      }
    });
  });
}

/** Just for HTML syntax highlighting in template tags. */
const html = String.raw;
