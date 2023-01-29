import React, { useState } from "react";
import { useEffect } from "react";
import "./table.css";

const Table = (props) => {
  const [dataShow, setDataShow] = useState();
  const [pages, setPages] = useState(1);
  const [range, setRange] = useState([]);
  const [currPage, setCurrPage] = useState(0);

  const selectPage = (page) => {
    const start = Number(props.limit) * page;
    const end = start + Number(props.limit);

    setDataShow(props.bodyData.slice(start, end));

    setCurrPage(page);
  };

  const initTable = () => {
    let initDataShow =
      props.limit && props.bodyData
        ? props.bodyData.slice(0, Number(props.limit))
        : props.bodyData;
    setDataShow(initDataShow);

    if (props.limit !== undefined) {
      let page = Math.floor(props.bodyData.length / Number(props.limit));
      let tempPages =
        props.bodyData.length % Number(props.limit) === 0 ? page : page + 1;
      setPages(tempPages);
      setRange([...Array(tempPages).keys()]);
    }
  };

  useEffect(() => {
    initTable();
  }, []);

  useEffect(() => {
    initTable();
  }, [props.bodyData]);

  return (
    <div>
      <div className="table-wrapper">
        <table>
          {props.headData && props.renderHead ? (
            <thead>
              <tr>
                {props.headData.map((item, index) =>
                  props.renderHead(item, index)
                )}
              </tr>
            </thead>
          ) : null}
          {props.bodyData && props.renderBody ? (
            <tbody>
              {dataShow?.map((item, index) => props.renderBody(item, index))}
            </tbody>
          ) : null}
        </table>
      </div>
      {pages > 1 ? (
        <div className="table__pagination">
          {range?.map((item, index) => (
            <div
              key={index}
              className={`table__pagination-item ${
                currPage === index ? "active" : ""
              }`}
              onClick={() => selectPage(index)}
            >
              {item + 1}
            </div>
          ))}
        </div>
      ) : null}
    </div>
  );
};

export default Table;
