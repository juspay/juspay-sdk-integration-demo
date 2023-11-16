/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

// Wait for the deviceready event before using any of Cordova's device APIs.
// See https://cordova.apache.org/docs/en/latest/cordova/events/events.html#deviceready

var hyperSDKRef;
document.addEventListener("deviceready", onDeviceReady, false);
var totalPayable;
const targetDivProducts = document.getElementById("productPage");
const targetDivCheckout = document.getElementById("checkoutPage");
const targetDivReturn = document.getElementById("responsePage");
const showStatus = document.getElementById("statusDiv");
const showOrderStatus = document.getElementById("orderStatusDiv");
const showOrderId = document.getElementById("orderIdDiv");
const statusIcon = document.getElementById("status_icon");
const cartBtn = document.getElementById("cartButton");
const checkoutBtn = document.getElementById("checkoutButton");

function onDeviceReady() {
  hyperSDKRef = cordova.plugins.HyperSDKPlugin;
  document.getElementById("deviceready").classList.add("ready");
}

document.getElementById("checkoutButton").addEventListener("click", () => {
  SpinnerDialog.show(null, "Processing...");
  startPayment();
});

const startPayment = () => {
  var myHeaders = new Headers();
  myHeaders.append("Content-Type", "application/json");

  var raw = JSON.stringify({
    order_id: "Test" + Math.floor(Math.random() * 1000000000),
    amount: totalPayable,
  });

  var requestOptions = {
    method: "POST",
    headers: myHeaders,
    body: raw,
    redirect: "follow",
  };

  fetch("http://10.0.2.2:5000/initiateJuspayPayment", requestOptions)
    .then((response) => response.json())
    .then((result) => {
      showToast("openPaymentPage called");
      hyperSDKRef.openPaymentPage(result.sdkPayload, hyperSDKCallback);
    })
    .catch((error) => console.log("error", error));
};

var hyperSDKCallback = function (response) {
  try {
    const data = JSON.parse(response);
    var event = data.event || "";
    switch (event) {
      case "hide_loader":
        {
          // Hide Loader
          SpinnerDialog.hide();
        }
        break;
      case "process_result":
        {
          // Get the payload
          const orderId = data["orderId"];
          const innerPayload = data.payload || {};
          const status = innerPayload.status || "";
          switch (status) {
            case "backpressed":
              //Handle Backpress
              break;
            case "user_aborted":
              //Handle User Aborted
              break;
            default:
              getOrderStatus(orderId);
              break;
          }
        }
        break;
      default:
        let payload = data;
        console.log("process result: ", payload);
        break;
    }
  } catch (error) {
    //Error handling
    console.log(error);
  }
};

const getOrderStatus = (orderId) => {
  targetDivProducts.style.display = "none";
  targetDivCheckout.style.display = "none";
  targetDivReturn.style.display = "block";
  fetch(`http://10.0.2.2:5000/handleJuspayResponse?order_id=${orderId}`)
    .then((response) => response.json())
    .then((result) => {
      showToast("Order Status Called");
      const orderStatus = result.order_status;
      showOrderStatus.innerHTML = "Status: " + orderStatus;
      showOrderId.innerHTML = "Order Id: " + orderId;
      switch (orderStatus) {
        case "CHARGED":
          showStatus.innerHTML = "Order Successful";
          break;
        case "PENDING_VBV":
          showStatus.innerHTML = "Order is Pending...";
          break;
        default:
          showStatus.innerHTML = "Order has Failed:(";
      }
    })
    .catch((error) => console.log("error", error));
};

targetDivCheckout.style.display = "none";
targetDivReturn.style.display = "none";
cartBtn.onclick = function () {
  targetDivProducts.style.display = "none";
  targetDivCheckout.style.display = "block";
  updateAmount();
  document.getElementById("checkoutPage").scrollIntoView();
};
checkoutBtn.onclick = function () {
  targetDivProducts.style.display = "none";
  targetDivCheckout.style.display = "block";
  document.getElementById("productPage").scrollIntoView();
};

function showToast(showMessage) {
  window.plugins.toast.showWithOptions({
    message: showMessage,
    duration: "short",
    position: "bottom",
    addPixelsY: -40,
  });
}

function hide() {
  window.plugins.toast.hide();
}

document.getElementById("checkout_back").addEventListener("click", () => {
  targetDivProducts.style.display = "block";
  targetDivCheckout.style.display = "none";
  targetDivReturn.style.display = "none";
});
document.getElementById("response_back").addEventListener("click", () => {
  targetDivProducts.style.display = "block";
  targetDivCheckout.style.display = "none";
  targetDivReturn.style.display = "none";
});
document.getElementById("response_okay").addEventListener("click", () => {
  targetDivProducts.style.display = "block";
  targetDivCheckout.style.display = "none";
  targetDivReturn.style.display = "none";
});
const countOne = document.getElementById("count1");
const countTwo = document.getElementById("count2");

document.getElementById("minus1").addEventListener("click", () => {
  count = parseInt(countOne.innerText);
  if (count > 0) {
    var temp = count - 1;
    countOne.innerHTML = temp;
  } else {
    showToast("Count can't be less than 0");
  }
});
document.getElementById("minus2").addEventListener("click", () => {
  count = parseInt(countTwo.innerText);
  if (count > 0) {
    var temp = count - 1;
    countTwo.innerHTML = temp;
  } else {
    showToast("Count can't be less than 0");
  }
});
document.getElementById("plus1").addEventListener("click", () => {
  count = parseInt(countOne.innerText);
  var temp = count + 1;
  countOne.innerHTML = temp;
});
document.getElementById("plus2").addEventListener("click", () => {
  count = parseInt(countTwo.innerText);
  var temp = count + 1;
  countTwo.innerHTML = temp;
});

const updateAmount = () => {
  var q1 = parseInt(countOne.innerText);
  var q2 = parseInt(countTwo.innerText);
  document.getElementById("cross1").innerHTML = "x" + q1;
  document.getElementById("cross2").innerHTML = "x" + q2;
  document.getElementById("rupee1").innerHTML = "₹" + q1;
  document.getElementById("rupee2").innerHTML = "₹" + q1;
  var total = q1 + q2;
  var tax = 0.2;
  totalPayable = total + tax;
  document.getElementById("totalAmount").innerHTML = "₹ " + total;
  document.getElementById("totalPayable").innerHTML = "₹ " + totalPayable;
};

function uuidv4() {
  return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, (c) =>
    (
      c ^
      (crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (c / 4)))
    ).toString(16)
  );
}
