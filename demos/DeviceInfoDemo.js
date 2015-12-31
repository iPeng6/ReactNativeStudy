'use strict'

import React, {
  StyleSheet,
  Text,
  View,
  ListView,
  PixelRatio,
} from 'react-native';

var { RNDeviceInfo } = require('react-native').NativeModules;

var TableView = React.createClass({
  getInitialState: function(){
    var ds = new ListView.DataSource({rowHasChanged:(row1,row2)=> row1 !== row2});
    return {
      dataSource: ds.cloneWithRows(this._genRows()),
    };
  },

  render: function() {
    return (
      <View style={styles.container}>
        <ListView 
          dataSource={this.state.dataSource} 
          renderRow={this._renderRow}
          renderHeader={this._renderHeader}
          style={styles.table}
        />
      </View>
    );
  },

  _renderHeader:()=> {
    return (
      <View style={styles.header}>
        <Text>设备信息</Text>
      </View>
    );
  },

  _renderRow:function(rowData:string,sectionID:number,rowID:number){
    var devInfoMethod=['getUniqueID'];

    return (
      <View style={styles.row}>
        <View style={styles.rowTitle}>
          <Text style={styles.rowText}>
            {'['+rowID+'] '+rowData.name}
          </Text>
          <Text>
            {rowData.cnname}
          </Text>
        </View>
        
        <Text style={styles.rowText}>
          {RNDeviceInfo[rowData.name]}
        </Text>
      </View>
      );
  },

  _genRows:function():Array<string>{
    var rows=[
      {name:'systemName',cnname:'设备运行的系统'},
      {name:'systemVersion',cnname:'当前系统的版本'},
      {name:'model',cnname:'设备的类别'},
      {name:'localizedModel',cnname:'设备的的本地化版本'},
      {name:'deviceId',cnname:''},
      {name:'deviceName',cnname:'设备所有者的名称'},
      {name:'uniqueId',cnname:'设备识别码'},
      {name:'bundleId',cnname:''},
      {name:'appVersion',cnname:''},
      {name:'buildNumber',cnname:''},
      {name:'ipAddress',cnname:'ip地址'},
      {name:'carrierName',cnname:'当前运营商'},
      {name:'connectType',cnname:'网络类型'},
      {name:'macAddress',cnname:'MAC地址'}
    ];

    return rows;
  },

});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'stretch',
  },
  header:{
    backgroundColor:'#ececec',
    justifyContent: 'center',
    alignItems: 'center',
    height:64,
  },
  row:{
    flex: 1,
    justifyContent: 'center',
    alignItems:'stretch',
    backgroundColor:'white',
    padding: 5,
    borderBottomWidth: 1 / PixelRatio.get(),
    borderBottomColor: '#CDCDCD',
  },
  rowTitle:{
    flex:1,
    flexDirection:'row',
    alignItems:'center',
    justifyContent:'space-between'
  },
  rowText:{
    color:'purple',
    padding: 5,
  },
});

export default TableView;