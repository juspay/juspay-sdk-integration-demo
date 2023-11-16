/* eslint-disable react-native/no-inline-styles */
import React from "react";
import { View, Text } from "react-native";
import { createStackNavigator } from "react-navigation";
import ApiClient from "./ApiClient"; // Adjust the import path based on your project structure

export class Response extends React.Component {
  state = {
    responseText: "",
    orderId: "",
    orderStatus: "",
  };

  componentDidMount() {
    const { orderId } = this.props.navigation.state.params;
    this.setState({ orderId: orderId });
    // block:start:sendGetRequest
    ApiClient.sendGetRequest(
      `http://10.0.2.2:5000/handleJuspayResponse?order_id=${orderId}`,
      {
        onResponseReceived: (response) => {
          const orderStatus = JSON.parse(response).order_status;
          this.setState({ orderStatus: orderStatus });
          switch (orderStatus) {
            case "CHARGED":
              this.setState({ responseText: "Order Successful" });
              break;
            case "PENDING_VBV":
              this.setState({ responseText: "Order is Pending..." });
              break;
            default:
              this.setState({ responseText: "Order has Failed" });
              break;
          }
        },
        onFailure: (error) => {
          console.error("GET request failed:", error);
          this.setState({ responseText: "Order Status API Failed" });
        },
      }
    );
    // block:end:sendGetRequest
    
  }

  render() {
    const { responseText, orderId, orderStatus } = this.state;

    return (
      <View
        style={{
          display: "flex",
          height: "100%",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        <Text
          style={{
            color:
              orderStatus === "CHARGED"
                ? "green"
                : orderStatus === "PENDING_VBV"
                ? "orange"
                : "red",
            fontSize: 30,
          }}
        >
          {responseText}
        </Text>
        <Text style={{ color: "black", fontSize: 16 }}>{orderStatus}</Text>
        <Text style={{ color: "black", fontSize: 16 }}>{orderId}</Text>
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
    headerMode: "none",
    navigationOptions: {
      headerVisible: false,
    },
  }
);
