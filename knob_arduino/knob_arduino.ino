/*
 * Need to output two things from the Arduino:
 * 1 - value from left pot, in range of 0-255
 * 2 - value from right pot (up / down, button press)
 */

//rotary setup 
#define CLK 2
#define DT 3
#define SW 4

int counter = 0;
int currentStateCLR;
int lastStateCLK;
int currentDir = 0; 
int butCyc = 0; //to 4
unsigned long lastButtonPress = 0; 

int potVal = 0; 

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600); 
  pinMode(CLK,INPUT);
  pinMode(DT, INPUT);
  pinMode(SW, INPUT_PULLUP);

  lastStateCLK = digitalRead(CLK); 
}

void loop() {
  // put your main code here, to run repeatedly:
  potVal = analogRead(A0); 

  int currentStateCLK = digitalRead(CLK); 
  if (currentStateCLK != lastStateCLK && currentStateCLK == 1){

    //CCW, decrement
    if (digitalRead(DT) != currentStateCLK) {
      if (counter != 0){ 
        counter --;
      }
      currentDir = 1;
    } else {
      if (counter == 127){
        return;
      }
      counter ++;
      counter = counter % 128; 
      currentDir = 2; 
    }

  }
  lastStateCLK = currentStateCLK;
  int btnState = digitalRead(SW); 
  if(btnState == LOW){
    if (millis() - lastButtonPress > 50) {
      butCyc = (butCyc + 1) % 3; 
    }

    lastButtonPress = millis();
  }
  //the array being sent to SC 
  Serial.print(potVal); 
  Serial.print("a"); 
  Serial.print(butCyc);
  Serial.print("b");
  Serial.print(counter);
  Serial.println("c");  
  delay(10);
}
