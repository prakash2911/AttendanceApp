import React, { useState, useEffect, useRef } from "react";
import { CSSTransition } from "react-transition-group";
import { FaChevronRight, FaChevronLeft } from "react-icons/fa";
import { IoFilter } from "react-icons/io5";

import { isObject } from "../../utils";

import "./dropdown.css";

export default function Dropdown({ values, onChange, setIsOpen }) {
  const [activeMenu, setActiveMenu] = useState("main");
  const [menuHeight, setMenuHeight] = useState(null);
  const dropdownRef = useRef(null);

  const keys = values && Object.keys(values);

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
        onClick={
          props.goToMenu ? () => setActiveMenu(props.goToMenu) : props.onClick
        }
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
              else return <DropdownItem index={index}>{item}</DropdownItem>;
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
                {values[item].map((innerItem, innerIndex) => {
                  return (
                    <DropdownItem
                      index={innerIndex}
                      leftIcon={<IoFilter />}
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
