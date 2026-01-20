var opts = {
  handlers: {
    "exp": function(jwe) {
      // {jwe} is the JWE decrypt output, pre-decryption
      jwe.header.exp = new Date(jwe.header.exp);
    }
  }
};
jose.JWE.createDecrypt(key, opts).
        decrypt(input).
        then(function(result) {
          // ...
        });