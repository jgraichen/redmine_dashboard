//

export function ready(cb: Function) {
  if (document.readyState !== "loading") {
    setTimeout(cb, 0);
  } else {
    document.addEventListener("DOMContentLoaded", (_) => cb());
  }
}
