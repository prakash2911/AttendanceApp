import React, { useState } from "react";
import { useEffect } from "react";
import Filter from "../Filter";
import { equalsIgnoreCase } from "../../utils";

import "./table.css";

const Table = ({
  limit,
  title,
  headData,
  renderHead,
  bodyData,
  renderBody,
  filters,
  defaultFilters,
  filterTypes,
  addElement,
}) => {
  const [dataShow, setDataShow] = useState();
  const [pages, setPages] = useState(1);
  const [range, setRange] = useState([]);
  const [currPage, setCurrPage] = useState(0);

  const [currentFilters, setCurrentFilters] = useState(defaultFilters);

  const filterData = (data) => {
    if (!filters) return data;
    let temp = data.filter((element) => {
      for (let filterType of filterTypes) {
        if (
          equalsIgnoreCase(currentFilters[filterType], element[filterType]) ||
          equalsIgnoreCase(currentFilters[filterType], "All")
        )
          continue;
        return false;
      }
      return true;
    });

    return temp;
  };

  const selectPage = (page) => {
    const start = Number(limit) * page;
    const end = start + Number(limit);

    setDataShow(filterData(bodyData.slice(start, end)));

    setCurrPage(page);
  };

  const initTable = () => {
    let initDataShow =
      limit && bodyData ? bodyData.slice(0, Number(limit)) : bodyData;
    setDataShow(filterData(initDataShow));

    if (limit !== undefined) {
      let page = Math.floor(bodyData.length / Number(limit));
      let tempPages = bodyData.length % Number(limit) === 0 ? page : page + 1;
      setPages(tempPages);
      setRange([...Array(tempPages).keys()]);
    }
    setCurrPage(0);
    setCurrentFilters(defaultFilters);
  };

  useEffect(() => {
    initTable();
  }, []);

  useEffect(() => {
    initTable();
  }, [bodyData, limit, filters]);

  return (
    <>
      <div className="table-header">
        <div className="table-title">{title}</div>
        {pages > 1 ? (
          <div className="table__pagination">
            <div className="table__pagination-wrapper">
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
          </div>
        ) : null}
      </div>
      <div className="table-wrapper">
        <table>
          {headData && renderHead ? (
            <thead>
              <tr>{headData.map((item, index) => renderHead(item, index))}</tr>
            </thead>
          ) : null}
          {bodyData && renderBody ? (
            <tbody>
              {dataShow?.map((item, index) => renderBody(item, index))}
            </tbody>
          ) : null}
        </table>
      </div>
      {addElement && addElement}
    </>
  );
};

export default Table;
