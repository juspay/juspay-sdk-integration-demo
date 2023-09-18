import React from 'react';
import {createAppContainer, createStackNavigator} from 'react-navigation';

import Homescreen from './screens/Homescreen';
import Checkout from './screens/Checkout';
import Success from './screens/Success';
import Failure from './screens/Failure';
//block:start:import-hyper-sdk

import HyperSdkReact from 'hyper-sdk-react';

//block:end:import-hyper-sdk
import uuid from 'react-native-uuid';
import {NativeEventEmitter, NativeModules} from 'react-native';

const RootStack = createStackNavigator({
  Home: Homescreen,
  Success: Success,
  Failure: Failure,
  Checkout: Checkout,
});

const AppContainer = createAppContainer(RootStack);

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      stack: null,
    };
  }

  componentDidMount() {
    HyperSdkReact.createHyperServices();
    const eventEmitter = new NativeEventEmitter(NativeModules.HyperSdkReact);
    eventEmitter.addListener('HyperEvent', resp => {
      const data = JSON.parse(resp);
      const event = data.event || '';
      switch (event) {
        case 'initiate_result':
          // logging the initiate result
          console.log('Initiate result', data);
          break;
        default:
          console.log(data);
      }
    });

    const initiate_payload = {
      requestId: uuid.v4(),
      service: 'in.juspay.hyperpay',
      payload: {
        action: 'initiate',
        merchantId: '<MERCHANT_ID>',
        clientId: '<CLIENT_ID>',
        environment: 'production',
      },
    };

    HyperSdkReact.initiate(JSON.stringify(initiate_payload));
  }

  render() {
    return <AppContainer />;
  }
}

export default App;
