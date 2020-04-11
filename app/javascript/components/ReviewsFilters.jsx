import React, {useContext, useEffect, useState} from 'react';
import {client} from '../utils/ApiClient';
import {Space, Card, Select, Rate} from 'antd';
import {ReviewsContext} from "./ReviewsContext";

const {Option} = Select;

export default function ReviewsFilters() {
  const {search} = useContext(ReviewsContext);
  const [brands, setBrands] = useState([]);
  const [_, setFilters] = useState({});

  useEffect(() => {
    client('/api/v1/whiskey_brands')
      .then(response => {
        setBrands(response);
      })
      .catch(error => console.log(error.message));
  }, []);

  function onBrandChange(brand) {
    setFilters(currentFilters => {
      const searchParams = {...currentFilters, brand};
      search(searchParams);
      return searchParams;
    });
  }

  function onTasteChange(taste_grade) {
    setFilters(currentFilters => {
      const searchParams = {...currentFilters, taste_grade};
      search(searchParams);
      return searchParams;
    });
  }

  function onColorChange(color_grade) {
    setFilters(currentFilters => {
      const searchParams = {...currentFilters, color_grade};
      search(searchParams);
      return searchParams;
    });
  }

  function onSmokinessChange(smokiness_grade) {
    setFilters(currentFilters => {
      const searchParams = {...currentFilters, smokiness_grade};
      search(searchParams);
      return searchParams;
    });
  }

  return (
    <Space direction="vertical">
      <Card title="Filters" style={{width: 300}}>
        <Select
          mode="multiple"
          style={{width: '100%'}}
          placeholder="Select a brand"
          optionFilterProp="children"
          onChange={onBrandChange}
        >
          {brands.map((brand) => (<Option key={brand.id} value={brand.id}>{brand.name}</Option>))}
        </Select>

        <label className="star-label">Taste</label>
        <Rate onChange={onTasteChange}></Rate>

        <label className="star-label">Color</label>
        <Rate onChange={onColorChange}></Rate>

        <label className="star-label">Smokiness</label>
        <Rate onChange={onSmokinessChange}></Rate>
      </Card>
    </Space>
  )
}