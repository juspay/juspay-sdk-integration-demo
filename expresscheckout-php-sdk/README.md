# Setup script
- run ```php setup.php``` to install all system dependency

# How to run server
- update configuration in config.json file
- run ```composer run_server``` to run the server
- In browser load the website (localhost:5000)

# How to run standalone service
- update configuration in config.json file
- run ```composer run_app```

# Curl for GET /handleJuspayResponse.php
```
curl --location 'localhost:5000/handleJuspayResponse?order_id=<order_id>'
```