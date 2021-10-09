//

import classNames from "classnames";
import { useDrop } from "react-dnd";

import { Card } from "./card";

type ColumnProps = {
  id: number;
  title: string;
  issues: Array<any>;

  index: number;
  onDrop: (id: number, newColumn: number, oldColumn: number) => void;
};

export function Column(props: ColumnProps) {
  const [{ isOver, isActive, isInvalid }, drop] = useDrop(() => ({
    accept: "CARD",
    drop: (item) => {
      props.onDrop(item.cardIndex, props.index, item.columnIndex);
    },
    canDrop: (item: { cardIndex: number; columnIndex: number }) => {
      if (item.columnIndex === props.index) return false;
      return true;
    },
    collect: (monitor) => ({
      isInvalid: monitor.getItem() !== null && !monitor.canDrop(),
      isActive: monitor.canDrop(),
      isOver: monitor.isOver(),
    }),
  }));

  const cls = classNames({
    "rdb-column": true,
    "rdb-drop-over": isOver,
    "rdb-drop-active": isActive,
    "rdb-drop-invalid": isInvalid,
  });

  return (
    <div className={cls}>
      <header className="rdb-column-header">
        <h3>{props.title}</h3>
        <span>{props.issues.length}</span>
      </header>
      <div className="rdb-column-body" ref={drop}>
        {props.issues.map((issue, index) => (
          <Card
            key={issue.id}
            index={index}
            columnIndex={props.index}
            {...issue}
          />
        ))}
      </div>
    </div>
  );
}
