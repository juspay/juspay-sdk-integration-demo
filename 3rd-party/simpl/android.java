allprojects {
    repositories {
        google()
        jcenter()
        maven {
          url "https://sdk.getsimpl.com/"
       }
    }
}

dependencies {  
    implementation "com.simpl.android:fingerprintSDK:1.1.4"
}