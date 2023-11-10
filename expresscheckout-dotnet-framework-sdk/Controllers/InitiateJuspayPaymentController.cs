using Juspay;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace DotnetServer.Controllers
{
    public class InitiateJuspayPaymentRequest
    {
        public string Amount { get; set; }
        public string Order_id { get; set; }

    }
    public class InitiateJuspayPaymentController : Controller
    {

        [System.Web.Mvc.Route("initiateJuspayPayment")]
        [System.Web.Mvc.HttpPost]
        public async Task<ActionResult> Post([FromBody] InitiateJuspayPaymentRequest req)
        {

            if (req.Amount == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            string orderId = string.IsNullOrEmpty(req.Order_id) ? $"{new Random().Next()}" : req.Order_id;
            string customerId = "testing-customer-one";
            RequestOptions requestOptions = new RequestOptions { CustomerId = customerId };
            CreateOrderSessionInput createOrderSessionInput = new CreateOrderSessionInput(new Dictionary<string, object> { { "amount", req.Amount }, { "order_id", orderId }, { "customer_id", customerId }, { "payment_page_client_id", Init.Config.PaymentPageClientId }, { "action", "paymentPage" }, { "return_url", "http://localhost:5000/handleJuspayResponse" }, { "metadata.GOCASHFREE:gateway_reference_id", "V3Cashfree" } });
            try
            {
                JuspayResponse sessionRes = await new SessionService().CreateOrderSessionAsync(createOrderSessionInput, requestOptions);
                Dictionary<string, object> res = new Dictionary<string, object> {
                    { "orderId", sessionRes.Response.order_id },
                    { "id", sessionRes.Response.id },
                    { "status", sessionRes.Response.status },
                    { "paymentLinks", sessionRes.Response.payment_links },
                    { "sdkPayload", sessionRes.Response.sdk_payload },
                };
                if (sessionRes.Response.status == "NEW")
                {
                    return new ContentResult
                    {
                        Content = JsonConvert.SerializeObject(res),
                        ContentType = "application/json"
                    };
                }
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError, $"invalid session status: {sessionRes.Response.status}");
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError, ex.Message);
            }

        }
    }
}
