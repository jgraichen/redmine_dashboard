//

import { Inputs, useEffect } from "preact/hooks";

export function useEventListener(
  target: Window | Document,
  type: string,
  listener: EventListenerOrEventListenerObject,
  options?: boolean | AddEventListenerOptions,
  deps?: Inputs
) {
  useEffect(() => {
    target.addEventListener(type, listener, options);

    return () => {
      target.removeEventListener(type, listener);
    };
  }, deps);
}
