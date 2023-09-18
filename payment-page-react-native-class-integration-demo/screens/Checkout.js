/* eslint-disable react-native/no-inline-styles */
import React from "react";
import {
  StyleSheet,
  TouchableOpacity,
  Image,
  View,
  ImageBackground,
} from "react-native";
import HyperSdkReact from "hyper-sdk-react";
import axios from "axios";
import { encode } from "base-64";
import { withNavigation } from "react-navigation";
// import { NavigationActions } from 'react-navigation';
import {
  BackHandler,
  Button,
  NativeEventEmitter,
  NativeModules,
  ScrollView,
  Text,
  navigation,
} from "react-native";
import { createStackNavigator } from "react-navigation";

class Checkout extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      processPayload: {},
      total: 1
    };
  }

  // console.log(">>>>", this.props.route)

  //Setting event listener to check for process result
  // block:start:event-handling-process

  // Call the function to make the payment request

  componentDidMount() {
    console.log(">>>>", this.props.navigation.state.params)
    const eventEmitter = new NativeEventEmitter(NativeModules.HyperSdkReact);
    eventEmitter.addListener("HyperEvent", (resp) => {
      const data = JSON.parse(resp);
      const event = data.event || "";
      switch (event) {
        case "initiate_result":
          // this was already handled in homescreen where initiate was called
          break;
        case "hide_loader":
          // stop the processing loader
          break;
        //block:start:handle-process-result

        case "process_result":
          const error = data.error || false;
          const innerPayload = data.payload || {};
          const status = innerPayload.status || "";
          const pi = innerPayload.paymentInstrument || "";
          const pig = innerPayload.paymentInstrumentGroup || "";

          if (!error) {
            // txn success, status should be "charged"

            //block:start:check-order-status

            // call orderStatus once to verify (false positives)

            //block:end:check-order-status

            //block:start:display-payment-status

            this.props.navigation.navigate("Success");

            //block:end:display-payment-status
          } else {
            const errorCode = data.errorCode || "";
            const errorMessage = data.errorMessage || "";
            switch (status) {
              case "backpressed":
                // user back-pressed from PP without initiating any txn
                break;
              case "user_aborted":
                // user initiated a txn and pressed back
                // poll order status
                this.props.navigation.navigate("Failure");
                break;
              case "pending_vbv":
              case "authorizing":
                // txn in pending state
                // poll order status until backend says fail or success
                break;
              case "authorization_failed":
              case "authentication_failed":
              case "api_failure":
                // txn failed
                // poll orderStatus to verify (false negatives)
                //block:start:display-payment-status

                this.props.navigation.navigate("Failure");

                //block:end:display-payment-status
                break;
              case "new":
                // order created but txn failed
                // very rare for V2 (signature based)
                // also failure
                // poll order status
                this.props.navigation.navigate("Failure");
                break;
              default:
                // unknown status, this is also failure
                // poll order status
                this.props.navigation.navigate("Failure");
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
    // block:end:fetch-process-payload

    //Handling hardware backpress inside the checkout screen

    // block:start:handle-hardware-backpress

    BackHandler.addEventListener("hardwareBackPress", () => {
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
    if(HyperSdkReact.isInitialised()){
      makePaymentRequest(this.state.total);
    }
    
    // HyperSdkReact.process(JSON.stringify(this.state.processPayload));
  }

  handleBackPress() {
    this.props.navigation.navigate("Home");
  }

  // block:end:process-sdk

  render() {
    const { p1Count, p2Count, p1Price, p2Price } = this.props.navigation.state.params;
    this.state.total = (p1Price * p1Count) + (p2Price * p2Count) + 2;
    return (
      <View style={styles.CheckoutActivity}>
        <View style={styles.Group669}>
          <View style={styles.Group729}>
            <TouchableOpacity
              onPress={() => this.props.navigation.navigate("Home")}
            >
              <Image
                style={styles.ChevronSvgrepoCom1}
                source={{
                  uri: "https://firebasestorage.googleapis.com/v0/b/unify-v3-copy.appspot.com/o/okpeu14cdpp-23%3A45?alt=media&token=7372fc0c-5bf0-4aaa-8b73-4f2f0a01f204",
                }}
              />
            </TouchableOpacity>
            <View style={styles.Group331}>
              <Text style={styles.JuspaySdkIntegration}>
                Juspay SDK Integration Demo
              </Text>
              <Text style={styles.CheckoutScreen}>Checkout Screen</Text>
            </View>
          </View>
          <View style={styles.Group492}>
            <Text style={styles.CallProcessOnHyperse}>
              Call process on HyperServices instance on Checkout Button Click
            </Text>
          </View>
          <View style={styles.Container}>
            <Text style={styles.CartDetails}>Cart Details</Text>
            <View style={styles.Group879}>
              <View style={styles.Group924}>
                <Text style={styles.Product1}>Product 1</Text>
                <Text style={styles.Product2}>Product 2</Text>
              </View>
              <View style={styles.Group6109}>
                <View style={styles.Group968}>
                  <Text style={styles.X1}>x{p1Count}</Text>
                  <Text style={styles._1}>₹ {p1Price * p1Count}</Text>
                </View>
                <View style={styles.Group872}>
                  <Text style={styles.X11}>x{p2Count}</Text>
                  <Text style={styles._11}>₹ {p2Price * p2Count}</Text>
                </View>
              </View>
            </View>
            <Text style={styles.Amount}>Amount</Text>
            <View style={styles.Group466}>
              <View style={styles.Group412}>
                <Text style={styles.TotalAmount}>Total Amount</Text>
                <Text style={styles.Tax}>Tax</Text>
                <Text style={styles.TotalPayableAmount}>
                  Total Payable Amount
                </Text>
              </View>
              <View style={styles.Group828}>
                <Text style={styles._2}>₹ {(p1Price * p1Count) + (p2Price * p2Count)}</Text>
                <Text style={styles._02}>₹ 2</Text>
                <Text style={styles._22}>₹ {(p1Price * p1Count) + (p2Price * p2Count) + 2}</Text>
              </View>
            </View>
            <View style={styles.Checkout}>
              <Button
                onPress={() => this.startPayment()}
                title="Checkout"
                style={styles.Group883}
              />
            </View>
          </View>
        </View>
        <Image
          style={styles.Vector1}
          source={{
            uri: "https://firebasestorage.googleapis.com/v0/b/unify-v3-copy.appspot.com/o/l77bpu3z5t-23%3A126?alt=media&token=288ee118-fdf8-46d4-b853-8a5e1d3986a4",
          }}
        />
      </View>
    );
  }
}

const getRandomNumber = (min, max) => {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
};

const makePaymentRequest = (total) => {
  var myHeaders = new Headers();
  myHeaders.append(
    "Authorization",
    `Basic ${encode("8A0E4AD0420468BB144D1B116336DA")}`
  );
  myHeaders.append("x-merchantid", "testhdfc1");
  myHeaders.append("Content-Type", "application/json");

  var raw = JSON.stringify({
    order_id: `test-${getRandomNumber(100000000, 99999999)}`,
    amount: total,
    customer_id: "9876543201",
    customer_email: "test@mail.com",
    customer_phone: "9876543201",
    payment_page_client_id: "hdfcmaster",
    action: "paymentPage",
    return_url: "https://www.hdfcbank.com",
    description: "Complete your payment",
    first_name: "John",
    last_name: "wick"
  });

  var requestOptions = {
    method: "POST",
    headers: myHeaders,
    body: raw,
    redirect: "follow",
  };

  fetch("https://sandbox.juspay.in/session", requestOptions)
    .then((response) => response.json())
    .then((result) => {
      console.log("sdkPayload>>>", result.sdk_payload);
      // if(result.sdk_payload) return result.sdk_payload
      HyperSdkReact.process(JSON.stringify(result.sdk_payload));
    })
    .catch((error) => console.log("error", error));
};

export default createStackNavigator(
  {
    Checkout: {
      screen: Checkout,
    },
  },
  {
    headerMode: "none",
    navigationOptions: {
      header: null,
    },
  }
);

const styles = StyleSheet.create({
  Container: {
    paddingLeft: 10,
    paddingRight: 10,
  },
  CheckoutActivity: {
    position: "relative",
    display: "flex",
    flexDirection: "column",
    justifyContent: "flex-start",
    alignItems: "flex-start",
    width: "100%",
    height: "100%",
    boxSizing: "border-box",
    backgroundColor: "rgba(254,254,254,1)",
  },
  Group669: {
    position: "absolute",
    display: "flex",
    flexDirection: "column",
    width: "100%",
    boxSizing: "border-box",
  },
  Group729: {
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
    width: "100%",
    paddingLeft: 12,
    paddingRight: 152,
    paddingTop: 12,
    paddingBottom: 22,
    boxSizing: "border-box",
    backgroundColor: "rgba(46,43,44,1)",
  },
  ChevronSvgrepoCom1: {
    width: 20,
    height: 20,
  },
  Group331: {
    display: "flex",
    flexDirection: "column",
    height: "100%",
    boxSizing: "border-box",
    paddingTop: 4,
    paddingLeft: 16,
  },
  JuspaySdkIntegration: {
    color: "rgba(255,255,255,1)",
    fontSize: 12,
    lineHeight: 12,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "600",
    paddingBottom: 10,
  },
  CheckoutScreen: {
    color: "rgba(255,255,255,1)",
    fontSize: 16,
    lineHeight: 16,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "600",
  },
  Group492: {
    width: "100%",
    paddingLeft: 12,
    paddingRight: 27,
    paddingTop: 18,
    paddingBottom: 18,
    boxSizing: "border-box",
    backgroundColor: "rgba(248,245,245,1)",
  },
  CallProcessOnHyperse: {
    color: "rgba(0,0,0,1)",
    fontSize: 12,
    lineHeight: 12,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
  },
  CartDetails: {
    color: "rgba(251,141,51,1)",
    fontSize: 18,
    lineHeight: 18,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "700",
    paddingTop: 10,
    paddingBottom: 10,
  },
  Group879: {
    display: "flex",
    flexDirection: "row",
    alignItems: "flex-end",
    justifyContent: "space-between",
    width: "100%",
    paddingLeft: 11,
    paddingRight: 11,
    paddingTop: 15,
    paddingBottom: 26,
    borderWidth: 1,
    borderColor: "rgba(245,245,245,1)",
    borderRadius: 4,
    boxSizing: "border-box",
    backgroundColor: "rgba(254,254,254,1)",
  },
  Group924: {
    display: "flex",
    flexDirection: "column",
    height: "100%",
    boxSizing: "border-box",
  },
  Product1: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    paddingBottom: 20,
    paddingTop: 8,
  },
  Product2: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
  },
  Group6109: {
    display: "flex",
    flexDirection: "column",
    
    alignItems: "flex-end",
    height: "100%",
    boxSizing: "border-box",
  },
  Group968: {
    display: "flex",
    flexDirection: "row",

    alignItems: "flex-end",
    width: "100%",
    boxSizing: "border-box",
  },
  X1: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    paddingBottom: 20,
    paddingTop: 8,
  },
  _1: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    paddingBottom: 20,
    paddingTop: 8,
    paddingLeft: 30
  },
  Group872: {
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
    width: "100%",
    boxSizing: "border-box",
  },
  X11: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
  },
  _11: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    paddingLeft: 30
  },
  Amount: {
    color: "rgba(251,141,51,1)",
    fontSize: 18,
    lineHeight: 18,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "700",
    paddingTop: 10,
    paddingBottom: 10,
  },
  Group466: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-between",
    width: "100%",
    paddingLeft: 11,
    paddingRight: 12,
    paddingTop: 11,
    paddingBottom: 9,
    borderWidth: 1,
    borderColor: "rgba(245,245,245,1)",
    borderRadius: 4,
    boxSizing: "border-box",
    backgroundColor: "rgba(254,254,254,1)",
  },
  Group412: {
    display: "flex",
    flexDirection: "column",
    height: "100%",
    boxSizing: "border-box",
  },
  TotalAmount: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    paddingBottom: 20,
    paddingTop: 10,
  },
  Tax: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    paddingBottom: 20,
  },
  TotalPayableAmount: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    paddingBottom: 10,
  },
  Group828: {
    display: "flex",
    flexDirection: "column",
    alignItems: "flex-end",
    height: "100%",
    boxSizing: "border-box",
  },
  _2: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    paddingBottom: 20,
    paddingTop: 10,
  },
  _02: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    paddingBottom: 20,
  },
  _22: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
  },
  Group883: {
    width: "100%",
    height: 35,
    paddingLeft: 131,
    paddingRight: 135,
    paddingBottom: 12,
    borderRadius: 4,
    boxSizing: "border-box",
    backgroundColor: "rgba(17,83,144,1)",
    marginTop: 70,
  },
  Checkout: {
    paddingTop:40
  },
  Vector1: {
    position: "absolute",
    top: 227,
    left: 13,
    width: 329,
  },
});
