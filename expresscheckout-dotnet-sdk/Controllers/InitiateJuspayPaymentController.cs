using Microsoft.AspNetCore.Mvc;
using Juspay;
using Newtonsoft.Json;
using System.Collections.Generic;
using System;

namespace dotnet_server.Controllers {
    public class InitiateJuspayPaymentRequest
    {
        [JsonProperty("amount")]
        public string Amount { get; set; }

        [JsonProperty("order_id")]
        public string Order_id { get; set; }
    }

    [ApiController]
    [Route("[controller]")]
    public class InitiateJuspayPaymentController : Controller
    {

        [HttpPost]
        public IActionResult Post([FromBody] InitiateJuspayPaymentRequest req)
        {
            try
            {
                if (req == null)
                {
                    return BadRequest();
                }
                // block:start:session-function
                string orderId = string.IsNullOrEmpty(req.Order_id) ? $"{new Random().Next()}" : req.Order_id;
                string customerId = "testing-customer-one";
                RequestOptions requestOptions = new RequestOptions{ CustomerId = customerId };
                CreateOrderSessionInput createOrderSessionInput = new CreateOrderSessionInput(new Dictionary<string, object>{{ "amount", req.Amount }, { "order_id",  orderId}, { "customer_id", customerId }, { "payment_page_client_id", Init.Config.PaymentPageClientId }, { "action", "paymentPage" }, { "return_url", "http://localhost:5000/handleJuspayResponse" } });
                JuspayResponse sessionRes = new SessionService().CreateOrderSession(createOrderSessionInput, requestOptions);
                Dictionary<string, object> res = new Dictionary<string, object> {
                    { "orderId", sessionRes.Response.order_id },
                    { "id", sessionRes.Response.id },
                    { "status", sessionRes.Response.status },
                    { "paymentLinks", sessionRes.Response.payment_links },
                    { "sdkPayload", sessionRes.Response.sdk_payload },
                };
                // block:end:session-function
                if (sessionRes.Response.status == "NEW")
                {
                    return new ContentResult
                    {
                        ContentType = "application/json",
                        Content = JsonConvert.SerializeObject(res)
                    };
                }
                else {
                    throw new Exception($"invalid session status: {sessionRes.Response.status} ");
                }
            }
            catch (Exception ex)
            {

                Console.WriteLine(ex);
                return StatusCode(500, ex.Message);
            }
        }


    }

}
