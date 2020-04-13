import React, {useState, useEffect} from "react";
import {client} from '../utils/ApiClient';
import {Form, Layout, Input, Button, Menu, Table,} from 'antd';

import {Link} from "react-router-dom";

const {Header,Content, Footer} = Layout;


export default function AdminBrands() {
  const [form] = Form.useForm();
  const [, forceUpdate] = useState();
  const [brands, setBrands] = useState([]);

  const columns = [
    {
      title: 'Whiskey Brand',
      dataIndex: 'name',
      key: 'name',
    },
    {
      title: 'Action',
      key: 'action',
      render: (text, record) => (
        <Link
          className="btn btn-lg custom-button"
          role="button"
          to={{
            pathname: `/admin/${record.id}/whiskeys`
          }}
        >
          Add Whiskey
        </Link>
      )
    }
  ];

  // To disable submit button at the beginning.
  useEffect(() => {
    forceUpdate({});
  }, []);

  const onFinish = values => {
    console.log('Finish:', values);
    client("/api/v1/whiskey_brands", { data: values })
      .then(response => {
        setBrands([response, ...brands]);
      })
      .catch(error => console.log(error.message));
  };

  useEffect(() => {
    client('/api/v1/whiskey_brands')
      .then(response => {
        setBrands(response);
      })
      .catch(error => console.log(error.message));
  }, []);

  return (
    <Layout>
      <Header>
        <div className="logo">Grade your Whiskeys</div>
        <Menu theme="dark" mode="horizontal"/>
      </Header>

      <Content className="site-layout">
        <div className="site-layout-background">

          <Form form={form} name="horizontal_login" layout="inline" onFinish={onFinish}>
            <Form.Item
              name="name"
              rules={[{ required: true, message: 'Please enter the name of the new whiskey brand' }]}
            >
              <Input placeholder="Name of the new whiskey brand" />
            </Form.Item>
            <Form.Item shouldUpdate={true}>
              {() => (
                <Button
                  type="primary"
                  htmlType="submit"
                  disabled={
                    !form.isFieldsTouched(true) ||
                    form.getFieldsError().filter(({ errors }) => errors.length).length
                  }
                >
                  Save
                </Button>
              )}
            </Form.Item>
          </Form>

          <Table dataSource={brands} columns={columns} rowKey="id" pagination={false}/>
        </div>
      </Content>
      <Footer style={{textAlign: 'center'}}>Powered by 🥃</Footer>
    </Layout>
  )
}