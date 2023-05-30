import React, {useEffect, useState} from 'react'
import HyperSdkReact from 'hyper-sdk-react';
import { BackHandler, Button, NativeEventEmitter, NativeModules, ScrollView, Text } from 'react-native';

export default function Checkout({navigation}) {
    const [processPayload, setProcessPayload] = useState({});
    
    //Setting event listener to check for process result
    // block:start:event-handling-process
    
    useEffect(() => {
        const eventEmitter = new NativeEventEmitter(NativeModules.HyperSdkReact);
        const eventListener = eventEmitter.addListener('HyperEvent', (resp) => {
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

                        navigation.navigate('Success');

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
                                navigation.navigate('Failure');
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

                                navigation.navigate('Failure');

                                //block:end:display-payment-status
                                break;
                            case 'new':
                                // order created but txn failed
                                // very rare for V2 (signature based)
                                // also failure
                                // poll order status
                                navigation.navigate('Failure');
                                break;
                            default:
                                // unknown status, this is also failure
                                // poll order status
                                navigation.navigate('Failure');
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
        return () => {
            eventListener.remove();
        }
    }, [])

    // block:end:event-handling-process

    // block:start:fetch-process-payload

    //Get process payload from server after session API S2S call
    useEffect(() => {
        setProcessPayload({
            "requestId":"dbba45aaf8dc408da474b7943b9e1d9f",
            "service":"in.juspay.hyperpay",
            "payload":{
               "clientId":"<CLIENT_ID>",
               "amount":"10.0",
               "merchantId":"acmecorp",
               "clientAuthToken":"tkn_adbf808e1d2b4d95b41144d0960b5a7e",
               "clientAuthTokenExpiry":"2022-01-24T17:40:22Z",
               "environment":"production",
               "action":"paymentPage",
               "customerId":"dummyCustId",
               "currency":"INR",
               "customerPhone":"9876543210",
               "customerEmail":"dummyemail@gmail.com",
               "orderId":"yourUniqueOrderId"
            }
        });
    }, [])
    
    // block:end:fetch-process-payload

    //Handling hardware backpress inside the checkout screen
    // block:start:handle-hardware-backpress
    
    useEffect(() => {
        BackHandler.addEventListener('hardwareBackPress', () => {
            return !HyperSdkReact.isNull() && HyperSdkReact.onBackPressed();
        });
        return () => {
            BackHandler.removeEventListener('hardwareBackPress', () => null);
        }
    }, [])
    
    // block:end:handle-hardware-backpress

    // block:start:process-sdk

    const startPayment = () => {
        HyperSdkReact.process(JSON.stringify(processPayload))
    }
    
    // block:end:process-sdk

    return (
        <ScrollView
            contentInsetAdjustmentBehavior="automatic"
            contentContainerStyle={{alignItems: 'center', justifyContent: 'space-around', height: "100%"}}
        >
            <Text>Initialized automatically on this screen</Text>
            <Button onPress={()=>startPayment()} title="Process"></Button>
        </ScrollView>
    )
}
