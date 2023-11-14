/* eslint-disable react-native/no-inline-styles */
import React from 'react';
import { View, Text } from 'react-native';
import { createStackNavigator } from 'react-navigation';
import ApiClient from './ApiClient'; // Adjust the import path based on your project structure

export class Response extends React.Component {
  state = {
    responseText: '',
    orderId: ''
  };

  componentDidMount() {
    const { orderId } = this.props.navigation.state.params;
    this.setState({orderId: orderId})
    ApiClient.sendGetRequest(`http://10.0.2.2:5000/handleJuspayResponse?order_id=${orderId}`, {
      onResponseReceived: response => {
        this.setState({ responseText: JSON.parse(response).order_status });
      },
      onFailure: error => {
        console.error('GET request failed:', error);
        this.setState({ responseText: 'Order Status API Failed' });
      },
    });
  }

  render() {
    const { responseText, orderId } = this.state;

    return (
      <View
        style={{
          display: 'flex',
          height: '100%',
          alignItems: 'center',
          justifyContent: 'center',
        }}>
        <Text style={{ color: 'green', fontSize: 30 }}>{responseText}</Text>
        <Text style={{ color: 'black', fontSize: 16 }}>{orderId}</Text>
      </View>
    );
  }
}

export default createStackNavigator(
  {
    Response: {
      screen: Response,
    },
  },
  {
    headerMode: 'none',
    navigationOptions: {
      headerVisible: false,
    },
  },
);
