import React, {useEffect, useState} from 'react';
import { Redirect } from "react-router-dom";
import AppHeader from "./AppHeader";
import {Layout, Button, Form, Select, Rate, Input} from 'antd';
import {client} from "../utils/ApiClient";
import {buildURLQueryString} from "../utils/urlParams";

const {Content, Footer} = Layout;

export default function NewReview(props) {
  const [form] = Form.useForm();
  const [redirectTo, setRedirect] = useState(null);
  const [brands, setBrands] = useState([]);
  const [whiskeys, setWhiskeys] = useState([]);

  useEffect(() => {
    client('/api/v1/whiskey_brands')
      .then(response => {
        setBrands(response);
      })
      .catch(error => console.log(error.message));
  }, []);

  if (props.location.state === undefined) {
    return (<Redirect to={{pathname: "/"}}/>);
  }
  const {id, name} = props.location.state;

  if (redirectTo !== null) {
    return (<Redirect to={{pathname: redirectTo, state: { id: id, name: name }}}/>);
  }

  const getWhiskeys = (whiskey_brand_id) => {
    const url = buildURLQueryString('/api/v1/whiskeys', {user_id: id, whiskey_brand_id});

    client(url)
      .then(response => {
        setWhiskeys(response);
      })
      .catch(error => console.log(error.message));
  }

  const onFinish = values => {
    client("/api/v1/reviews", { data: {user_id: id, ...values} })
      .then(response => {
        setRedirect("/reviews");
      })
      .catch(error => console.log(error.message));
  };

  return (
    <Layout>
      <AppHeader name={name}/>

      <Content className="site-layout">
        <div className="site-layout-background">
          <Form
            layout='vertical'
            form={form}
            onFinish={onFinish}
          >
            <Form.Item
              name="whiskey_brand_id"
              label="Select a whiskey brand to review"
              rules={[
                {
                  required: true,
                  message: 'Please select a brand',
                },
              ]}
            >
              <Select
                style={{width: '100%'}}
                placeholder="Select a brand"
                optionFilterProp="children"
                showSearch="true"
                onChange={getWhiskeys}
              >
                {brands.map((brand) => (<Option key={brand.id} value={brand.id}>{brand.name}</Option>))}
              </Select>
            </Form.Item>
            <Form.Item
              name="whiskey_id"
              label="Select a whiskey"
              rules={[
                {
                  required: true,
                  message: 'Please select a whiskey',
                },
              ]}
            >
              <Select
                style={{width: '100%'}}
                placeholder="Select a whiskey to review"
                optionFilterProp="children"
              >
                {whiskeys.map((whiskey) => (<Option key={whiskey.id} value={whiskey.id}>{whiskey.label}</Option>))}
              </Select>
            </Form.Item>
            <Form.Item
              name="title"
              label="Add a title to your whiskey"
            >
              <Input placeholder="Title" />
            </Form.Item>
            <Form.Item
              name="description"
              label="Add a description to your whiskey"
            >
              <Input placeholder="Description" />
            </Form.Item>
            <Form.Item
              name="taste_grade"
              label="Add a taste grade"
            >
              <Rate />
            </Form.Item>
            <Form.Item
              name="color_grade"
              label="Add a color grade to your whiskey"
            >
              <Rate />
            </Form.Item>
            <Form.Item
              name="smokiness_grade"
              label="Add a smokiness"
            >
              <Rate />
            </Form.Item>

            <Form.Item>
              <Button type="primary" htmlType="submit">Save</Button>
            </Form.Item>
          </Form>
        </div>
      </Content>
      <Footer style={{textAlign: 'center'}}>Powered by 🥃</Footer>
    </Layout>
  )
}