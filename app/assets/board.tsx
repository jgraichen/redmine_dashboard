//

import { DndProvider } from "react-dnd";
import { HTML5Backend } from "react-dnd-html5-backend";

import { Column } from "./column";
import { useState } from "preact/hooks";
import { SelectionProvider } from "./selection";

export function Board(props) {
  const [state, setState] = useState(props);

  const onDrop = async (cardIndex, newColumnIndex, oldColumnIndex) => {
    const oldColumn = state.columns[oldColumnIndex];
    const newColumn = state.columns[newColumnIndex];

    const card = oldColumn.issues[cardIndex];
    console.log(oldColumn, cardIndex, card);

    const response = await window.fetch(props.board.url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ issue: card.id, column: newColumn.id }),
    });

    if(!response.ok) {
      return;
    }

    setState(await response.json());
  };

  return (
    <DndProvider backend={HTML5Backend}>
      <SelectionProvider>
        <header>
          <h2>{state.board.name}</h2>
        </header>
        <section>
          {state.columns.map((column, index) => (
            <Column key={column.id} index={index} onDrop={onDrop} {...column} />
          ))}
        </section>
      </SelectionProvider>
    </DndProvider>
  );
}
