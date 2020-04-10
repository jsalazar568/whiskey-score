import React from "react";
import { Link } from "react-router-dom";
import { Button } from "antd";

export default () => (
  <div className="justify-content-center">
    <Button type="primary" style={{ marginLeft: 8 }}>
      <Link
          to="/whiskeys"
          className="btn btn-lg custom-button"
          role="button"
      >
            View Whiskeys
      </Link>
    </Button>
  </div>
);