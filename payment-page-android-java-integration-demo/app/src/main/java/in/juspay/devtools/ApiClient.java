package in.juspay.devtools;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class ApiClient {
    public interface ApiResponseCallback {
        void onResponseReceived(String response) throws JSONException;
        void onFailure(Exception e);
    }

    public static void sendGetRequest(String url, final ApiResponseCallback callback) {
        OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder()
                .url(url)
                .get()
                .build();

        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                callback.onFailure(e);
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                try {
                    if (response.isSuccessful()) {
                        String responseBody = response.body().string();
                        callback.onResponseReceived(responseBody);

                    } else {
                        callback.onFailure(new Exception("Request failed with code: " + response.code()));
                    }
                }

                 catch (JSONException e) {
                    throw new RuntimeException(e);
                }
            }
        });
    }

    public static void sendPostRequest(String url, JSONObject payload, final ApiResponseCallback callback) {
        OkHttpClient client = new OkHttpClient();
        MediaType mediaType = MediaType.parse("application/json");
        RequestBody requestBody = RequestBody.create(payload.toString(), mediaType);
        Request request = new Request.Builder()
                .url(url)
                .post(requestBody)
                .build();

        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                call.cancel();
                callback.onFailure(e);
            }

            @Override
            public void onResponse(Call call, Response response) {
                try {
                    if (response.isSuccessful()) {
                        String processResponse = response.body().string();
                        callback.onResponseReceived(processResponse);
                    } else {
                        callback.onFailure(new Exception("Request failed with code: " + response.code()));
                    }
                } catch (IOException | JSONException e) {
                    e.printStackTrace();
                    callback.onFailure(e);
                } finally {
                    if (response.body() != null) {
                        response.body().close();
                    }
                }
            }
        });
    }
}

