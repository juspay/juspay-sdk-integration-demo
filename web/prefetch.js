const payload = {
	"requestId" : "8cbc3fad-8b3f-40c0-ae93-2d7e75a8624a", //UUID v4 String
	"service" : "in.juspay.hyperpay",
	"payload"  : { 
        "clientId" : "<Client Id>"
  	}
}
window.HyperServices.preFetch(payload)