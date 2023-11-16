/* eslint-disable react-native/no-inline-styles */
import React from "react";
import { Text, Button } from "react-native";
import { TouchableOpacity } from "react-native";
import { StyleSheet, Image, View } from "react-native";
import { createStackNavigator } from "react-navigation";

class Homescreen extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      p1Count: 1,
      p2Count: 1,
      p1Price: 1,
      p2Price: 5,
    };
  }

  updateVariable = (property) => {
    if (property === "p1Increase") {
      this.setState((prevState) => ({
        p1Count: prevState.p1Count + 1,
      }));
    } else if (property === "p1Decrease" && this.state.p1Count > 0) {
      this.setState((prevState) => ({
        p1Count: prevState.p1Count - 1,
      }));
    } else if (property === "p2Increase") {
      this.setState((prevState) => ({
        p2Count: prevState.p2Count + 1,
      }));
    } else if (property === "p2Decrease" && this.state.p2Count > 0) {
      this.setState((prevState) => ({
        p2Count: prevState.p2Count - 1,
      }));
    }
  };

  render() {
    return (
      <View style={styles.HomeActivity}>
        <View style={styles.Group0104}>
          <View style={styles.Group822}>
            <Text style={styles.JuspaySdkIntegration}>
              Juspay SDK Integration Demo
            </Text>
            <Text style={styles.HomeScreen}>Home Screen</Text>
          </View>
          <View style={styles.Group352}>
            <Text style={styles.JuspayPaymentsSdkSho}></Text>
          </View>
          <View style={styles.Container}>
            <Text style={styles.Products}>Products</Text>
            <View style={styles.Product}>
              <View style={styles.Rectangle3}>
                <Image
                  style={styles.ProductImage}
                  source={require("../images/product1.png")}
                />
              </View>

              <Text style={styles.Product1}>Product 1</Text>
              <View style={styles.Group383}>
                <Text style={styles.PriceRs1ItemAwesomeP}>
                  Price: Rs. 1/item Awesome product description for product one.{" "}
                </Text>
                <View style={styles.Group738}>
                  <TouchableOpacity
                    onPress={() => this.updateVariable("p1Decrease")}
                  >
                    <Image
                      style={styles.MinusSvgrepoCom1}
                      source={{
                        uri: "https://firebasestorage.googleapis.com/v0/b/unify-v3-copy.appspot.com/o/eyqky7enuh-23%3A69?alt=media&token=3ca9e8a9-433d-43da-82a9-65034aaf6747",
                      }}
                    />
                  </TouchableOpacity>
                  <Text style={styles._1}>{this.state.p1Count}</Text>
                  <TouchableOpacity
                    onPress={() => this.updateVariable("p1Increase")}
                  >
                    <Image
                      style={styles.PlusSvgrepoCom1}
                      source={{
                        uri: "https://firebasestorage.googleapis.com/v0/b/unify-v3-copy.appspot.com/o/eyqky7enuh-23%3A52?alt=media&token=a6fd7be4-03c4-4f48-93f0-f9ae2daefe11",
                      }}
                    />
                  </TouchableOpacity>
                </View>
              </View>
            </View>
            <View style={styles.Product}>
              <View style={styles.Rectangle3}>
                <Image
                  style={styles.ProductImage}
                  source={require("../images/product2.png")}
                />
              </View>
              <Text style={styles.Product1}>Product 2</Text>
              <View style={styles.Group383}>
                <Text style={styles.PriceRs1ItemAwesomeP}>
                  Price: Rs. 5/item Awesome product description for product one.{" "}
                </Text>
                <View style={styles.Group738}>
                  <TouchableOpacity
                    onPress={() => this.updateVariable("p2Decrease")}
                  >
                    <Image
                      style={styles.MinusSvgrepoCom1}
                      source={{
                        uri: "https://firebasestorage.googleapis.com/v0/b/unify-v3-copy.appspot.com/o/eyqky7enuh-23%3A115?alt=media&token=863d9dd1-05c2-4e1c-be37-0f7b6979a28c",
                      }}
                    />
                  </TouchableOpacity>
                  <Text style={styles._1}>{this.state.p2Count}</Text>
                  <TouchableOpacity
                    onPress={() => this.updateVariable("p2Increase")}
                  >
                    <Image
                      style={styles.PlusSvgrepoCom1}
                      source={{
                        uri: "https://firebasestorage.googleapis.com/v0/b/unify-v3-copy.appspot.com/o/eyqky7enuh-23%3A113?alt=media&token=31f12a02-585f-49ab-846f-37a115676286",
                      }}
                    />
                  </TouchableOpacity>
                </View>
              </View>
            </View>

            <Button
              onPress={() =>
                this.props.navigation.navigate("Checkout", {
                  p1Count: this.state.p1Count,
                  p2Count: this.state.p2Count,
                  p1Price: this.state.p1Price,
                  p2Price: this.state.p2Price,
                })
              }
              style={styles.Group249}
              title="Go To Cart"
            />
          </View>
        </View>
      </View>
    );
  }
}

export default createStackNavigator(
  {
    Home: {
      screen: Homescreen,
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
  ProductImage: {
    height: 149,
    width: 149,
    backgroundColor: "rgba(245,245,245,1)",
  },
  HomeActivity: {
    display: "flex",
    flexDirection: "column",
    justifyContent: "flex-start",
    alignItems: "flex-start",
    paddingBottom: 28,
    width: "100%",
    height: "100%",
    boxSizing: "border-box",
    backgroundColor: "rgba(254,254,254,1)",
  },
  Group0104: {
    display: "flex",
    flexDirection: "column",
    width: "100%",
    height: "100%",
    boxSizing: "border-box",
  },
  Group822: {
    display: "flex",
    flexDirection: "column",
    width: "100%",
    paddingLeft: 16,
    paddingRight: 180,
    paddingTop: 18,
    paddingBottom: 20,
    boxSizing: "border-box",
    backgroundColor: "rgba(46,43,44,1)",
  },
  JuspaySdkIntegration: {
    color: "rgba(255,255,255,1)",
    fontSize: 12,
    lineHeight: 12,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "600",
    paddingBottom: 10,
  },
  HomeScreen: {
    color: "rgba(255,255,255,1)",
    fontSize: 16,
    lineHeight: 16,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "600",
  },
  Group352: {
    width: "100%",
    height: 47,
    paddingLeft: 12,
    paddingRight: 45,
    paddingTop: 14,
    paddingBottom: 0,
    boxSizing: "border-box",
    backgroundColor: "rgba(248,245,245,1)",
  },
  JuspayPaymentsSdkSho: {
    color: "rgba(0,0,0,1)",
    fontSize: 12,
    lineHeight: 12,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    paddingTop: 5,
  },
  Products: {
    color: "rgba(251,141,51,1)",
    fontSize: 18,
    lineHeight: 18,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "700",
    paddingTop: 10,
    paddingBottom: 10,
  },
  Product: {
    display: "flex",
    flexDirection: "column",
    width: "100%",
    boxSizing: "border-box",
  },
  Rectangle3: {
    width: "100%",
    height: 149,
    alignItems: "center",
    borderRadius: 8,
    backgroundColor: "rgba(245,245,245,1)",
  },
  Product1: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "600",
    paddingTop: 10,
    paddingBottom: 10,
  },
  Group383: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-between",
    width: "100%",
    boxSizing: "border-box",
    paddingBottom: 20,
  },
  PriceRs1ItemAwesomeP: {
    color: "rgba(0,0,0,1)",
    fontSize: 12,
    lineHeight: 12,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
    width: "50%",
  },
  Group738: {
    display: "flex",
    flexDirection: "row",
    alignItems: "flex-end",
    height: "100%",
    paddingLeft: 7,
    paddingRight: 10,
    paddingTop: 2,
    paddingBottom: 7,
    borderWidth: 1,
    borderColor: "rgba(0,0,0,1)",
    borderRadius: 4,
    boxSizing: "border-box",
    backgroundColor: "rgba(255,255,255,1)",
    width: 70,
  },
  MinusSvgrepoCom1: {
    width: 14,
    height: 14,
  },
  _1: {
    color: "rgba(251,141,51,1)",
    fontSize: 14,
    lineHeight: 18,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "700",
    marginLeft: 10,
  },
  PlusSvgrepoCom1: {
    width: 14,
    height: 14,
    marginLeft: 10,
  },
  Product4: {
    display: "flex",
    flexDirection: "column",
    width: "100%",
    boxSizing: "border-box",
  },
  Rectangle31: {
    width: "100%",
    height: 149,
    borderRadius: 8,
    backgroundColor: "rgba(245,245,245,1)",
  },
  Product2: {
    color: "rgba(0,0,0,1)",
    fontSize: 14,
    lineHeight: 14,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "600",
  },
  Group190: {
    display: "flex",
    flexDirection: "row",
    width: "100%",
    boxSizing: "border-box",
  },
  PriceRs1ItemAwesomeP1: {
    color: "rgba(0,0,0,1)",
    fontSize: 12,
    lineHeight: 12,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "400",
  },
  Group658: {
    display: "flex",
    flexDirection: "row",
    alignItems: "flex-end",
    height: "100%",
    paddingLeft: 7,
    paddingRight: 10,
    paddingTop: 2,
    paddingBottom: 7,
    borderWidth: 1,
    borderColor: "rgba(0,0,0,1)",
    borderRadius: 4,
    boxSizing: "border-box",
    backgroundColor: "rgba(255,255,255,1)",
  },
  MinusSvgrepoCom11: {
    width: 16,
    height: 16,
  },
  _11: {
    color: "rgba(251,141,51,1)",
    fontSize: 18,
    lineHeight: 18,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "700",
  },
  PlusSvgrepoCom11: {
    width: 16,
    height: 16,
  },
  Group249: {
    bottom: 0,
    width: "100%",
    height: 35,
    paddingLeft: 133,
    paddingRight: 125,
    paddingTop: 7,
    paddingBottom: 12,
    borderRadius: 4,
    boxSizing: "border-box",
    backgroundColor: "rgba(17, 83, 144, 1)",
  },
  GoToCart: {
    color: "rgba(255,255,255,1)",
    fontSize: 18,
    lineHeight: 18,
    fontFamily: "Nunito Sans, sans-serif",
    fontWeight: "700",
  },
  Container: {
    paddingLeft: 10,
    paddingRight: 10,
  },
});
