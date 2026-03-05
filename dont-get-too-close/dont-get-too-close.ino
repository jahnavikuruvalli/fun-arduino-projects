#include <Servo.h>

Servo radarServo;

const int trigPin = 10;
const int echoPin = 11;
const int buzzerPin = 8;        // ADD: buzzer pin

const int TOO_CLOSE_CM = 30;    // ADD: beep threshold

long duration;
int distance;

void setup()
{
  radarServo.attach(9);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buzzerPin, OUTPUT);   // ADD: buzzer pinMode

  Serial.begin(9600);
}

void loop()
{
  for(int angle = 0; angle <= 180; angle++)
  {
    radarServo.write(angle);
    delay(20);
    distance = getDistance();

    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.println(".");

    handleBuzzer(distance);     // ADD: buzzer call
  }

  for(int angle = 180; angle >= 0; angle--)
  {
    radarServo.write(angle);
    delay(20);
    distance = getDistance();

    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.println(".");

    handleBuzzer(distance);     // ADD: buzzer call
  }
}

// ADD: entire function
void handleBuzzer(int dist)
{
  if (dist > 0 && dist < TOO_CLOSE_CM)
  {
    int freq = map(dist, 1, TOO_CLOSE_CM, 2000, 500);
    tone(buzzerPin, freq, 15);
  }
  else
  {
    noTone(buzzerPin);
  }
}

int getDistance()
{
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;

  return distance;
}
