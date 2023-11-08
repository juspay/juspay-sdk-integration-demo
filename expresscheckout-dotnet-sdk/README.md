# How to run server
- update configuration in config.json file
- run ```dotnet run``` to run the server
- In browser load the website (localhost:5000)

# Curl for GET /handleJuspayResponse.php
```
curl --location 'localhost:5000/handleJuspayResponse?order_id=<order_id>'
```