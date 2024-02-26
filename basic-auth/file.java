ok
import java.util.Base64; String apiKey = "your_api_key"; String authorization = "Basic " + Base64.getEncoder().encodeToString((apiKey + ":").getBytes());