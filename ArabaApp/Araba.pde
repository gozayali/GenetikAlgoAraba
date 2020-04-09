class Araba {
  String label="";
  boolean finished=false;
  int maxYol=0;
  int gidilenYol=0;
  int x=400, y=300, hiz=10;
  int aci=-90;
  int sensorRange=80;
  int yolIndex=0;
  int[] sensor= {0, 0, 0, 0, 0}; // sol, solÇapraz, ön, sağÇapraz, sağ
  Neuron[] neuronlar = new Neuron[3];

  public Araba() {   
    // neuronları oluştur
    for (int i=0; i<neuronlar.length; i++) {
      neuronlar[i]= new Neuron();
    }
  }

  public void ciz() {

    stroke(255, 0, 0);
    fill(255, 0, 0);
    line(x-camX, y-camY, x-camX-50*sin(radians(aci)), y-camY+50*cos(radians(aci)));
    triangle( x-camX-50*sin(radians(aci)), y-camY+50*cos(radians(aci)), 
      x-camX-40*sin(radians(aci+5)), y-camY+40*cos(radians(aci+5)), 
      x-camX-40*sin(radians(aci-5)), y-camY+40*cos(radians(aci-5)));
    fill(255, 200, 0);
    if (label.equals(firstIndex+""))
      fill(255, 100, 0);
    if (hiz==0)
      fill(100);
    if (finished)
      fill(random(1)*255, random(1)*255, random(1)*255);
    ellipse(x-camX, y-camY, 20, 20);
    fill(0, 0, 255);
    text(label, x-camX-5, y-camY+4);
    stroke(0);
  }

  public void move() {
    yolIndex=yolda(x, y);
    getSensors();
    double max=0;
    int index=0;
    for (int i=0; i<neuronlar.length; i++) {
      neuronlar[i].inputs = sensor;
      double output=neuronlar[i].getOutput();   
      if (output>max) {
        max=output;
        index=i;
      }
    }


    if (yolIndex==yollar.size()-1)
      finished=true;
    if (yolIndex<0 || maxYol>gidilenYol+200 || finished)
      hiz=0;
    else {
      aci+=(index-1)*10;
      x-=(int)(hiz*sin(radians(aci)));
      y+=(int)(hiz*cos(radians(aci)));

      int yol=0;
      if (yollar.get(yolIndex).artis>0)
        yol= yollar.get(yolIndex).w >yollar.get(yolIndex).h ? x-yollar.get(yolIndex).x:y-yollar.get(yolIndex).y;
      else
        yol= yollar.get(yolIndex).w >yollar.get(yolIndex).h ?
          yollar.get(yolIndex).x+yollar.get(yolIndex).w-x : yollar.get(yolIndex).y+yollar.get(yolIndex).h-y;
      if (yolIndex > 0)
        for (int j=0; j<yolIndex; j++) {
          if (yollar.get(j).w>yollar.get(j).h)
            yol += yollar.get(j).w;
          else
            yol += yollar.get(j).h;
        }
      gidilenYol=yol;
      if (gidilenYol>maxYol)
        maxYol=gidilenYol;
      yolIndex=yolda(x, y);
    }

    ciz();
  }

  public void getSensors() {
    for (int i=0; i<sensor.length; i++) {
      float sensorX = x-sensorRange*sin(radians(aci+(i-2)*45));
      float sensorY = y+sensorRange*cos(radians(aci+(i-2)*45));
      int sensorYol =yolda(sensorX, sensorY);
      if (sensorYol>=0 && abs(sensorYol-yolIndex)<2) {
        sensor[i]=0;
        fill(0, 255, 0);
      } else {
        sensor[i]=1;
        fill(255, 0, 255);
      }
      rect(sensorX-camX-5, sensorY-camY-5, 10, 10);
    }
  }
}
