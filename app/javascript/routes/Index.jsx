import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Home from "../components/Home";
import Reviews from "../components/Reviews";
import NewReview from "../components/NewReview";
import AdminBrands from "../components/AdminBrands";
import AdminWhiskeys from "../components/AdminWhiskeys";

export default (
  <Router>
    <Switch>
      <Route path="/" exact component={Home} />
      <Route path="/reviews" exact component={Reviews} />
      <Route path="/review" exact component={NewReview} />
      <Route path="/admin/:brand_id/whiskeys" component={AdminWhiskeys} />
      <Route path="/admin" component={AdminBrands} />
    </Switch>
  </Router>
);