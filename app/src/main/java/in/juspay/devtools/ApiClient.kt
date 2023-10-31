package `in`.juspay.devtools

import okhttp3.Call
import okhttp3.Callback
import okhttp3.MediaType
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.Response
import org.json.JSONException
import org.json.JSONObject
import java.io.IOException

object ApiClient {
    fun sendGetRequest(url: String, callback: ApiResponseCallback) {
        val client = OkHttpClient()
        val request: Request = Request.Builder()
            .url(url)
            .get()
            .build()
        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                callback.onFailure(e)
            }

            @Throws(IOException::class)
            override fun onResponse(call: Call, response: Response) {
                try {
                    if (response.isSuccessful) {
                        val responseBody = response.body!!.string()
                        callback.onResponseReceived(responseBody)
                    } else {
                        callback.onFailure(Exception("Request failed with code: " + response.code))
                    }
                } catch (e: JSONException) {
                    throw RuntimeException(e)
                }
            }
        })
    }

    fun sendPostRequest(url: String, payload: JSONObject, callback: ApiResponseCallback) {
        val client = OkHttpClient()
        val mediaType = "application/json".toMediaTypeOrNull()
        val requestBody: RequestBody = RequestBody.create(mediaType, payload.toString())
        val request: Request = Request.Builder()
            .url(url)
            .post(requestBody)
            .build()
        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                call.cancel()
                callback.onFailure(e)
            }

            override fun onResponse(call: Call, response: Response) {
                try {
                    if (response.isSuccessful) {
                        val processResponse = response.body!!.string()
                        callback.onResponseReceived(processResponse)
                    } else {
                        callback.onFailure(Exception("Request failed with code: " + response.code))
                    }
                } catch (e: IOException) {
                    e.printStackTrace()
                    callback.onFailure(e)
                } catch (e: JSONException) {
                    e.printStackTrace()
                    callback.onFailure(e)
                } finally {
                    if (response.body != null) {
                        response.body!!.close()
                    }
                }
            }
        })
    }

    interface ApiResponseCallback {
        @Throws(JSONException::class)
        fun onResponseReceived(response: String?)
        fun onFailure(e: Exception?)
    }
}