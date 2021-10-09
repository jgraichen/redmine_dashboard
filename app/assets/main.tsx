//

import "preact/debug";
import { render } from "preact";

import { ready } from "./util";
import { Board } from "./board";

ready(() => {
  const script: HTMLElement = document.querySelector(
    "#rdb script[data-rdb-board]"
  );
  if (!script) return;

  const el = script.parentElement;
  const data = JSON.parse(script.textContent);

  render(<Board {...data} />, el);
});
