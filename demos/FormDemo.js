'use strict';

import React, {
  AppRegistry, StyleSheet, Text, View, TouchableHighlight, 
  ScrollView,
  TextInput
} from 'react-native';

var t = require('tcomb-form-native');
var stylesheet = require('tcomb-form-native/lib/stylesheets/bootstrap');
var templates = require('tcomb-form-native/lib/templates/bootstrap');
var Textbox = t.form.Textbox;


var Form = t.form.Form;

var Person = t.struct({
  name: t.String,
  surname: t.maybe(t.String),
  age: t.refinement(t.Number, function(n){
    return n>=30&&n<=60;
  }),
  email: t.maybe(t.String),
  custom: t.maybe(t.String),
  auto: t.String,
  gender: t.Boolean,
  password: t.String,
});

function myCustomTemplate(locals) {

  var containerStyle = {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  };

  var labelStyle = {color:'blue'};
  var textboxStyle = stylesheet.textbox.normal;

  return (
    <View style={containerStyle}>
      <Text style={labelStyle}>{locals.label}</Text>
      <TextInput style={[textboxStyle, {flex:1}]} />
    </View>
  );
}

var options = {
  order: ['name', 'surname', 'rememberMe', 'email', 'age', 'custom', 'auto', 'gender', 'password'
  ],//默认排序，漏写的不显示
  label:'表单标题',
  fields:{
    name:{
      label: '姓名',
      help: 'Your help message here',
    },
    surname:{
      placeholder:'请输入姓氏'
    },
    email:{
      editable: false,
      placeholder:'不可编辑',
      error: '不可编辑'
    },
    age:{
      autoCapitalize: 'none',
      autoCorrect: false,
      error: (value, path, context): ?String => { 
        return <Text style={styles.myError}>年龄为数字30~60</Text>
      },
      onBlur: function(){
        console.log('age onBlur');
      },
    },
    custom:{
      hasError: false,
     
    },
    auto:{
      auto:'none',
      error: (value, path, context): ?String => {
        return '不对，嘿嘿';
      },
    },
    gender:{
      marginLeft: 15,
    },
    password: {
      secureTextEntry: true,

    }
  }
}; // optional rendering options (see documentation)

var FormDemo = React.createClass({

  getInitialState() {
    return {
      value: {
        name: '姓名的默认值',
      },
      options:options,
    };
  },

  onChange(value) {
    this.setState({value});
  },

  onPress: function () {
    // call getValue() to get the values of the form
    var value = this.refs.form.getValue();
    if (value) { // if validation fails, value will be null
      console.log(value); // value here is an instance of Person
    }
  },

  render: function() {
    return (
      <View style={styles.container}>
        {/* display */}
        <ScrollView>
          <Form
            ref="form"
            type={Person}
            options={this.state.options}
            value={this.state.value}
            onChange={this.onChange}
          />
          <TouchableHighlight style={styles.button} onPress={this.onPress} underlayColor='#99d9f4'>
            <Text style={styles.buttonText}>Save</Text>
          </TouchableHighlight>
        </ScrollView>
      </View>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'flex-start',
    padding:5,
    backgroundColor: '#ffffff',
  },
  title: {
    fontSize: 30,
    alignSelf: 'center',
    marginBottom: 30
  },
  buttonText: {
    fontSize: 18,
    color: 'white',
    alignSelf: 'center'
  },
  button: {
    height: 36,
    backgroundColor: '#48BBEC',
    borderColor: '#48BBEC',
    borderWidth: 1,
    borderRadius: 8,
    marginBottom: 10,
    alignSelf: 'stretch',
    justifyContent: 'center'
  },
  myError: {
    color: 'purple',
  },
});

export default FormDemo;