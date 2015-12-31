/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

import React,{ 
  AppRegistry,
  View,
  Navigator,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
} from 'react-native';  
import TableCell from './Components/TableCell';
import styles from './Styles/CommonStyles';
import AwesomeProject from './demos/AwesomeProject';
import ListViewDemo from './demos/ListViewDemo';
import DeviceInfoDemo from './demos/DeviceInfoDemo';
import MapViewDemo from './demos/MapViewDemo';

// 主页Demo列表
var HomeView = React.createClass({
    render(){
      return (
        <ScrollView style={styles.scene}>
          <TableCell text='AwesomeProject' onPress={()=>{
             this.props.navigator.push({name:"AwesomeProject"});
          }}/>
          <TableCell text='ListViewDemo' onPress={()=>{
             this.props.navigator.push({name:"ListViewDemo"});
          }}/>
          <TableCell text='DeviceInfoDemo' onPress={()=>{
             this.props.navigator.push({name:"DeviceInfoDemo"});
          }}/>
          <TableCell text='MapViewDemo' onPress={()=>{
             this.props.navigator.push({name:"MapViewDemo"});
          }}/>
        </ScrollView>
      )
    }
});



var App = React.createClass({
  render: function() {
    return (
      <Navigator
        style={styles.appContainer}
        initialRoute={{name:'Home'}}
        configureScene={this.configureScene}
        renderScene={this.renderScene}
        navigationBar={
          <Navigator.NavigationBar
            routeMapper={this.NavigationBarRouteMapper}
            style={styles.navBar}
          />
        }
      />
    );
  },
  // 导航控制器动画配置
  configureScene(route){
    return Navigator.SceneConfigs.FloatFromRight
  },
  // 路由展示哪个视图 并传递导航条对象 用于后续视图的push pop等操作
  renderScene(route, navigator){
      var Component = null;
      switch(route.name){
        case 'AwesomeProject':
          Component = AwesomeProject;
          break;
        case 'ListViewDemo':
          Component = ListViewDemo;
          break;
        case 'DeviceInfoDemo':
          Component = DeviceInfoDemo;
          break;
        case 'MapViewDemo':
          Component = MapViewDemo;
          break;
        default: 
          Component = HomeView;
          break;
      }

      return (
      	<View style={{marginTop:64,flex:1,alignItems:'stretch'}}>
      		<Component navigator={navigator} />
      	</View>
      );
  },
  // 导航栏设置
  NavigationBarRouteMapper:{

	  LeftButton: function(route, navigator, index, navState) {
	    if (index === 0) {
	      return null;
	    }

	    var previousRoute = navState.routeStack[index - 1];
	    return (
	      <TouchableOpacity
	        onPress={() => navigator.pop()}
	        style={styles.navBarLeftButton}>
	        <Text style={[styles.navBarText, styles.navBarButtonText]}>
	          {previousRoute.name}
	        </Text>
	      </TouchableOpacity>
	    );
	  },

	  RightButton: function(route, navigator, index, navState) {
	    return (
	      <TouchableOpacity
	        onPress={() => navigator.push(newRandomRoute())}
	        style={styles.navBarRightButton}>
	        
	      </TouchableOpacity>
	    );
	  },

	  Title: function(route, navigator, index, navState) {
	    return (
	      <Text style={[styles.navBarText, styles.navBarTitleText]}>
	        {route.name} [{index}]
	      </Text>
	    );
	  },

	},
});

export default App
