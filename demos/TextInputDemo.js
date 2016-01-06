/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  TextInput,
  View,
  TouchableHighlight,
} = React;

var TextInputDemo = React.createClass({
  getInitialState() {
    return {
      value:''
    };
  },
  onChange(event){
    console.log(event.nativeEvent.text);
    this.setState({value:event.nativeEvent.text});
  },
  render: function() {
    let self = this;
    return (
      <View style={styles.container}>
        <TextInput ref='textbox' value='hehe' style={styles.textbox} onChange={this.onChange}/>
        <TouchableHighlight onPress={function(a,b,c){
          console.log(self.refs.textbox.props.value);
        }}>
          <Text>click</Text>
        </TouchableHighlight>
      </View>
    );
  },
});

var styles = StyleSheet.create({
  container: {

    justifyContent: 'center',
    alignItems: 'center',
  },
  textbox:{
    flex:1,
    fontSize: 24,
    height: 36,
    padding: 7,
    borderRadius: 4,
    borderColor: 'red',
    borderWidth: 3,
    borderStyle:'solid',
    marginBottom: 5
  },
});

export default TextInputDemo;