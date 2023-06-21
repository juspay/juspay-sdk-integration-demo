const crypto = require('crypto');

function verify_hmac(params, secret) {

  var paramsList = [];
  for (var key in params) {
    if (key != 'signature' && key != 'signature_algorithm') {
      paramsList[key] = params[key];
    }
  }

  paramsList = sortObjectByKeys(paramsList);

  var paramsString = '';
  for (var key in paramsList) {
    paramsString = paramsString + key + '=' + paramsList[key] + '&';
  }

  let encodedParams = encodeURIComponent(paramsString.substring(0, paramsString.length - 1));
  let computedHmac = crypto.createHmac('sha256', secret).update(encodedParams).digest('base64');
  let receivedHmac = decodeURIComponent(params.signature);

  console.log("computedHmac :", computedHmac)
  console.log("receivedHmac :", receivedHmac)

  return decodeURIComponent(computedHmac) == receivedHmac;
}

function sortObjectByKeys(o) {
  return Object.keys(o)
    .sort()
    .reduce((r, k) => ((r[k] = o[k]), r), {});
}

console.log(verify_hmac({"status_id":"21","status":"CHARGED","order_id":"**6**3**","signature":"******crdU/AW8BkpqnMHK2********TE=","signature_algorithm":"HMAC-SHA256"},{{Response Key}}))