package in.juspay.devtools;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import in.juspay.devtools.databinding.ActivityWebViewBinding;
import in.juspay.hyper.webview.upi.HyperWebViewServices;

public class WebViewActivity extends AppCompatActivity {
    private ActivityWebViewBinding binding;
    private String webviewUrl = "";
    private String return_url = "";
    private HyperWebViewServices hyperWebViewServices;

    @SuppressLint("SetJavaScriptEnabled")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityWebViewBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        webviewUrl = getIntent().getStringExtra("url") != null ? getIntent().getStringExtra("url") : "";

        return_url = getIntent().getStringExtra("return_url") != null ? getIntent().getStringExtra("return_url") : "";

        WebView webView = binding.webview;
        hyperWebViewServices = new HyperWebViewServices(this, webView);
        hyperWebViewServices.attach();
        webView.loadUrl(webviewUrl);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setDomStorageEnabled(true);
        webView.setWebViewClient(myWebViewClient);
    }

    private final WebViewClient myWebViewClient = new WebViewClient() {
        @Override
        public void onPageCommitVisible(WebView view, String url) {
            super.onPageCommitVisible(view, url);
            Toast.makeText(WebViewActivity.this, "URL Loaded!!!", Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            if (url.contains("v2/pay/finish")) {
                setResult(RESULT_OK);
                finish();
            }
        }
    };

    @Deprecated
    @Override
    public void onBackPressed() {
        WebView webView = binding.webview;
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            webView.destroy();
            super.onBackPressed();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == HyperWebViewServices.UPI_REQUEST_CODE) {
            hyperWebViewServices.onActivityResult(requestCode, resultCode, data);
        }
    }
}
