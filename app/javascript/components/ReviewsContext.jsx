import React, {useCallback, useEffect, useMemo, useState} from "react";
import {client} from "../utils/ApiClient";
import {buildURLQueryString} from "../utils/urlParams";

export const ReviewsContext = React.createContext({
  reviews: [],
  filters: {},
  pagination: {}
});

const pageSize = 15;

export function ReviewsContextProvider({children, userId}) {
  const [reviews, setReviews] = useState([]);
  const [filters, setFilters] = useState({});
  const [page, setPage] = useState(1);
  const [total, setTotal] = useState(0);

  useEffect(() => {
    const url = buildURLQueryString('/api/v1/reviews', {user_id: userId, page: page, per_page: pageSize, ...filters});

    client(url)
      .then(({reviews, total}) => {
        setTotal(total);
        setReviews(reviews);
      })
      .catch(error => console.log(error.message));

  }, [userId, filters, page]);

  const onChangePagination = useCallback((page) => {
    setPage(page);
  }, []);

  const filterBrand = useCallback((brands = []) => {
    setFilters({...filters, whiskey_brand_ids: brands});
  }, [filters]);

  const filterTaste = useCallback((taste_grade = null) => {
    setFilters({...filters, taste_grade});
  }, [filters]);

  const filterColor = useCallback((color_grade = null) => {
    setFilters({...filters, color_grade});
  }, [filters]);

  const filterSmokiness = useCallback((smokiness_grade = null) => {
    setFilters({...filters, smokiness_grade});
  }, [filters]);

  const filterText = useCallback((text_search = null) => {
    setFilters({...filters, text_search});
  }, [filters]);


  return <ReviewsContext.Provider value={{
    reviews,
    filterBrand,
    filterTaste,
    filterColor,
    filterSmokiness,
    filterText,
    onChangePagination,
    pagination: {
      pageSize,
      page,
      total
    }
  }}>{children}</ReviewsContext.Provider>
}