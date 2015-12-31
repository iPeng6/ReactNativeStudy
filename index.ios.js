/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
} = React;
import App from './App';

var ReactNativeStudy = React.createClass({
  render: function() {
    return (
      <App />
    );
  }
});


AppRegistry.registerComponent('ReactNativeStudy', () => ReactNativeStudy);
