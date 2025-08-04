allprojects {
    repositories {
        google()
        jcenter()
        maven {
          url "https://maven.getsimpl.com/"
       }
    }
}

dependencies {  
    implementation "com.simpl.android:fingerprintSDK:1.1.6"
}
