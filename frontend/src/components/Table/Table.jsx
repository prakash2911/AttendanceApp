import React, { useState, useEffect } from "react";
import { IoIosCloseCircle } from "react-icons/io";
import { FaFilter } from "react-icons/fa";

import Dropdown from "../Dropdown/Dropdown";
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
  addElement,
}) => {
  const [dataShow, setDataShow] = useState();
  const [pages, setPages] = useState(1);
  const [range, setRange] = useState([]);
  const [currPage, setCurrPage] = useState(0);

  const [currentFilters, setCurrentFilters] = useState(defaultFilters);

  const filterTypes = Object.keys(defaultFilters);
  const [isFilterDropdownOpen, setIsFilterDropdownOpen] = useState(false);

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
  };

  useEffect(() => {
    initTable();
  }, []);

  useEffect(() => {
    initTable();
  }, [bodyData, limit, currentFilters]);

  useEffect(() => {
    setCurrentFilters(defaultFilters);
  }, [filters]);

  return (
    <>
      <div className="table-header">
        <div className="title-pagination-wrapper">
          <div className="table-title">{title}</div>
          <div className="table__pagination">
            <div className="filter-icon-wrapper">
              <div
                className="filter-icon"
                onClick={() => setIsFilterDropdownOpen(!isFilterDropdownOpen)}
              >
                <FaFilter size={22} />
              </div>
              {isFilterDropdownOpen && (
                <Dropdown
                  values={filters}
                  onChange={({ key, value }) => {
                    if (key === "block")
                      setCurrentFilters((old) => ({
                        ...old,
                        [key]: value,
                        floor: "All",
                      }));
                    else setCurrentFilters((old) => ({ ...old, [key]: value }));
                  }}
                  currentValues={currentFilters}
                  setIsOpen={setIsFilterDropdownOpen}
                />
              )}
            </div>
            {pages > 1 ? (
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
            ) : null}
          </div>
        </div>
        <div className="filter-tag-wrapper">
          {filterTypes.map((item, index) => {
            if (currentFilters[item] !== "All")
              return (
                <div className="filter-tag" key={index}>
                  {equalsIgnoreCase(item, "floor") ? "Floor " : null}
                  {currentFilters[item]}
                  <div
                    className="filter-tag-close-icon"
                    onClick={() => {
                      if (item === "block")
                        setCurrentFilters((old) => ({
                          ...old,
                          [item]: "All",
                          floor: "All",
                        }));
                      else
                        setCurrentFilters((old) => ({ ...old, [item]: "All" }));
                    }}
                  >
                    <IoIosCloseCircle size={16} />
                  </div>
                </div>
              );
          })}
        </div>
      </div>
      {dataShow && dataShow.length === 0 ? (
        <div className="no-data-text-container">
          <div className="no-data-text">No data to be shown</div>
        </div>
      ) : (
        <div className="table-wrapper">
          <table>
            {headData && renderHead ? (
              <thead>
                <tr>
                  {headData.map((item, index) => renderHead(item, index))}
                </tr>
              </thead>
            ) : null}
            {bodyData && renderBody ? (
              <tbody>
                {dataShow?.map((item, index) => renderBody(item, index))}
              </tbody>
            ) : null}
          </table>
        </div>
      )}

      {addElement && addElement}
    </>
  );
};

export default Table;
