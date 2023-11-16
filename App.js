import React from 'react';
import {createAppContainer, createStackNavigator} from 'react-navigation';

import Homescreen from './screens/Homescreen';
import Checkout from './screens/Checkout';
import Response from './screens/Response';
//block:start:import-hyper-sdk

import HyperSdkReact from 'hyper-sdk-react';

//block:end:import-hyper-sdk
import uuid from 'react-native-uuid';
import {NativeEventEmitter, NativeModules} from 'react-native';

const RootStack = createStackNavigator({
  Home: Homescreen,
  Response: Response,
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

  render() {
    return <AppContainer />;
  }
}

export default App;
