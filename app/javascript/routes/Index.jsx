import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Home from "../components/Home";
import Reviews from "../components/Reviews";
import NewReview from "../components/NewReview";

export default (
  <Router>
    <Switch>
      <Route path="/" exact component={Home} />
      <Route path="/reviews" exact component={Reviews} />
      <Route path="/review" exact component={NewReview} />
    </Switch>
  </Router>
);