#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include <DHT.h>
#include <WiFiUdp.h>

// token generation process info.
#include "addons/TokenHelper.h"
// the RTDB helper functions.
#include "addons/RTDBHelper.h"

// WIFI INFO
#define WIFI_SSID "Wifi_Name"
#define WIFI_PASSWORD "Wifi_Password"

#define API_KEY "AIzaSyDgA0NPV3-oko7FMIl_0pPCce62entTUik"

//  user uid (admin get it from the authentication)
#define USER_UID "dRoj7X7ShOYE4bpnZIvqSTSxW2f1"

// real time database link
#define DATABASE_URL "https://auth-app-9678a-default-rtdb.europe-west1.firebasedatabase.app/"

// dht-11 pin (based on the documentaion D7: pin 13)
#define DPIN 13

// ldr analog pin: A0
const int LDR_PIN = A0;

// yl-69 pin: D0
const int soilPin = D0;

// 10 k-ohm resistor
const float R_FIXED = 10000.0;

float calculateLux();
float lux;
int soilHum;

// define Firebase objects
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Variable to save USER UID
String uid;

// Database main path
String databasePath;

// Database temp and hum nodes
String tempPath = "/temperature";
String humPath = "/humidity";
String lumPath = "/luminosity";
String soilPath = "/soil";

FirebaseJson json;

// using the DHT lib declare sensor with type and used pin in the ESP8266:
DHT dht(DPIN, DHT11);

// Send new readings every 10 second
unsigned long sendDataPrevMillis = 0;
unsigned long timerDelay = 10000;

// initialize Wifi
void initWiFi()
{
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi ..");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print('.');
    delay(1000);
  }
  Serial.println(WiFi.localIP());
  Serial.println();
}

void setup()
{
  Serial.begin(9600);

  // initialize DHT sensor
  dht.begin();

  // initialize Soil humidity sensor
  pinMode(soilPin, INPUT);

  initWiFi();

  // Firebase configuration
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  // Token generation and authentication
  config.token_status_callback = tokenStatusCallback;
  auth.user.email = "testclient@gmail.com";
  auth.user.password = "test123";       

  Firebase.reconnectWiFi(true);
  fbdo.setResponseSize(4096);

  // Maximum retry of token generation
  config.max_token_generation_retry = 5;

  // Initialize Firebase library
  Firebase.begin(&config, &auth);

  // Print user UID
  uid = USER_UID;
  Serial.print("User UID: ");
  Serial.println(uid);

  // Update database path
  databasePath = "/UsersData/" + uid + "/readings";
}

void loop()
{ 
  lux = calculateLux();
  int soilValue = digitalRead(soilPin);
  
  Serial.print("Soil Moisture: ");
  if (soilValue == HIGH) {
    soilHum = 0;
  } else {    
    soilHum = 1;
  }

  // Send new readings to database
  if (Firebase.ready() && (millis() - sendDataPrevMillis > timerDelay || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();

    float humidity = dht.readHumidity();
    float temperature = dht.readTemperature();

    json.clear();
    json.set(tempPath.c_str(), String(temperature));
    json.set(humPath.c_str(), String(humidity));
    json.set(lumPath.c_str(), String(lux));
    json.set(soilPath.c_str(), String(soilHum));
    
    Serial.printf("Set json... %s\n", Firebase.RTDB.setJSON(&fbdo, databasePath.c_str(), &json) ? "ok" : fbdo.errorReason().c_str());
  }
  delay(10000);
}

float calculateLux() {
  int adcValue = analogRead(LDR_PIN);
  float voltage = adcValue * (3.3 / 4095.0);
  float R = R_FIXED * ((3.3 / voltage) - 1.0);
  
  float lux = 5000 / (R / 1000);;
  return lux;
}