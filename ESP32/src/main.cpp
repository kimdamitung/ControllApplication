#include <Arduino.h>
#include <Adafruit_GFX.h>
#include <Adafruit_ST7735.h>
#include <WebServer.h>
#include <SPI.h>
#include <WiFi.h>
#include <Wire.h>
#include <qrcode_st7735.h>

#define TIMEOUT_MS 		10000
#define TFTMODEL 		INITR_18BLACKTAB
#define TFT_CS 			5
#define TFT_DC			26
#define TFT_RST 		25
#define MAX_LENGTH		30
#define MAX_KEYS		4
#define GPIO_OUT_LED	16
#define ADDRESS_PCF		0x20

char keyboard[MAX_KEYS][MAX_KEYS] = {
	{'1', '2', '3', '4'},
	{'5', '6', '7', '8'},
	{'9', 'L', 'a', 'u'},
	{'_', 'A', 'N', 'E'}
};
char wifiSsid[MAX_LENGTH + 1] = "";
char wifiPass[MAX_LENGTH + 1] = "";
long long unsigned int QRCode_IP;
uint8_t cursorPosition = 0; /*0: Name Wifi; 1: Pass Wifi; 2: Connect*/
uint8_t ssidLength = 0;
uint8_t passLength = 0;
bool isWifiConnected = false;

Adafruit_ST7735 display = Adafruit_ST7735(TFT_CS, TFT_DC, TFT_RST);
QRcode_ST7735 qrcode(&display);
WebServer server(80);

void _handle_ConnectWifi(const char *ssid, const char *pass);
String _handle_ConvertIP(long long unsigned int ip);
void _handle_ShowQRCode();
void _handle_RootServer();
void _handle_WritePCF8575(uint16_t value);
uint16_t _handle_ReadPCF8575();
char _handle_ScanKeyBoard();
void _handle_UpdateDisplay();
void _handle_SuccessConnect(const char *ssid, const char *pass);
void _handle_ScanAddress();
void _task_RunServer(void *parameter);
void _task_RunDisplay(void *parameter);

void setup(){
	pinMode(GPIO_OUT_LED, OUTPUT);
	digitalWrite(GPIO_OUT_LED, LOW);
	Serial.begin(115200);
	Wire.begin();
	_handle_ScanAddress();
	_handle_WritePCF8575(0xFFFF);
    display.initR(TFTMODEL);
    display.fillScreen(ST77XX_WHITE);
    display.setTextColor(ST77XX_BLACK);
    display.setTextSize(2);
    display.setCursor(42, 5);
    display.println("WIFI");
    display.setTextSize(1.9);
    display.setCursor(10, 40);
    display.println("Name Wifi");
    display.setTextSize(1.9);
    display.setCursor(10, 80);
    display.println("Password");
    _handle_UpdateDisplay();
    xTaskCreatePinnedToCore(_task_RunServer, "Task Server", 10000, NULL, 1, NULL, 0);
    xTaskCreatePinnedToCore(_task_RunDisplay, "Task Display", 10000, NULL, 1, NULL, 0);
}

void loop(){
	/* code */
}

void _handle_ConnectWifi(const char *ssid, const char *pass){
	Serial.print("\nConnecting to Wifi");
	WiFi.begin(ssid, pass);
	unsigned long startTime = millis();
	while(WiFi.status() != WL_CONNECTED && millis() - startTime < TIMEOUT_MS){
		Serial.print(".");
		delay(100);
	}
	if(WiFi.status() != WL_CONNECTED)
		Serial.println("Failed!!!");
	else{
        Serial.println("\nConnected SUCCES (^-^)");
        Serial.print("IP: ");
        Serial.println(WiFi.localIP());
        QRCode_IP = WiFi.localIP();
        Serial.println(QRCode_IP);
        isWifiConnected = true;
    }
}

String _handle_ConvertIP(long long unsigned int ip){
	String result;
	for(int i = 0; i  < 4; i++){
		result += String((ip >> (i * 8)) & 0xFF);
		if(i < 3)
			result += ".";
	}
	return result;
}

void _handle_ShowQRCode(){
	qrcode.debug();
	display.initR(TFTMODEL);
	Serial.println(_handle_ConvertIP(QRCode_IP));
	qrcode.init();
	qrcode.create("http://" + _handle_ConvertIP(QRCode_IP) + ":80");
}

void _handle_RootServer(){
	if(server.hasArg("cmd")){
		String cmd = server.arg("cmd");
		if(cmd == "CHECK"){
			server.send(200, "text/plain", "CHECK CONNECT SUCCESS");
		}else if(cmd == "LED_0_OFF"){
			digitalWrite(GPIO_OUT_LED, LOW); 
            server.send(200, "text/plain", "LED is OFF");
		}else if(cmd == "LED_0_ON"){
			digitalWrite(GPIO_OUT_LED, HIGH); 
            server.send(200, "text/plain", "LED is ON");
		}else{
			server.send(400, "text/plain", "Invalid command");
		}
	}else{
		server.send(400, "text/plain", "Missing command");
	}
}

void _handle_WritePCF8575(uint16_t value){
	Wire.beginTransmission(ADDRESS_PCF);
	Wire.write(value & 0xFF);
	Wire.write((value >> 8) & 0xFF);
	Wire.endTransmission();
}

uint16_t _handle_ReadPCF8575(){
	Wire.requestFrom(ADDRESS_PCF, 2);
	uint16_t value = Wire.read();
	value |= (Wire.read() << 8);
	return value;
}

char _handle_ScanKeyBoard(){
	uint16_t arrays[] = {0xFFFE, 0xFFFD, 0xFFFB, 0xFFF7};
	uint16_t readValue;
	for(uint8_t colNum = 0; colNum < MAX_KEYS; colNum++){
		_handle_WritePCF8575(arrays[colNum]);
		readValue = _handle_ReadPCF8575();
		for(uint8_t rowNum = 0; rowNum < MAX_KEYS; rowNum++){
			if (!(readValue & (1 << (rowNum + 4)))){
				/* code */
				_handle_WritePCF8575(0xFFFF);
				return keyboard[rowNum][colNum];
			}
		}
	}
	_handle_WritePCF8575(0xFFFF);
	return '\0';
}	

void _handle_UpdateDisplay(){
	if(!isWifiConnected){
		// wifiname
        display.fillRect(10, 50, 100, 20, ST77XX_WHITE);
        display.drawRect(10, 50, 100, 20, (cursorPosition == 0) ? ST77XX_BLUE : ST77XX_BLACK);
        display.setTextColor(ST77XX_BLACK);
        display.setTextSize(1.9);
        display.setCursor(10 + 2, 50 + 2);
        display.println(wifiSsid);
        // wifipassword
        display.fillRect(10, 90, 100, 20, ST77XX_WHITE);
        display.drawRect(10, 90, 100, 20, (cursorPosition == 1) ? ST77XX_BLUE : ST77XX_BLACK);
        display.setTextColor(ST77XX_BLACK);
        display.setTextSize(1.9);
        display.setCursor(10 + 2, 90 + 2);
        display.println(wifiPass);
        // button connect
        display.fillRect(60, 125, 50, 18, (cursorPosition == 2) ? ST77XX_BLUE : ST77XX_BLACK);
        display.drawRect(60, 125, 50, 18, ST77XX_BLACK);
        display.setTextColor((cursorPosition == 2) ? ST77XX_WHITE : ST77XX_WHITE);
        display.setCursor(65, 130);
        display.println("CONNECT");
	}
}

void _handle_SuccessConnect(const char *ssid, const char *pass){
	_handle_ConnectWifi(ssid, pass);
	if(isWifiConnected){
		_handle_ShowQRCode();
		server.on("/", _handle_RootServer);
    	server.begin();
	}
}

void _handle_ScanAddress(){
	Serial.println("Scanning devices I2C...");
	for(uint8_t address = 0x20; address <= 0x27; address++){
		Wire.beginTransmission(address);
        byte error = Wire.endTransmission();
        if(error == 0){
        	Serial.print("The I2C device is found at address 0x");
        	if(address < 16)
        		Serial.print("0");
        	Serial.println(address, HEX);
        }else{
        	Serial.print("Unable to connect to I2C device at address 0x");
        	if(address < 16)
        		Serial.print("0");
        	Serial.println(address, HEX);
        }
        delay(100);
	}
	Serial.println("Address scanning completed.");
}

void _task_RunServer(void *parameter){
	while(true){
		server.handleClient();
		delay(10);
	}
}

void _task_RunDisplay(void *parameter){
	while(true){
		char keys = _handle_ScanKeyBoard();
		if(keys != '\0'){
			Serial.print(keys);
			if(keys == 'N'){
				cursorPosition = (cursorPosition + 1) % 3;
			}else if(keys == 'E' && cursorPosition == 2){
				_handle_SuccessConnect(wifiSsid, wifiPass);
			}else if(keys == 'X'){
				if(cursorPosition == 0 && ssidLength > 0)
					wifiSsid[--ssidLength] = '\0';
				else if(cursorPosition == 1 && passLength > 0)
					wifiPass[--passLength] = '\0';
			}else if(keys == 'R'){
				ESP.restart();
			}else{
				if(cursorPosition == 0 && ssidLength < MAX_LENGTH){
					wifiSsid[ssidLength++] = keys;
					wifiSsid[ssidLength] = '\0';
				}else if(cursorPosition == 1 && passLength < MAX_LENGTH){
					wifiPass[passLength++] = keys;
					wifiPass[passLength] = '\0';
				}
			}
			_handle_UpdateDisplay();
			delay(200);
		}
	}
}