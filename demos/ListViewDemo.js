'use strict'

import React, {
  StyleSheet,
  Text,
  View,
  ListView,
} from 'react-native';

var ListViewDemo = React.createClass({
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
          renderFooter={this._renderFooter}
          initialListSize={10}
          pageSize={10}
          renderHeader={this._renderHeader}
          style={styles.table}
        />
      </View>
    );
  },

  _renderHeader:()=> {
    return (
      <View style={styles.header}>
        <Text>header</Text>
      </View>
    );
  },

  _renderRow:function(rowData:string,sectionID:number,rowID:number){
    var devInfoMethod=['getUniqueID'];

    return (
      <View style={styles.row}>
        <Text style={{color:'purple'}}>{
          '('+sectionID+','+rowID+'): '+rowData.name+' '
      }</Text>
      </View>
      );
  },

  _renderFooter:function(){
    return (
      <View style={styles.header}>
        <Text>footer</Text>
      </View>
    );
  },

  _genRows:function():Array<string>{
    var rows=[];

    for (var i = 0; i < 25; i++) {
      var item = {};
      item.name = 'test'+i;
      item.age = i*10;
      rows.push(item);
    };

    return rows;
  },

});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'stretch',
    backgroundColor: '#123456',
  },
  table:{
    backgroundColor:'#234567'
  },
  header:{
    backgroundColor:'#345678',
    justifyContent: 'center',
    alignItems: 'center',
    height:64,
  },
  row:{
    flex: 1,
    flexDirection:'row',
    justifyContent: 'flex-start',
    alignItems:'center',
    backgroundColor:'#456789',
    height:50,
  },
});

export default ListViewDemo;