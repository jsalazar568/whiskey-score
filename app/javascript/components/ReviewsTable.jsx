import React, {useContext} from 'react';
import {Rate, Table} from 'antd';
import {ReviewsContext} from "./ReviewsContext";

const { Column } = Table;


export default function ReviewsTable () {
  const {reviews} = useContext(ReviewsContext);

  const columns = [
    {
      title: 'Whiskey',
      dataIndex: 'title',
      key: 'title',
    },
    {
      title: 'Taste Grade',
      key: 'taste_grade',
      dataIndex: 'taste_grade',
      render: (grade) => (
        <Rate disabled defaultValue={grade} />
      ),
    },
    {
      title: 'Color Grade',
      key: 'color_grade',
      dataIndex: 'color_grade',
      render: (grade) => (
        <Rate disabled defaultValue={grade} />
      ),
    },
    {
      title: 'Smokiness Grade',
      key: 'smokiness_grade',
      dataIndex: 'smokiness_grade',
      render: (grade) => (
        <Rate disabled defaultValue={grade} />
      ),
    }
  ];

  return (
    <Table dataSource={reviews} columns={columns} rowKey="id" />
  )
}