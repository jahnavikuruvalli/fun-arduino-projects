import processing.serial.*;
Serial myPort;
String angle = "";
String distance = "";
String data = "";
int iAngle, iDistance;

void setup() {
  size(800, 600);
  smooth();
  myPort = new Serial(this, Serial.list()[4], 9600);
  myPort.bufferUntil('.');
  println(Serial.list());
}

void draw() {
  // Fade effect instead of hard background clear
  fill(0, 0, 0, 40);         // semi-transparent black
  noStroke();
  rect(0, 0, width, height); // covers full window before translate

  translate(width / 2, height);

  // Draw radar rings (semicircles only)
  stroke(0, 255, 0);
  strokeWeight(2);
  noFill();
  arc(0, 0, 200, 200, PI, TWO_PI);
  arc(0, 0, 400, 400, PI, TWO_PI);
  arc(0, 0, 600, 600, PI, TWO_PI);

  // Draw center baseline
  line(-300, 0, 300, 0);

  // Draw sweep beam
  stroke(0, 255, 0);
  strokeWeight(3);
  float beamX = 300 * cos(radians(iAngle));
  float beamY = -300 * sin(radians(iAngle));
  line(0, 0, beamX, beamY);

  // Draw detection dot
  if (iDistance > 0 && iDistance < 100) {
    float objX = iDistance * 3 * cos(radians(iAngle));
    float objY = -iDistance * 3 * sin(radians(iAngle));
    fill(255, 0, 0);
    noStroke();
    ellipse(objX, objY, 12, 12);
  }
}

void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data == null) return;                        // guard against null
  data = trim(data);                               // strip whitespace/newlines
  data = data.replace(".", "");                    // remove trailing dot if any

  int index = data.indexOf(",");
  if (index == -1) return;                         // guard against bad parse

  angle    = data.substring(0, index);
  distance = data.substring(index + 1);

  iAngle    = int(trim(angle));
  iDistance = int(trim(distance));

  println("Angle: " + iAngle + " | Distance: " + iDistance);
}
