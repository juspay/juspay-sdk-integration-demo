/* eslint-disable react-native/no-inline-styles */
import React from 'react';
import {View, Text} from 'react-native';
import {createStackNavigator} from 'react-navigation';

export class Success extends React.Component {
  render() {
    return (
      <View
        style={{
          display: 'flex',
          height: '100%',
          alignItems: 'center',
          justifyContent: 'center',
        }}>
        <Text style={{color: 'green', fontSize: 30}}>Success :D</Text>
      </View>
    );
  }
}

export default createStackNavigator(
  {
    Success: {
      screen: Success,
    },
  },
  {
    headerMode: 'none',
    navigationOptions: {
      headerVisible: false,
    },
  },
);
