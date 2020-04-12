import React, {useContext} from 'react';
import {ReviewsContext} from "./ReviewsContext";
import { Input } from 'antd';

const { Search } = Input;

export default function ReviewsTextFilter () {
  const {filterText} = useContext(ReviewsContext);

  return (
    <div>
      <Search
        placeholder="input search text"
        enterButton="Search"
        size="large"
        onSearch={filterText}
      />
    </div>
  )

}