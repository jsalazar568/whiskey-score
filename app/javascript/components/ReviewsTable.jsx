import React, {useContext} from 'react';
import { Table } from 'antd';
import {ReviewsContext} from "./ReviewsContext";

const { Column } = Table;


export default function ReviewsTable () {
  const {reviews} = useContext(ReviewsContext);

  return (
    <Table dataSource={reviews} rowKey="id">
      <Column title="Whiskey" dataIndex="title" key="title" />
      <Column title="Taste Grade" dataIndex="taste_grade" key="taste_grade" />
      <Column title="Color Grade" dataIndex="color_grade" key="color_grade" />
      <Column title="Smokiness Grade" dataIndex="smokiness_grade" key="smokiness_grade" />
    </Table>
  )
}