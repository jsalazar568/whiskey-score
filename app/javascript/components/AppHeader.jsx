import React from 'react';
import {UserOutlined} from '@ant-design/icons';
import {Layout, Menu} from 'antd';
import {Link} from "react-router-dom";

const {Header} = Layout;
const {SubMenu} = Menu;

export default function AppHeader({name}) {
  return (
    <Header>
      <div className="logo">Grade your Whiskeys</div>
      <Menu theme="dark" mode="horizontal" className="review-menu">
        <SubMenu
          title={
            <span className="submenu-title-wrapper" style={{'textTransform': 'lowercase'}}>
              {name}
              <UserOutlined style={{'marginLeft': '5px'}}/>
            </span>
          }
        >
          <Menu.ItemGroup>
            <Menu.Item key="setting:1">
              <Link
                to="/"
                className="btn btn-lg custom-button"
                role="button"
              >
                Change user
              </Link>
            </Menu.Item>
          </Menu.ItemGroup>
        </SubMenu>
      </Menu>
    </Header>
  )
}