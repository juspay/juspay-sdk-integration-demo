import React, {useEffect} from 'react';
import {NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';

import Homescreen from './screens/Homescreen';
import Checkout from './screens/Checkout';
import Success from './screens/Success';
import Failure from './screens/Failure';
//block:start:import-hyper-sdk

import HyperSdkReact from 'hyper-sdk-react';

//block:end:import-hyper-sdk
import uuid from 'react-native-uuid';
import { NativeEventEmitter, NativeModules } from 'react-native';

const App = () => {
  useEffect(() => {
    // block:start:create-hyper-services-instance

    HyperSdkReact.createHyperServices();
    
    // block:end:create-hyper-services-instance

    // Creating initiate payload JSON object
    // block:start:create-initiate-payload

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

    // block:end:create-initiate-payload

    // Calling initiate on hyperService instance to boot up payment engine.
    // block:start:initiate-sdk

    HyperSdkReact.initiate(JSON.stringify(initiate_payload));
    
    // block:end:initiate-sdk
  }, []);

  // block:start:event-handling-initiate
  useEffect(() => {
    const eventEmitter = new NativeEventEmitter(NativeModules.HyperSdkReact);
    const eventListener = eventEmitter.addListener('HyperEvent', resp => {
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
    return () => {
      eventListener.remove();
    };
  }, []);
  // block:end:event-handling-initiate

  const Stack = createStackNavigator();

  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen
          name="Home"
          component={Homescreen}
          options={{title: 'Home'}}
        />
        <Stack.Screen
          name="Checkout"
          component={Checkout}
          options={{title: 'Checkout'}}
        />
        <Stack.Screen
          name="Success"
          component={Success}
          options={{title: 'Success'}}
        />
        <Stack.Screen
          name="Failure"
          component={Failure}
          options={{title: 'Failure'}}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default App;
