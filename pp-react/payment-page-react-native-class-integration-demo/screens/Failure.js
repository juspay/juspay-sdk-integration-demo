/* eslint-disable react-native/no-inline-styles */
import React from 'react';
import {View, Text} from 'react-native';
import {createStackNavigator} from 'react-navigation';

class Failure extends React.Component {
  render() {
    return (
      <View
        style={{
          display: 'flex',
          height: '100%',
          alignItems: 'center',
          justifyContent: 'center',
        }}>
        <Text style={{color: 'red', fontSize: 30}}>Failure :(</Text>
      </View>
    );
  }
}

export default createStackNavigator(
  {
    Failure: {
      screen: Failure,
    },
  },
  {
    headerMode: 'none',
    navigationOptions: {
      headerVisible: false,
    },
  },
);
