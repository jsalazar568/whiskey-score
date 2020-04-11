import React, {useCallback, useEffect, useMemo, useState} from "react";
import {client} from "../utils/ApiClient";

export const ReviewsContext = React.createContext({
  reviews: [],
  search() {
  }
});

//AÑADIR AQUI LOS FILTROS

export function ReviewsContextProvider({children, userId}) {
  const [reviews, setReviews] = useState([]);

  const search = useCallback((value = {}) => {
    const searchParams = Object.entries({user_id: userId, ...value}).map((pair) => pair.join('=')).join('&');
    const url = `/api/v1/reviews?${searchParams}`;

    client(url)
      .then(response => {
        console.log(response);
        setReviews(response);
      })
      .catch(error => console.log(error.message));

  },[userId]);

  useEffect(() => {
    search()
  }, [userId]);

  return <ReviewsContext.Provider value={{search, reviews}}>{children}</ReviewsContext.Provider>
}