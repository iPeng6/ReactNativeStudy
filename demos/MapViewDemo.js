'use strict'

import React, {
  StyleSheet,
  Text,
  View,
  ListView,
  MapView,
  Dimensions,
  PixelRatio,
  requireNativeComponent,
  NativeModules,
} from 'react-native';

var screenDim = Dimensions.get('window');//获取屏幕宽高信息
var LocationTool = NativeModules.LocationTool;//引用本地地理编码工具

import BDMapView from '../Components/BDMapView';

type MapRegion = {
  latitude: number,
  longitude: number,
  latitudeDelta?: number,
  longitudeDelta?: number,
};

type Annotations = Array<{
  animateDrop?: boolean,
  latitude: number,
  longitude: number,
  title?: string,
  subtitle?: string,
  hasLeftCallout?: boolean,
  hasRightCallout?: boolean,
  onLeftCalloutPress?: Function,
  onRightCalloutPress?: Function,
  tintColor?: number | string,
  image?: any,
  id?: string,
  view?: ReactElement,
  leftCalloutView?: ReactElement,
  rightCalloutView?: ReactElement,
  detailCalloutView?: ReactElement,
}>;

type MapViewExampleState = {
  mapRegion?: MapRegion,
  annotations?: Annotations,
};

var MapViewDemo = React.createClass({
  getInitialState(): MapViewExampleState {
    return {

    };
  },
  render() {
    return (
      <View style={styles.container}>
        <MapView
          style={styles.map}
          onRegionChange={this._onRegionChange}
          onRegionChangeComplete={this._onRegionChangeComplete}
          region={this.state.mapRegion}
          annotations={this.state.annotations}
          showsUserLocation = {true}
        />
        <LocationList ref='LocationList' style={styles.list1}/>

        <BDMapView style={styles.map} onLocationChange={(data)=>{
          this.refs.LocationList2&&this.refs.LocationList2.setState({
            data:data||[{}]
          });
        }}/>
        <LocationList2 ref='LocationList2' style={styles.list2}/>

      </View>
    );
  },

  _onRegionChange(region) {
    //调用本地模块 做地理反编码
    LocationTool.reverceGeocoder(region,(error, events) => {
      if (error) {
        console.error(error);
      } else {

        this.refs.LocationList&&this.refs.LocationList.setState({
          data:events||[{}]
        });
      }
    });
  },

  _onRegionChangeComplete(region){

  },
});

var LocationList = React.createClass({
  getInitialState:function(){  
    return {
      data:[],
    };
  },

  dataSource:new ListView.DataSource({
    rowHasChanged:(row1,row2)=> row1 !== row2
  }),

  render:function(){
    return(
      <ListView {...this.props}
        dataSource={this.dataSource.cloneWithRows(this.state.data)}
        renderRow={this.renderRow}
      />
    );
  },

  renderRow:function(rowData:string,sectionID:number,rowID:number){

    return (
      <View style={styles.locRow}>
        <Text style={styles.locRowText}>{rowData.country}·{rowData.locality}·{rowData.subLocality}</Text>
        <Text style={styles.locRowText}>{rowData.name} 附近</Text>
      </View>
    );
  },

});

var LocationList2 = React.createClass({
  getInitialState:function(){  
    return {
      data:[],
    };
  },

  dataSource:new ListView.DataSource({
    rowHasChanged:(row1,row2)=> row1 !== row2
  }),
  render:function(){
    return(
      <ListView {...this.props}
        dataSource={this.dataSource.cloneWithRows(this.state.data)}
        renderRow={this.renderRow}
      />
    );
  },

  renderRow:function(rowData:string,sectionID:number,rowID:number){

    return(
      <View style={styles.locRow}>
        <Text style={styles.locRowText}>{rowData.city}·{rowData.name}</Text>
        <Text style={styles.locRowText}>{rowData.address}</Text>
      </View>
    );
  },

});

var styles = StyleSheet.create({
  container:{
    flex:1,
    justifyContent:'flex-start',
    alignItems:'stretch'
  },
  map: {
    flex:2,
    height: screenDim.height*1/5,
    margin: 5,
    borderWidth: 1,
    borderColor: '#333333',
  },

  list1:{
    flex:1,
  },
  list2:{
    flex:3,
  },
  locRow:{
    borderBottomWidth: 1 / PixelRatio.get(),
    borderBottomColor: '#CDCDCD',
  },
  locRowText:{
    padding:5,
  }
});

export default MapViewDemo;
