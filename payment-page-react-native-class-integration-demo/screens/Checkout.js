/* eslint-disable react-native/no-inline-styles */
import React from 'react';
import HyperSdkReact from 'hyper-sdk-react';
import {
  BackHandler,
  Button,
  NativeEventEmitter,
  NativeModules,
  ScrollView,
  Text,
} from 'react-native';
import {createStackNavigator} from 'react-navigation';

class Checkout extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      processPayload: {},
    };
  }

  //Setting event listener to check for process result
  // block:start:event-handling-process

  componentDidMount() {
    const eventEmitter = new NativeEventEmitter(NativeModules.HyperSdkReact);
    eventEmitter.addListener('HyperEvent', resp => {
      const data = JSON.parse(resp);
      const event = data.event || '';
      switch (event) {
        case 'initiate_result':
          // this was already handled in homescreen where initiate was called
          break;
        case 'hide_loader':
          // stop the processing loader
          break;
        //block:start:handle-process-result

        case 'process_result':
          const error = data.error || false;
          const innerPayload = data.payload || {};
          const status = innerPayload.status || '';
          const pi = innerPayload.paymentInstrument || '';
          const pig = innerPayload.paymentInstrumentGroup || '';

          if (!error) {
            // txn success, status should be "charged"

            //block:start:check-order-status

            // call orderStatus once to verify (false positives)

            //block:end:check-order-status

            //block:start:display-payment-status

            this.props.navigation.navigate('Success');

            //block:end:display-payment-status
          } else {
            const errorCode = data.errorCode || '';
            const errorMessage = data.errorMessage || '';
            switch (status) {
              case 'backpressed':
                // user back-pressed from PP without initiating any txn
                break;
              case 'user_aborted':
                // user initiated a txn and pressed back
                // poll order status
                this.props.navigation.navigate('Failure');
                break;
              case 'pending_vbv':
              case 'authorizing':
                // txn in pending state
                // poll order status until backend says fail or success
                break;
              case 'authorization_failed':
              case 'authentication_failed':
              case 'api_failure':
                // txn failed
                // poll orderStatus to verify (false negatives)
                //block:start:display-payment-status

                this.props.navigation.navigate('Failure');

                //block:end:display-payment-status
                break;
              case 'new':
                // order created but txn failed
                // very rare for V2 (signature based)
                // also failure
                // poll order status
                this.props.navigation.navigate('Failure');
                break;
              default:
                // unknown status, this is also failure
                // poll order status
                this.props.navigation.navigate('Failure');
            }
            // if txn was attempted, pi and pig would be non-empty
            // can be used to show in UI if you are into that
            // errorMessage can also be shown in UI
          }
          break;

        //block:end:handle-process-result
        default:
          console.log(data);
      }
    });

    // block:start:fetch-process-payload

    //Get process payload from server after session API S2S call
    this.setState({
      processPayload: {
        requestId: 'dbba45aaf8dc408da474b7943b9e1d9f',
        service: 'in.juspay.hyperpay',
        payload: {
          clientId: '<client_id>',
          amount: '10.0',
          merchantId: '<merchant_id>',
          clientAuthToken: 'tkn_adbf808e1d2b4d95b41144d0960b5a7e',
          clientAuthTokenExpiry: '2022-01-24T17:40:22Z',
          environment: 'production',
          action: 'paymentPage',
          customerId: 'dummyCustId',
          currency: 'INR',
          customerPhone: '9876543210',
          customerEmail: 'dummyemail@gmail.com',
          orderId: 'yourUniqueOrderId',
        },
      },
    });

    // block:end:fetch-process-payload

    //Handling hardware backpress inside the checkout screen

    // block:start:handle-hardware-backpress

    BackHandler.addEventListener('hardwareBackPress', () => {
      return !HyperSdkReact.isNull() && HyperSdkReact.onBackPressed();
    });

    // block:end:handle-hardware-backpress

    //Android Permissions Handling
    // block:start:handle-onRequestPermissionsResult
    
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
      if (HyperSdkReactModule.getPermissionRequestCodes().contains(requestCode)) {
          HyperSdkReactModule.onRequestPermissionsResult(requestCode, permissions, grantResults);
      } else {
          super.onRequestPermissionsResult(requestCode, permissions, grantResults);
      }
    }
    
    // block:end:handle-onRequestPermissionsResult
  }

  // block:end:event-handling-process

  // block:start:process-sdk

  startPayment() {
    HyperSdkReact.process(JSON.stringify(this.state.processPayload));
  }

  // block:end:process-sdk

  render() {
    return (
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        contentContainerStyle={{
          alignItems: 'center',
          justifyContent: 'space-around',
          height: '100%',
        }}>
        <Text>Initialized automatically on this screen</Text>
        <Button onPress={() => this.startPayment()} title="Process" />
      </ScrollView>
    );
  }
}

export default createStackNavigator(
  {
    Checkout: {
      screen: Checkout,
    },
  },
  {
    headerMode: 'none',
    navigationOptions: {
      headerVisible: false,
    },
  },
);
