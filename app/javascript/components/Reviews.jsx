import React from "react";
import { Link } from "react-router-dom";
import { Layout, Menu, Button } from 'antd';
import { UserOutlined } from '@ant-design/icons';

const { Header, Content, Footer } = Layout;
const { SubMenu } = Menu;

export default () => (
    <Layout>
        <Header style={{ position: 'fixed', zIndex: 1, width: '100%' }}>
          <Menu theme="dark" mode="horizontal" defaultSelectedKeys={['2']}>
            <Menu.Item key="1">nav 1</Menu.Item>
            <Menu.Item key="2">nav 2</Menu.Item>
            <Menu.Item key="3">nav 3</Menu.Item>
            <SubMenu
              title={
                <span className="submenu-title-wrapper">
                  <SettingOutlined />
                  user email
                </span>
              }
            >
              <Menu.ItemGroup>
                <Menu.Item key="setting:1">
                  <Link
                      to="/reviews"
                      className="btn btn-lg custom-button"
                      role="button"
                  >
                        Change user
                  </Link>
                  <UserOutlined />
                </Menu.Item>
              </Menu.ItemGroup>
            </SubMenu>
          </Menu>
        </Header>
        <Content className="site-layout" style={{ padding: '0 50px', marginTop: 64 }}>
          <div className="site-layout-background" style={{ padding: 24, minHeight: 380 }}>
            Content
          </div>
          <hr className="my-4" />
          <Button type="primary" style={{ marginLeft: 8 }}>
            <Link
                to="/reviews"
                className="btn btn-lg custom-button"
                role="button"
            >
                  View Whiskeys
            </Link>
          </Button>
        </Content>
        <Footer style={{ textAlign: 'center' }}>Made by Johanna Salazar</Footer>
      </Layout>,


    <div id="container">
      <div className="vw-100 vh-100 primary-color d-flex align-items-center justify-content-center">
        <div className="jumbotron jumbotron-fluid bg-transparent">
          <div className="container secondary-color">
            <h1 className="display-4">Grade your Whiskeys</h1>
            <p className="lead">
              Enter your user info to save your grades.
            </p>

          </div>
        </div>
      </div>
    </div>
);