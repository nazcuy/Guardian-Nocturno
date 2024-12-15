const int pinTrig = 2;
const int pinEcho = 3;
const int pinParlante = 4;
const int pinBoton = 5;

bool alarmaActivada = false;

void setup() {
  Serial.begin(9600);
  pinMode(pinTrig, OUTPUT);
  pinMode(pinEcho, INPUT);
  pinMode(pinParlante, OUTPUT);
  pinMode(pinBoton, INPUT_PULLUP);
}

void loop() {
  if (digitalRead(pinBoton) == LOW) {
    if (!alarmaActivada) {
      Serial.println("ACTIVADO");
      alarmaActivada = true;
    }
  } else {
    if (alarmaActivada) {
      Serial.println("DESACTIVADO");
      alarmaActivada = false;
    }
  }

  if (alarmaActivada) {
    digitalWrite(pinTrig, LOW);
    delayMicroseconds(2);
    digitalWrite(pinTrig, HIGH);
    delayMicroseconds(10);
    digitalWrite(pinTrig, LOW);

    long duracion = pulseIn(pinEcho, HIGH);
    float distancia = (duracion / 2.0) * 0.0344;

    Serial.print("Distancia: ");
    Serial.print(distancia);
    Serial.println(" cm");

    if (distancia < 200) {
      tone(pinParlante, 1000);
      delay(100);
      noTone(pinParlante);
    }
  }

  delay(500);
}
