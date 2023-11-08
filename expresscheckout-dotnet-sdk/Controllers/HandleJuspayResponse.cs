using Microsoft.AspNetCore.Mvc;
using Juspay;
using Newtonsoft.Json;
using System.Collections.Generic;
using System;

namespace dotnet_server.Controllers
{
    public class HandleJuspayResponse
    {
        [JsonProperty("amount")]
        public string Amount { get; set; }

        [JsonProperty("order_id")]
        public string Order_id { get; set; }
    }

    [ApiController]
    [Route("[controller]")]
    public class HandleJuspayResponseController : Controller
    {

        public JuspayResponse getOrderStatus (string orderId)
        {
            string customerId = "testing-customer-one";
            RequestOptions requestOptions = new RequestOptions{ CustomerId = customerId, MerchantId =  JuspayEnvironment.MerchantId };
            return new OrderService().GetOrder(orderId, null, requestOptions);
        }
        public string orderStatusMessage(JuspayResponse orderRes)
        {
        Dictionary<string, string> response = new Dictionary<string, string> { { "order_id", (string) orderRes.Response.order_id }};
        switch ((string)orderRes.Response.status) {
            case "CHARGED":
                response["message"] = "order payment done successfully";
                break;
            case "PENDING":
            case "PENDING_VBV":
                response["message"] =  "order payment pending";
                break;
            case "AUTHENTICATION_FAILED":
                response["message"] =  "authentication failed";
                break;
            case "AUTHORIZATION_FAILED":
                response["message"] =  "order payment authorization failed";
                break;
            default:
                response["message"] =  $"order status {orderRes.Response.status}";
                break;
        }
            response["status"] = $"{orderRes.Response.status}";
            return JsonConvert.SerializeObject(response);
        }

        [HttpGet]
        public IActionResult Get()
        {

            string orderId = HttpContext.Request.Query["order_id"];
            if (string.IsNullOrEmpty(orderId))
            {
                return BadRequest();
            }
        
            return new ContentResult
            {
                ContentType = "application/json",
                Content = orderStatusMessage(getOrderStatus(orderId))
            };
        }

        [HttpPost]
        public IActionResult Post()
        {
            try
            {
                string orderId = HttpContext.Request.Form["order_id"];
                if (string.IsNullOrEmpty(orderId))
                {
                    return BadRequest();
                }
                return new ContentResult
                {
                    ContentType = "application/json",
                    Content = orderStatusMessage(getOrderStatus(orderId)),
                };
            }
            catch (Exception ex)
            {

                Console.WriteLine(ex);
                return StatusCode(500, ex.Message);
            }
        }


    }

}

