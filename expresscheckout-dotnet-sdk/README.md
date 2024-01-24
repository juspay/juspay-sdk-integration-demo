# How to run server
- update configuration in config.json file
- run ```dotnet run -f <framework>``` to run the server
- In browser load the website (localhost:5000)
- Option for -f net7.0,net6.0, netcoreapp3.1, netcoreapp3.0 and net5.0

# Curl for GET /handleJuspayResponse.php
```
curl --location 'localhost:5000/handleJuspayResponse?order_id=<order_id>'
```
