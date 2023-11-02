# Juspay Sample App
Sample app for juspay java integration using expresscheckout-java-sdk

# Prerequisites
- Java sdk >= 8
- Maven
- JAVA_HOME path configured

# Setup Configurations
Place your config.json file in src/main/resources folder. Here's the sample for config.json file.
```json
{
  "MERCHANT_ID":"YOUR_MERCHANT_ID",
  "PRIVATE_KEY_PATH":"~/Desktop/JuspayBackendKit/src/main/resources/private-key.pem",
  "PUBLIC_KEY_PATH":"~/Desktop/JuspayBackendKit/src/main/resources/public-key.pem",
  "KEY_UUID":"YOUR_KEY_UUID",
  "PAYMENT_PAGE_CLIENT_ID": "YOUR_PAYMENT_PAGE_CLIENT_ID"
}
```
You can skip giving `PUBLIC_KEY_PATH` and `PRIVATE_KEY_PATH` and add `private-key.pem` and `public-key.pem` inside resources' folder.
Note:- key file path has to be absolute.

## Run Application
The app is made using Servlets. Hence, multiple ways to run the application.

### Quick run using `setup.sh`
```bash
chmod +x ./setup.sh
./setup.sh
```

### Quick run using jetty
```bash
mvn clean install
mvn clean package
mvn jetty:run
```

# Want to add inside your own project (Servlet based project)
Please find `in.juspaybackendkit` package and copy it to your own setup. Now that we have added skd code in the project we'll configure web.xml
Add this in your web.xml file. It may defer depending upon your own setup.

```xml
<listener>
        <listener-class>in.juspaybackendkit.JuspayConfig</listener-class>
</listener>
<servlet>
    <servlet-name>InitiateJuspayPayment</servlet-name>
    <servlet-class>in.juspaybackendkit.InitiateJuspayPayment</servlet-class>
</servlet>
<servlet>
    <servlet-name>HandleJuspayResponse</servlet-name>
    <servlet-class>in.juspaybackendkit.HandleJuspayResponse</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>InitiateJuspayPayment</servlet-name>
    <url-pattern>/initiateJuspayPayment</url-pattern>
</servlet-mapping>
<servlet-mapping>
    <servlet-name>HandleJuspayResponse</servlet-name>
    <url-pattern>/handleJuspayResponse</url-pattern>
</servlet-mapping>
```

Add dependencies to your project.

```xml
<dependency>
  <groupId>in.juspay</groupId>
  <artifactId>expresscheckout</artifactId>
  <version>1.3.3</version>
</dependency>
<dependency>
  <groupId>javax.xml.bind</groupId>
  <artifactId>jaxb-api</artifactId>
  <version>2.4.0-b180830.0359</version>
</dependency>
```