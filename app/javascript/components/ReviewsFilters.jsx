import React, {useContext, useEffect, useState} from 'react';
import {client} from '../utils/ApiClient';
import {Space, Card, Select, Rate} from 'antd';
import {ReviewsContext} from "./ReviewsContext";

const {Option} = Select;

export default function ReviewsFilters() {
  const {filterBrand, filterTaste, filterColor, filterSmokiness} = useContext(ReviewsContext);
  const [brands, setBrands] = useState([]);

  useEffect(() => {
    client('/api/v1/whiskey_brands')
      .then(response => {
        setBrands(response);
      })
      .catch(error => console.log(error.message));
  }, []);

  return (
    <Space direction="vertical">
      <Card title="Filters" style={{width: 300}}>
        <Select
          mode="multiple"
          style={{width: '100%'}}
          placeholder="Select a brand"
          optionFilterProp="children"
          onChange={filterBrand}
        >
          {brands.map((brand) => (<Option key={brand.id} value={brand.id}>{brand.name}</Option>))}
        </Select>

        <label className="star-label">Taste</label>
        <Rate onChange={filterTaste}></Rate>

        <label className="star-label">Color</label>
        <Rate onChange={filterColor}></Rate>

        <label className="star-label">Smokiness</label>
        <Rate onChange={filterSmokiness}></Rate>
      </Card>
    </Space>
  )
}