/* eslint-disable react-native/no-inline-styles */
import React from 'react';
import {Text, Button, ScrollView} from 'react-native';
import {createStackNavigator} from 'react-navigation';

class Homescreen extends React.Component {
  constructor(props) {
    super(props);
  }
  render() {
    return (
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        contentContainerStyle={{
          alignItems: 'center',
          justifyContent: 'space-around',
          height: '100%',
        }}>
        <Text>Juspay Integration Example</Text>
        <Button
          onPress={() => this.props.navigation.navigate('Checkout')}
          style={{
            backgroundColor: 'blue',
            width: '40%',
            height: 30,
            borderRadius: 5,
            alignItems: 'center',
            justifyContent: 'center',
          }}
          title="Checkout"
        />
      </ScrollView>
    );
  }
}

export default createStackNavigator(
  {
    Home: {
      screen: Homescreen,
    },
  },
  {
    headerMode: 'none',
    navigationOptions: {
      headerVisible: false,
    },
  },
);
