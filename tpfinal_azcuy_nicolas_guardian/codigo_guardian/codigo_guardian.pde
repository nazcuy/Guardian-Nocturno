import processing.serial.*;

PImage camaVacia, puerta, juan;
boolean pantallaInicial = true;
boolean sistemaActivado = false;
boolean movimientoDetectado = false;
Serial miPuerto;

float posXJuan = 300;
float velocidadJuan = 9;
float distanciaSensor = 0;

void setup() {
  size(1500, 800);
  camaVacia = loadImage("data/cama_vacia.png");
  puerta = loadImage("data/puerta.png");
  juan = loadImage("data/juan_camina.png");
  textAlign(CENTER, CENTER);
  String nombrePuerto = "COM7";
  miPuerto = new Serial(this, nombrePuerto, 9600);
}

void draw() {
  if (movimientoDetectado) {
    image(camaVacia, 0, 0, width, height);
  } else {
    image(puerta, 0, 0, width, height);
  }
  
  fill(255, 0, 0);
  textSize(40);
  text("Sistema de cuidado infantil", 750, 30);
  text("EL GUARDIÁN NOCTURNO", 750, 70);

  fill(200);
  strokeWeight(8);
  rect(1200, 700, 290, 90, 10);

  fill(0);
  textSize(20);
  
  if (pantallaInicial) {
    text("Presione el botón para", 1345, 735);
    text("activar el sistema", 1345, 755);
  } else {
    fill(0, 255, 0);
    rect(1200, 700, 290, 90, 10);
    fill(0);
    text("El sistema", 1345, 735);
    text("ha sido activado", 1345, 755);
    
    if (movimientoDetectado){
      posXJuan = lerp(posXJuan, map(distanciaSensor, 0, 100, 1200, 300), 0.1); //Recordatorio: El valor de 0.1 significa que Juan se mueve el 10% del camino hacia la nueva posición en cada actualización del draw().
      posXJuan = constrain(posXJuan, 300, 1200);
      image(juan, posXJuan, 300, 150, 300);
    }
  }
}

void serialEvent(Serial miPuerto) {
  String data = miPuerto.readStringUntil('\n');
  if (data != null) {
    data = trim(data);
    if (data.equals("ACTIVADO")) {
      pantallaInicial = false;
      sistemaActivado = true;
      println("Sistema activado.");
    } else if (data.equals("DESACTIVADO")) {
      pantallaInicial = true;
      sistemaActivado = false;
      println("Sistema desactivado");
    } else if (data.startsWith("Distancia: ")) {
      distanciaSensor = float(split(data, ' ')[1]);
      println("Distancia recibida: " + distanciaSensor);
      if (distanciaSensor < 100) {
        movimientoDetectado = true;
      } else {
        movimientoDetectado = false;
      }
    }
  }
}
