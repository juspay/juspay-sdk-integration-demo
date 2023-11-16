/* eslint-disable react-native/no-inline-styles */
import React from "react";
import { StyleSheet, TouchableOpacity, Image, View, ActivityIndicator } from "react-native";
import HyperSdkReact from "hyper-sdk-react";
import {
  BackHandler,
  Button,
  NativeEventEmitter,
  NativeModules,
  Text,
} from "react-native";
import { createStackNavigator } from "react-navigation";
import ApiClient from "./ApiClient";

class Checkout extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      processPayload: {},
      total: 1,
      isLoaderActive: false,
    };
  }

  componentDidMount() {
    const eventEmitter = new NativeEventEmitter(NativeModules.HyperSdkReact);
    // block:start:create-hyper-callback
    eventEmitter.addListener("HyperEvent", (resp) => {
      const data = JSON.parse(resp);
      const orderId = data.orderId;
      const event = data.event || "";
      switch (event) {
        case "initiate_result":
        case "hide_loader":
          //Handle initiate_result and hide_loader
          this.setState({ isLoaderActive: false });
          break;
        //block:start:handle-process-result

        case "process_result":
          const innerPayload = data.payload || {};
          const status = innerPayload.status || "";
          switch (status) {
            case "backpressed":
            case "user_aborted":
              //Handle Backpress or user aborted case
              break;
            default:
              this.props.navigation.navigate("Response", {
                orderId: orderId,
              });
          }
          break;
        default:
          console.log(data);
      }
    });
    // block:end:create-hyper-callback

    //block:start:onBackPress
    BackHandler.addEventListener("hardwareBackPress", () => {
      return !HyperSdkReact.isNull() && HyperSdkReact.onBackPressed();
    });
    //block:end:onBackPress
  }

  // block:start:startPayment
  startPayment() {
    this.setState({ isLoaderActive: true });
    // block:start:updateOrderID
    var payload = {
      order_id: `test-${getRandomNumber()}`,
      amount: this.state.total,
    };
    // block:end:updateOrderID


    ApiClient.sendPostRequest(
      // block:start:await-http-post-function
      "http://10.0.2.2:5000/initiateJuspayPayment",
      // block:end:await-http-post-function
      payload,
      {
        onResponseReceived: (response) => {
          // block:start:openPaymentPage
          HyperSdkReact.openPaymentPage(
            JSON.stringify(JSON.parse(response).sdkPayload)
          );
          // block:end:openPaymentPage
        },
        onFailure: (error) => {
          console.error("POST request failed:", error);
        },
      }
    );

  }
  // block:end:startPayment

  handleBackPress() {
    this.props.navigation.navigate("Home");
  }

  render() {
    const { p1Count, p2Count, p1Price, p2Price } =
      this.props.navigation.state.params;
    this.state.total = p1Price * p1Count + p2Price * p2Count + 2;
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
            Call HyperSdkReact.openPaymentPage() on Checkout button click
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
                <Text style={styles._2}>
                  ₹ {p1Price * p1Count + p2Price * p2Count}
                </Text>
                <Text style={styles._02}>₹ 2</Text>
                <Text style={styles._22}>
                  ₹ {p1Price * p1Count + p2Price * p2Count + 2}
                </Text>
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
        {this.state.isLoaderActive && (
          <View style={styles.container}>
            <View style={styles.centeredContent}>
              <ActivityIndicator size="large"/>
            </View>
          </View>
        )}
      </View>
    );
  }
}

const getRandomNumber = () => {
  return Math.floor(Math.random() * 90000000) + 10000000;
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
  container: {
    width: '100%',
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
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
    paddingLeft: 30,
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
    paddingLeft: 30,
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
    paddingTop: 40,
  },
  Vector1: {
    position: "absolute",
    top: 227,
    left: 13,
    width: 329,
  },
});
