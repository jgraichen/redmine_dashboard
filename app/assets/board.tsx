//

import { Component } from "preact";
import { DndProvider } from "react-dnd";
import { HTML5Backend } from "react-dnd-html5-backend";

import { Column } from "./column";
import { SelectionProvider } from "./selection";

type Props = {
  board: {
    name: string;
    url: string;
  };
  columns: Array<any>;
};

export class Board extends Component<Props, Props> {
  constructor(props) {
    super();
    this.state = props;
  }

  onDrop = async (cardIndex, newColumnIndex, oldColumnIndex) => {
    const oldColumn = this.state.columns[oldColumnIndex];
    const newColumn = this.state.columns[newColumnIndex];
    const card = oldColumn.issues.slice(cardIndex, 1)[0];

    const response = await window.fetch(this.props.board.url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ issue: card.id, column: newColumn.id }),
    });

    if (!response.ok) {
      return;
    }

    const json = await response.json();
    this.setState(json);
  };

  render() {
    return (
      <DndProvider backend={HTML5Backend}>
        <SelectionProvider>
          <header>
            <h2>{this.state.board.name}</h2>
          </header>
          <ol>
            {this.state.columns.map((column, index) => (
              <Column
                key={column.id}
                index={index}
                onDrop={this.onDrop}
                {...column}
              />
            ))}
          </ol>
        </SelectionProvider>
      </DndProvider>
    );
  }
}
