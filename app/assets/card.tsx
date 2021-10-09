//

import { useRef } from "preact/hooks";
import classNames from "classnames";

import { useDrag } from "react-dnd";
import { useSelectionManager } from "./selection";
import { createRef } from "preact";

type CardProps = {
  id: number;
  url: string;
  subject: string;
  tracker?: string;
  assignee?: string;
  category?: string;
  version?: string;
  priority?: string;

  index: number;
  columnIndex: number;
};

export function Card(props: CardProps) {
  const issueLink = useRef<HTMLAnchorElement>(null);

  const box = createRef();
  const isSelected = useSelectionManager(box, {
    onChange: (value) => {
      if(value) issueLink.current?.focus()
    }
  });

  const [{ isDragging }, drag] = useDrag(
    () => ({
      type: "CARD",
      item: { columnIndex: props.columnIndex, cardIndex: props.index },
      collect: (monitor) => ({
        isDragging: !!monitor.isDragging(),
      }),
    }),
    [props.columnIndex, props.index]
  );

  const properties = [];

  if (props.tracker) {
    properties.push(["tracker", props.tracker]);
  }

  if (props.priority) {
    properties.push(["priority", props.priority]);
  }

  if (props.assignee) {
    properties.push(["assignee", props.assignee]);
  }

  if (props.category) {
    properties.push(["category", props.category]);
  }

  if (props.version) {
    properties.push(["version", props.version]);
  }

  const cls = classNames({
    "rdb-card": true,
    "rdb-selected": isSelected,
    "rdb-dragging": isDragging,
  });

  return (
    <div id={`issue-${props.id}`} className={cls} ref={drag}>
      <div ref={box}>
        <div className="rdb-card-subject">
          <a ref={issueLink} href={props.url}>
            #{props.id}
          </a>
          <span>
            {props.subject} ({props.columnIndex},{props.index})
          </span>
        </div>
        <ul className="rdb-card-props">
          {properties.map(([name, value]) => (
            <li key={name} className={`rdb-card-props-${name}`}>
              <a dangerouslySetInnerHTML={{ __html: value }} />
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
