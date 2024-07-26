export function init(ctx, payload) {
  ctx.importCSS("styles.css");

  ctx.root.innerHTML = html`
    <form>
      <header>
        <h3>Fetch rows from a Google Sheet</h3>
        <hr />
      </header>

      <div class="col">
        <label for="spreadsheet_id">Spreadsheet ID</label>
        <input type="text" size="45" id="spreadsheet_id" autocomplete="off" />
      </div>

      <div class="col">
        <label for="range">Range</label>
        <input type="text" id="range" autocomplete="off" />
      </div>

      <div class="col">
        <label for="result_variable">Assign result to</label>
        <input type="text" id="result_variable" autocomplete="off" />
      </div>

      <div class="col">
        <label for="key_env">Google API key</label>
        <input
          class="choose-env"
          role="button"
          type="text"
          size="25"
          id="key_env"
          autocomplete="off"
          data-suggested-env="GOOGLE_SHEETS_API_KEY"
          readonly
        />
      </div>

      <div class="col">
        <label for="oauth_token_env">Google OAuth token</label>
        <input
          class="clickable choose-env"
          role="button"
          type="text"
          size="25"
          id="oauth_token_env"
          autocomplete="off"
          data-suggested-env="GOOGLE_SHEETS_OAUTH_TOKEN"
          readonly
        />
      </div>
    </form>
  `;

  /**
   * Delegate secret selection to Livebook and update the provided input
   * element with the name of the selected secret.
   */
  function selectSecret(inputElement) {
    const suggestedEnv = inputElement.getAttribute("data-suggested-env");
    ctx.selectSecret((v) => {
      inputElement.value = v;
      handleInputChange(inputElement);
    }, suggestedEnv);
  }

  /** Send the current value of an input element to the server. */
  function handleInputChange(inputElement) {
    ctx.pushEvent("input-updated", {
      input_id: inputElement.id,
      value: inputElement.value,
    });
  }

  /** Register input controls for secret selection (API key and OAuth token). */
  ctx.root.querySelectorAll("input.choose-env").forEach((inputElement) => {
    inputElement.addEventListener("click", (e) => selectSecret(e.target));
    inputElement.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        selectSecret(inputElement);
      } else if (e.key === "Backspace" || e.key === "Delete") {
        inputElement.value = "";
        handleInputChange(inputElement);
      }
    });
  });

  /** Register listeners for `input` events on all input elements. */
  ctx.root.querySelectorAll("input").forEach((inputElement) => {
    inputElement.addEventListener("input", () => {
      handleInputChange(inputElement);
    });
  });

  /** Prepopulate inputs with cached values provided by the server. */
  Object.entries(payload.html_inputs).forEach(([input_id, value]) => {
    const inputElement = ctx.root.querySelector("#" + input_id);
    inputElement.value = value;
    handleInputChange(inputElement);
  });
}

/** Just for HTML syntax highlighting in template tags. */
const html = String.raw;
