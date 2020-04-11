import React, {useContext} from 'react';
import {ReviewsContext} from "./ReviewsContext";
import { Input } from 'antd';

const { Search } = Input;

export default function ReviewsTextFilter () {
  const {search} = useContext(ReviewsContext);

  function onChange(text_search) {
    search({text_search});
  }

  return (
    <div>
      <Search
        placeholder="input search text"
        enterButton="Search"
        size="large"
        onSearch={onChange}
      />
    </div>
  )

}