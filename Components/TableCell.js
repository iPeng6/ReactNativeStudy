'use strict'

import React,{
  TouchableHighlight,
  StyleSheet,
  Text,
} from 'react-native';
import styles from '../Styles/CommonStyles';

export default class TableCell extends React.Component {

  render() {
    return (
      <TouchableHighlight
        style={styles.button}
        underlayColor="#B5B5B5"
        onPress={this.props.onPress}>
          <Text style={styles.buttonText}>{this.props.text}</Text>
      </TouchableHighlight>
    );
  }
}

