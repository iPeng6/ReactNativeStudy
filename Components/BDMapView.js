'use strict'

import React, {
  View,
  requireNativeComponent
} from 'react-native';

var BDMapManager = React.NativeModules.BDMapManager;//注意不要以RCT开头

var MapView = React.createClass ({
  getInitialState(){
    return {
      data:[]
    }
  },
  propTypes : {
    ...View.propTypes,
    style: View.propTypes.style,
    locationChange: React.PropTypes.func,
  },
  componentDidMount:function(){
    BDMapManager.asynReactTag&&BDMapManager.asynReactTag(React.findNodeHandle(this.refs.bdmap));
  },
  _onChange(event){
     this.props.onLocationChange&&this.props.onLocationChange(event.nativeEvent.data);
  },
  render() {
    return (<RCTBDMap ref='bdmap' {...this.props} onChange={this._onChange}/>);
  }

});

var RCTBDMap = requireNativeComponent('RCTBDMap', MapView, {
  nativeOnly: {onChange: true}
});

module.exports = MapView;