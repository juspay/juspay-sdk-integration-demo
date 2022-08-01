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
    // block:start:create-hyper-services-instance

    HyperSdkReact.createHyperServices();

    // block:end:create-hyper-services-instance

    // block:start:event-handling-initiate

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

    // block:end:event-handling-initiate

    // Creating initiate payload JSON object
    // block:start:create-initiate-payload

    const initiate_payload = {
      requestId: uuid.v4(),
      service: 'in.juspay.hyperpay',
      payload: {
        action: 'initiate',
        merchantId: 'picasso',
        clientId: 'picasso',
        environment: 'sandbox',
      },
    };

    // block:end:create-initiate-payload

    // Calling initiate on hyperService instance to boot up payment engine.
    // block:start:initiate-sdk

    HyperSdkReact.initiate(JSON.stringify(initiate_payload));

    // block:end:initiate-sdk
  }

  render() {
    return <AppContainer />;
  }
}

export default App;
