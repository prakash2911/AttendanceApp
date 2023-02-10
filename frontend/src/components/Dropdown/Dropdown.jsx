import React, { useState, useEffect, useRef } from "react";
import { CSSTransition } from "react-transition-group";
import { FaChevronRight, FaChevronLeft } from "react-icons/fa";
import { IoFilter } from "react-icons/io5";

import { equalsIgnoreCase, isObject } from "../../utils";

import "./dropdown.css";

export default function Dropdown({
  values,
  onChange,
  currentValues,
  setIsOpen,
}) {
  const [activeMenu, setActiveMenu] = useState("main");
  const [menuHeight, setMenuHeight] = useState(null);
  const dropdownRef = useRef(null);

  const keys = values && isObject(values) ? Object.keys(values) : values;

  useEffect(() => {
    setMenuHeight(dropdownRef.current?.firstChild.offsetHeight);
  }, []);

  function calcHeight(el) {
    const height = el.offsetHeight;
    setMenuHeight(height);
  }

  function DropdownItem(props) {
    return (
      <a
        href="#"
        className="menu-item"
        onClick={() => {
          props.goToMenu ? setActiveMenu(props.goToMenu) : null;
          props.onClick ? props.onClick() : null;
        }}
        key={props.index}
      >
        <span className="icon-button">{props.leftIcon}</span>
        {props.children}
        <span className="icon-right">{props.rightIcon}</span>
      </a>
    );
  }

  return (
    <div className="dropdown" style={{ height: menuHeight }} ref={dropdownRef}>
      <CSSTransition
        in={activeMenu === "main"}
        timeout={500}
        classNames="menu-primary"
        unmountOnExit
        onEnter={calcHeight}
      >
        <div className="menu">
          {keys &&
            keys.map((item, index) => {
              if (Array.isArray(values[item]))
                if (
                  equalsIgnoreCase(item, "floor") &&
                  equalsIgnoreCase(currentValues.block, "all")
                )
                  return null;
                else
                  return (
                    <DropdownItem
                      leftIcon={<IoFilter />}
                      rightIcon={<FaChevronRight />}
                      goToMenu={item}
                      index={index}
                    >
                      {item}
                    </DropdownItem>
                  );
              else
                return (
                  <DropdownItem
                    index={index}
                    goToMenu="main"
                    onClick={() => {
                      onChange({ key: item, value: null });
                      setIsOpen(false);
                    }}
                  >
                    {item}
                  </DropdownItem>
                );
            })}
        </div>
      </CSSTransition>

      {keys &&
        keys.map((item, index) => {
          return (
            <CSSTransition
              in={activeMenu === item}
              timeout={500}
              classNames="menu-secondary"
              unmountOnExit
              onEnter={calcHeight}
            >
              <div className="menu" key={index}>
                <DropdownItem goToMenu="main" leftIcon={<FaChevronLeft />}>
                  <h2>{item}</h2>
                </DropdownItem>
                {Array.isArray(values[item]) &&
                  !equalsIgnoreCase(item, "floor") &&
                  values[item].map((innerItem, innerIndex) => {
                    return (
                      <DropdownItem
                        index={innerIndex}
                        leftIcon={<IoFilter />}
                        goToMenu="main"
                        onClick={() => {
                          onChange({ key: item, value: innerItem });
                          setIsOpen(false);
                        }}
                      >
                        {innerItem}
                      </DropdownItem>
                    );
                  })}
                {Array.isArray(values[item]) &&
                  equalsIgnoreCase(item, "floor") &&
                  !equalsIgnoreCase(currentValues.block, "All") &&
                  values[item][
                    values.block.indexOf(currentValues.block) - 1
                  ].map((innerItem, innerIndex) => {
                    return (
                      <DropdownItem
                        index={innerIndex}
                        leftIcon={<IoFilter />}
                        goToMenu="main"
                        onClick={() => {
                          onChange({ key: item, value: innerItem });
                          setIsOpen(false);
                        }}
                      >
                        {innerItem}
                      </DropdownItem>
                    );
                  })}
              </div>
            </CSSTransition>
          );
        })}
    </div>
  );
}
