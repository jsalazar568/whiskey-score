import React, {useState, useEffect} from "react";
import {useParams} from 'react-router-dom';
import {client} from '../utils/ApiClient';
import {Form, Input, Button, Layout, Menu, Table, Row, Col,} from 'antd';

const {Header,Content, Footer} = Layout;


export default function AdminWhiskeys() {
  const [form] = Form.useForm();
  const [, forceUpdate] = useState();
  const [whiskeys, setWhiskeys] = useState([]);
  const {brand_id} = useParams();

  const columns = [
    {
      title: 'Whiskey',
      dataIndex: 'label',
      key: 'label',
    }
  ];

  // To disable submit button at the beginning.
  useEffect(() => {
    forceUpdate({});
  }, []);

  const onFinish = values => {
    client(`/api/v1/whiskeys`, { data: {whiskey_brand_id: brand_id, ...values} })
      .then(response => {
        setWhiskeys([response, ...whiskeys]);
      })
      .catch(error => console.log(error.message));
  };

  useEffect(() => {
    client(`/api/v1/whiskeys?whiskey_brand_id=${brand_id}`)
      .then(response => {
        setWhiskeys(response);
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
          <Row>
            <Col span={24}>
              <Form form={form} name="horizontal_login" layout="inline" onFinish={onFinish}>
                <Form.Item
                  name="label"
                  rules={[{ required: true, message: 'Please enter the label of the new whiskey' }]}
                >
                  <Input placeholder="Label of the new whiskey" />
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
            </Col>
          </Row>
          <Row>
            <Col span={24}>

              <Table dataSource={whiskeys} columns={columns} rowKey="id" pagination={false}/>
            </Col>
          </Row>
        </div>
      </Content>
      <Footer style={{textAlign: 'center'}}>Powered by 🥃</Footer>
    </Layout>
  )
}