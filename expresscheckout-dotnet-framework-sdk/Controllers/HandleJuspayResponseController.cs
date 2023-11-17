using Juspay;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Mvc;

namespace DotnetServer.Controllers
{
    public class HandleJuspayResponse
    {
        [JsonProperty("amount")]
        public string Amount { get; set; }

        [JsonProperty("order_id")]
        public string Order_id { get; set; }
    }
    public class HandleJuspayResponseController : Controller
    {
        // block:start:order-status-function
        public async Task<JuspayResponse> getOrderStatus(string orderId)
        {
            string customerId = "testing-customer-one";
            RequestOptions requestOptions = new RequestOptions { CustomerId = customerId };
            return await new Order().GetAsync(orderId, null, requestOptions);
        }
        // block:end:order-status-function
        public string orderStatusMessage(JuspayResponse orderRes)
        {
            Dictionary<string, string> response = new Dictionary<string, string> { { "order_id", (string)orderRes.Response.order_id } };
            switch ((string)orderRes.Response.status)
            {
                case "CHARGED":
                    response["message"] = "order payment done successfully";
                    break;
                case "PENDING":
                case "PENDING_VBV":
                    response["message"] = "order payment pending";
                    break;
                case "AUTHENTICATION_FAILED":
                    response["message"] = "authentication failed";
                    break;
                case "AUTHORIZATION_FAILED":
                    response["message"] = "order payment authorization failed";
                    break;
                default:
                    response["message"] = $"order status {orderRes.Response.status}";
                    break;
            }
            response["status"] = $"{orderRes.Response.status}";
            return JsonConvert.SerializeObject(response);
        }

        [System.Web.Mvc.Route("handleJuspayResponse")]
        [System.Web.Mvc.HttpGet]
        public async Task<ActionResult> Get()
        {
            string orderId = HttpContext.Request.QueryString["order_id"];
            if (string.IsNullOrEmpty(orderId))
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest, "order_id is missing in query params");
            }

            try
            {
                return new ContentResult
                {
                    ContentType = "application/json",
                    Content = orderStatusMessage(await getOrderStatus(orderId))
                };
            }
            catch (HttpRequestException)
            {
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls;
                try
                {
                    return new ContentResult
                    {
                        ContentType = "application/json",
                        Content = orderStatusMessage(await getOrderStatus(orderId))
                    };
                }
                catch(HttpRequestException ex)
                {
                    return new HttpStatusCodeResult(HttpStatusCode.OK, ex.InnerException.Message);
                }
            }
        }

        [System.Web.Mvc.Route("handleJuspayResponse")]
        [System.Web.Mvc.HttpPost]
        public async Task<ActionResult> Post()
        {
            string orderId = HttpContext.Request.Form["order_id"];
            if (string.IsNullOrEmpty(orderId))
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest, "order_id is missing");
            }
            try
            {
                return new ContentResult
                {
                    ContentType = "application/json",
                    Content = orderStatusMessage(await getOrderStatus(orderId))
                };
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
    }
}
