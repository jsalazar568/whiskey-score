import React from "react";
import '../../assets/stylesheets/homepage.scss'
import { client } from '../utils/ApiClient';
import { Layout, Menu, Button, Input, Form } from 'antd';

const { Header, Content, Footer } = Layout;

const Home = () => {
  const [form] = Form.useForm();

  const onFinish = values => {
    console.log('Received values of form: ', values);
    client("/api/v1/users", { data: values })
      .then(response => this.props.history.push(`/reviews`))
      .catch(error => console.log(error.message));
  };

  return (
    <div>
      <Layout>
        <Header>
          <div className="logo">Grade your Whiskeys</div>
          <Menu theme="dark" mode="horizontal" defaultSelectedKeys={['2']}/>
        </Header>
        <Content className="site-layout">
          <div className="site-layout-background">
            <Form
              layout='vertical'
              form={form}
              onFinish={onFinish}
              className="email-form"
            >
              <Form.Item
                name="email"
                label="Enter your email to start:"
                rules={[
                  {
                    type: 'email',
                    message: 'The input is not valid E-mail!',
                  },
                  {
                    required: true,
                    message: 'Please input your E-mail!',
                  },
                ]}
              >
                <Input placeholder="Email" />
              </Form.Item>
              <Form.Item
                name="name"
                label="How you want us to call you?"
              >
                <Input placeholder="Name" />
              </Form.Item>
              <Form.Item>
                <Button type="primary" htmlType="submit" className="email-button">View Whiskeys</Button>
              </Form.Item>
            </Form>
          </div>
        </Content>
        <Footer style={{ textAlign: 'center' }}>Powered by 🥃</Footer>
      </Layout>,
    </div>
  )
}
export default Home;