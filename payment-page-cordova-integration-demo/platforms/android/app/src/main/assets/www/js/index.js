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
const apiKey = "9E8BE20E66349BCA430C6FAC272B39";
const merchantId = "picasso";
const clientId = "picasso";
var authorization = window.btoa(unescape(encodeURIComponent(apiKey)));
var totalPayable;
const targetDivProducts = document.getElementById("productPage");
const targetDivCheckout = document.getElementById("checkoutPage");
const targetDivReturn = document.getElementById("responsePage");
const showStatus = document.getElementById("statusDiv");
const statusIcon = document.getElementById("status_icon");

function onDeviceReady() {
  hyperSDKRef = cordova.plugins.HyperSDKPlugin;
  console.log("Running cordova-" + cordova.platformId + "@" + cordova.version);
  document.getElementById("deviceready").classList.add("ready");
  //   const authorization = "Basic " + Buffer.from(apiKey + ":").toString("base64");
  console.log(authorization);
  hyperSDKRef.initiate(
    JSON.stringify(createInitiatePayload()),
    hyperSDKCallback
  );
  console.log("Initiated!");
  showToast("Initiate Called on homescreen");

  console.log(screen.height);
}


// const initiateButtonClicked = () => {};

//Function to generate random requestId
function uuidv4() {
  return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, (c) =>
    (
      c ^
      (crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (c / 4)))
    ).toString(16)
  );
}

function createInitiatePayload() {
  return {
    requestId: uuidv4(),
    service: "in.juspay.hyperpay",
    payload: {
      action: "initiate",
      merchantId: "picasso",
      clientId: "picasso",
      environment: "production",
    },
  };
}

//block:end:create-initiate-payload

var hyperSDKCallback = function (response) {
  try {
    const data = JSON.parse(response);
    var event = data.event || "";
    console.log(data)
    SpinnerDialog.hide();

    switch (event) {
      case "show_loader":
        {
          // Show some loader here
          SpinnerDialog.show("Loading...");
        }
        break;
      case "hide_loader":
        {
          // Hide Loader
          SpinnerDialog.hide();
        }
        break;
      case "initiate_result":
        {
          // Get the payload

          let payload = data["payload"];
          console.log("initiate result: ", data);
        }
        break;

      //block:start:handle-process-result

      case "process_result":
        {
          // Get the payload

          let payload = data["payload"];
          console.log("process result: ", data);
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
            //Naivgate to success page
            //block:end:display-payment-status
            showReturnPage();
            showStatus.innerHTML = "Payment Successful!";
            statusIcon.src = "../img/checked-success.png";
            

          } else {
            const errorCode = data.errorCode || "";
            const errorMessage = data.errorMessage || "";
            switch (status) {
              case "backpressed":
                // user back-pressed from PP without initiating any txn
                showStatus.innerHTML = "Payment Failed!";
                showReturnPage();
                break;
              case "user_aborted":
                // user initiated a txn and pressed back
                // poll order status
                // navigate back
                showStatus.innerHTML = "Payment Failed!";
                showReturnPage();
                break;
              case "pending_vbv":
                showStatus.innerHTML = "Payment Status Pending...";
                showReturnPage();
                break; 
              case "authorizing":
                // txn in pending state
                // poll order status until backend says fail or success
                showStatus.innerHTML = "Authorizing...";
                showReturnPage();
                break;
              case "authorization_failed":
                showStatus.innerHTML = "Payment Failed!";
                showReturnPage();
                break;
              case "authentication_failed":
                showStatus.innerHTML = "Payment Failed!";
                showReturnPage();
                break;
              case "api_failure":
                showStatus.innerHTML = "Payment Failed!";
                showReturnPage();
                break;
                // txn failed
                // poll orderStatus to verify (false negatives)
                //block:start:display-payment-status

                //navigate to failure page

                //block:end:display-payment-status
                break;
              case "new":
                // order created but txn failed
                // very rare for V2 (signature based)
                // also failure
                // poll order status

                //navigate to failure page
                showStatus.innerHTML = "Payment Failed!";
                showReturnPage();
                break;
              default:
                showStatus.innerHTML = "Payment Failed!";
                showReturnPage();
                break;
              // unknown status, this is also failure
              // poll order status

              //navigate to failure page
            }
            // if txn was attempted, pi and pig would be non-empty
            // can be used to show in UI if you are into that
            // errorMessage can also be shown in UI
          }
          break;
        }
        break;

      //block:end:handle-process-result

      default:
        //Error handling

        let payload = data;
        console.log("process result: ", payload);
        break;
    }
  } catch (error) {
    //Error handling
    console.log(error);
  }
};

// block:end:create-hyper-callback

document.getElementById("checkoutButton").addEventListener("click", () => {
  //   const event = new Date("27 October 2022 17:48 UTC");
  //   console.log(event.toString());
  //   // expected output: Wed Oct 05 2011 16:48:00 GMT+0200 (CEST)
  //   // (note: your timezone may vary)

  //   console.log(event.toISOString());
  //   // expected output: 2011-10-05T14:48:00.000Z

  //   var processPayload = {
  //       clientId: "picasso",
  //       amount: "10.0",
  //       merchantId: "picasso",
  //       clientAuthToken: "tkn_adbf808e1d2b4d95b41144d0960b5a7e",
  //       clientAuthTokenExpiry: event.toISOString(),
  //       environment: "production",
  //       action: "paymentPage",
  //       customerId: "dummyCustId",
  //       currency: "INR",
  //       customerPhone: "9876543210",
  //       customerEmail: "dummyemail@gmail.com",
  //       orderId: "Test" + Math.floor(Math.random() * 1000000000),
  //   };
  console.log("Process started")
  SpinnerDialog.show(null, "Processing");

  var myHeaders = new Headers();
  myHeaders.append("x-merchantid", "picasso");
  myHeaders.append("Content-Type", "application/json");
  myHeaders.append(
    "Authorization",
    "Basic OUU4QkUyMEU2NjM0OUJDQTQzMEM2RkFDMjcyQjM5Og=="
  );

  var raw = JSON.stringify({
    order_id: "Test" + Math.floor(Math.random() * 1000000000),
    amount: totalPayable,
    customer_id: "testing-customer-onehjcd",
    customer_email: "test@mail.com",
    customer_phone: "9876543210",
    payment_page_client_id: "picasso",
    action: "paymentPage",
    return_url: "https://shop.merchant.com",
    description: "Complete your payment",
    first_name: "John",
    last_name: "wick",
  });

  var requestOptions = {
    method: "POST",
    headers: myHeaders,
    body: raw,
    redirect: "follow",
  };

  fetch("https://sandbox.juspay.in/session", requestOptions)
    .then((response) => response.json())
    .then((result) =>{
      showToast("Process called")
      hyperSDKRef.process(result.sdk_payload);
    } )
    .catch((error) => console.log("error", error));
  // console.log(response);
//  hyperSDKRef.process(processPayload);
  //   console.log("process called!", processPayload);
});


const cartBtn = document.getElementById("cartButton");
const checkoutBtn = document.getElementById("checkoutButton");
targetDivCheckout.style.display = "none";
targetDivReturn.style.display = "none"
cartBtn.onclick = function () {
  targetDivProducts.style.display = "none";
  targetDivCheckout.style.display = "block"
  updateAmount();
  document.getElementById("checkoutPage").scrollIntoView();
}
checkoutBtn.onclick = function () {
  targetDivProducts.style.display = "none";
  targetDivCheckout.style.display = "block"
  document.getElementById("productPage").scrollIntoView();
}

const showReturnPage = () => {
  targetDivProducts.style.display = "none";
  targetDivCheckout.style.display = "none"
  targetDivReturn.style.display = "block"
}

function showToast(showMessage) {
  window.plugins.toast.showWithOptions(
    {
      message: showMessage,
      duration: "short", // which is 2000 ms. "long" is 4000. Or specify the nr of ms yourself.
      position: "bottom",
      addPixelsY: -40  // added a negative value to move it up a bit (default 0)
    }
  );
}

function hide() {
  // this function takes an optional success callback, but you can do without just as well
  window.plugins.toast.hide();
}

document.getElementById("checkout_back").addEventListener("click", () => {
  targetDivProducts.style.display = "block";
  targetDivCheckout.style.display = "none"
  targetDivReturn.style.display = "none"
})
document.getElementById("response_back").addEventListener("click", () => {
  targetDivProducts.style.display = "block";
  targetDivCheckout.style.display = "none"
  targetDivReturn.style.display = "none"
})
document.getElementById("response_okay").addEventListener("click", () => {
  targetDivProducts.style.display = "block";
  targetDivCheckout.style.display = "none"
  targetDivReturn.style.display = "none"
})
const countOne = document.getElementById("count1");
const countTwo = document.getElementById("count2");

document.getElementById("minus1").addEventListener("click", () => {
  count = parseInt(countOne.innerText);
  if(count>0){
    var temp =  count - 1;
    countOne.innerHTML = temp
  } else {
    showToast("Count can't be less than 0");
  }

})
document.getElementById("minus2").addEventListener("click", () => {
  count = parseInt(countTwo.innerText);
  if(count>0){
    var temp = count-1;
    countTwo.innerHTML = temp
  } else {
    showToast("Count can't be less than 0");
  }
})
document.getElementById("plus1").addEventListener("click", () => {
  count = parseInt(countOne.innerText);
  var temp = count+1;
  countOne.innerHTML = temp
})
document.getElementById("plus2").addEventListener("click", () => {
  count = parseInt(countTwo.innerText);
  var temp = count+1;
  countTwo.innerHTML = temp
})

const updateAmount = () => {
  var q1 = parseInt(countOne.innerText);
  var q2 = parseInt(countTwo.innerText);
  document.getElementById("cross1").innerHTML = "x"+ q1;
  document.getElementById("cross2").innerHTML = "x"+ q2;
  document.getElementById("rupee1").innerHTML = "₹"+ q1;
  document.getElementById("rupee2").innerHTML = "₹"+ q1;
  var total = q1+q2;
  var tax = 0.2;
  totalPayable = total + tax
  document.getElementById("totalAmount").innerHTML = "₹ "+ total;
  document.getElementById("totalPayable").innerHTML = "₹ "+ totalPayable;


}
