var opts = {
  handlers: {
    "exp": {
      complete: function(jwe) {
        // {jwe} is the JWE decrypt output, post-decryption
        jwe.header.exp = new Date(jwe.header.exp);
      }
    }
  }
};
jose.JWE.createDecrypt(key, opts).
        decrypt(input).
        then(function(result) {
          // ...
        });