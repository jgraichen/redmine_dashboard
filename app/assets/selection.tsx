//

import { createContext, createRef, RefObject } from "preact";
import { useContext, useEffect, useState } from "preact/hooks";
import { useEventListener } from "./events";

const CTX = createContext<SelectionManager>(null);

type Ref = RefObject<Element>;
type Listener = (selected: boolean) => void;

class SelectionManager {
  elements = new Array<{ ref: Ref; listener: Listener }>();

  register(ref: Ref, listener: Listener) {
    this.elements.push({ ref, listener });
  }

  unregister(ref: Ref) {
    const index = this.elements.findIndex((reg) => reg.ref === ref);
    if (index >= 0) this.elements.splice(index, 1);
  }
}

export function SelectionProvider(props) {
  const ref = createRef();
  const [manager] = useState(new SelectionManager());

  useEventListener(document, "click", (e: MouseEvent) => {
    if (!(e.target instanceof Element)) return;
    const el = e.target as Element;

    for (const registration of manager.elements) {
      const current = registration.ref.current;
      if (!current) continue;

      if (current == el || current.contains(el)) {
        registration.listener(true);
      } else {
        registration.listener(false);
      }
    }
  });

  return (
    <CTX.Provider ref={ref} value={manager}>
      {props.children}
    </CTX.Provider>
  );
}

type Options = {
  onChange: (value: boolean) => void;
};

export function useSelectionManager(ref: RefObject<Element>, opts: Options) {
  const manager = useContext(CTX);
  const [state, setState] = useState(false);

  const listener = (value: boolean) => {
    if (value != state) {
      opts.onChange?.call(undefined, value);
      setState(value);
    }
  };

  useEffect(() => {
    manager.register(ref, listener);
    return () => manager.unregister(ref);
  }, [ref]);

  return state;
}
