int jSize=100;
int firstIndex=0;
int jenYol=0, kalan=0, bitiren=0;
int jenNo=1;
Araba[] arabalar = new Araba[jSize];
int camX=0, camY=0;
ArrayList<Yol> yollar = new ArrayList<Yol>();
StringList results = new StringList();
double jenAvg=0 ;
double caprazProb=0.9;
double mutProb=0.02;


void setup() {
  size(1000, 600);
  for (int i=0; i<arabalar.length; i++) {
    arabalar[i]= new Araba();
    arabalar[i].label=i+"";
  }
  yolOlustur();
}

void draw() {
  if (bitiren<3*jSize/4+1) {
    background(255);
    yolCiz();
    for (int i=0; i<arabalar.length; i++) {
      arabalar[i].move();
    }
    setCam();
    getInfo();
    if (arabaKalmadi()) {
      getInfo();
      dogalSecilim();
      caprazla();
      neuralDisiSifirla();      
      results.append("b: "+bitiren+" m: "+jenYol+" a: "+jenAvg);     
      jenNo++;
    }
    sagPanelGetir();
  }
}

public void sagPanelGetir() {
  fill(0, 100, 255);
  rect(800, 0, 200, 600);
  fill(255);
  text("Jenerasyon Size: "+jSize, 810, 30);
  text("En iyi yol: "+jenYol, 810, 50);
  text("Devam eden: "+kalan, 810, 70);
  text("Sona gelebilen: "+bitiren, 810, 90);
  text("Jenerasyon No: "+jenNo, 810, 110);

  fill(0);
  for (int i=0; i<results.size(); i++)
    if (i<8)
      text("J: "+(results.size()-i)+((results.size()-i)>9?"":" ")+"  "+results.get(results.size()-i-1), 810, 150+(i)*15);
  networkCiz();
  kucukHaritaCiz();
}

public void networkCiz() {
int index=0;
double max=0;
  for (int i=0; i<arabalar[firstIndex].neuronlar.length; i++){
    if(arabalar[firstIndex].neuronlar[i].output>max){
      max=arabalar[firstIndex].neuronlar[i].output;
      index=i;
    }  
  }
  
  rect(950, 325, 40, 30);
  fill(255);
  text((index==0? "SOL" : (index==1 ? "DÜZ" : "SAĞ")),955,345);
  for (int i=0; i<arabalar[firstIndex].neuronlar.length; i++) {
    fill(200,200,0);
    if(i==index)
    fill(200,0,0);
    ellipse( 910, 300+i*40, 25, 25);
    
    stroke((int)(arabalar[firstIndex].neuronlar[i].output*255));
    line(910, 300+i*40, 950 ,340 );
    
    for (int j=0; j<arabalar[firstIndex].sensor.length; j++) {
      strokeWeight((int)(arabalar[firstIndex].neuronlar[i].weights[j]*5));
      stroke((int)(arabalar[firstIndex].neuronlar[i].weights[j]*arabalar[firstIndex].neuronlar[i].inputs[j]*255),0,0);
      line(817, 297+j*20, 910, 300+i*40);
      strokeWeight(1);
      fill(255, 0, 255);
      if (arabalar[firstIndex].sensor[j]==0)
        fill(0, 255, 0);
      rect(810, 290+j*20, 15, 15);
    }
  }
  
}


public void kucukHaritaCiz() {
  double minHX =10000;
  double minHY =10000;
  double maxHX =0;
  double maxHY =0;
  for (int i=0; i<yollar.size(); i++) {
    if (yollar.get(i).x < minHX)
      minHX =yollar.get(i).x;
    if (yollar.get(i).y < minHY)
      minHY =yollar.get(i).y;
    if (yollar.get(i).x+ yollar.get(i).w > maxHX)
      maxHX = yollar.get(i).x+yollar.get(i).w;
    if (yollar.get(i).y+yollar.get(i).h > maxHY)
      maxHY =yollar.get(i).y+yollar.get(i).h;
  }


  float oran = (float)(maxHX-minHX)/100;
  Yol[] kucukYollar = new Yol[yollar.size()];
  for (int i=0; i<yollar.size(); i++) {
    kucukYollar[i]= new Yol( int(yollar.get(i).x/oran) + 850 +camX, int(yollar.get(i).y/oran) +410+camY, int(yollar.get(i).w/oran), int(yollar.get(i).h/oran), 0);
    stroke(255);
    kucukYollar[i].ciz();
  }


  for (int i=0; i<arabalar.length; i++) {
    stroke(255, 0, 0);
    fill(255, 200, 0);

    if (i==firstIndex)
      fill(255, 100, 0);
    if (arabalar[i].hiz==0)
      fill(100);
    if (arabalar[i].finished)
      fill(random(1)*255, random(1)*255, random(1)*255);

    ellipse(int((arabalar[i].x)/oran)+ 850, int((arabalar[i].y)/oran) +410, 5, 5);
    stroke(0);
  }
}

public void yolOlustur() {
  yollar.add(new Yol(200, 200, 3000, 200, 1));
  yollar.add(new Yol(3000, 200, 200, 3000, 1));
  yollar.add(new Yol(200, 3200, 3000, 200, 0));  
  yollar.add(new Yol(200, 3200, 200, 1000, 1));
  yollar.add(new Yol(200, 4200, 3000, 200, 1));  
  yollar.add(new Yol(3000, 4200, 200, 500, 1));
  yollar.add(new Yol(200, 4700, 3000, 200, 0));
  yollar.add(new Yol(200, 4700, 200, 500, 1));
  yollar.add(new Yol(200, 5200, 3000, 200, 1));

  yollar.add(new Yol(3000, 5200, 200, 950, 1));
  yollar.add(new Yol(2500, 5950, 500, 200, 0));
  yollar.add(new Yol(2300, 5450, 200, 700, 0));
  yollar.add(new Yol(1800, 5450, 500, 200, 0));
  yollar.add(new Yol(1600, 5450, 200, 700, 1));
  yollar.add(new Yol(1100, 5950, 500, 200, 0));
  yollar.add(new Yol(900, 5450, 200, 700, 0));
  yollar.add(new Yol(400, 5450, 500, 200, 0));
  yollar.add(new Yol(200, 5450, 200, 750, 1));

  yollar.add(new Yol(200, 6200, 3600, 200, 1));
  yollar.add(new Yol(3600, 3200, 200, 3000, 0));
  yollar.add(new Yol(3300, 3200, 300, 200, 0));
  yollar.add(new Yol(3300, 2500, 200, 700, 0));
  yollar.add(new Yol(3300, 2500, 400, 200, 1));
  yollar.add(new Yol(3500, 150, 200, 2350, 0));
  yollar.add(new Yol(200, 50, 3500, 100, 0));
  yollar.add(new Yol(100, 50, 100, 100, 0));
}

public void yolCiz() {
  for (int i=0; i<yollar.size(); i++)
    yollar.get(i).ciz();
}

public int yolda(float x, float y) {
  for (int i=0; i<yollar.size(); i++) {
    if (yollar.get(i).x<= x && yollar.get(i).x+yollar.get(i).w >= x && yollar.get(i).y<= y && yollar.get(i).y+yollar.get(i).h >= y)
      return i;
  }
  return -1;
}

public boolean arabaKalmadi() {
  Araba temp= new Araba();
  for (int i=0; i<arabalar.length; i++) {
    if (arabalar[i].hiz == temp.hiz)
      return false;
  }
  return true;
}

public void setCam() {
  int index=0;
  int maxYol=0;

  for (int i=0; i<arabalar.length; i++) {
    if (arabalar[i].gidilenYol>=maxYol) {
      maxYol=arabalar[i].gidilenYol;
      index=i;
    }
  }
  firstIndex=index;
  camX = arabalar[index].x - 400;
  camY = arabalar[index].y - 300;
}

public void getInfo() {
  kalan=0;
  bitiren=0;
  jenYol=0;
  double sum=0;
  for (int i=0; i<arabalar.length; i++) {
    sum+=arabalar[i].maxYol;
    if (arabalar[i].hiz>0)
      kalan++;
    if (arabalar[i].finished)
      bitiren++;
    if (arabalar[i].maxYol>jenYol)
      jenYol=arabalar[i].maxYol;
  }
  jenAvg = sum/arabalar.length;
}

public void neuralDisiSifirla() {
  Araba temp= new Araba();
  for (int i=0; i<jSize; i++) {
    arabalar[i].label=i+"";
    arabalar[i].hiz= temp.hiz;
    arabalar[i].aci=temp.aci;
    arabalar[i].x = temp.x;
    arabalar[i].y = temp.y;
    arabalar[i].maxYol = 0;
    arabalar[i].yolIndex = 0;
    arabalar[i].gidilenYol = 0;
    arabalar[i].finished = false;
  }
}


///_________________________ Neural Network __________________________

double sigmoidValue(Double arg) {
  return (1 / (1 + Math.exp(-arg)));
}



//__________________________ GENETİK ___________________________________

void quickSort(Araba[] a, int left, int right) {
  Araba temp;
  int i = left, j = right;
  int x = a[(left + right) / 2].maxYol;
  do {
    while (a[i].maxYol < x)
      i++;
    while (a[j].maxYol > x)
      j--;
    if (i <= j) {
      temp = a[i];
      a[i] = a[j];
      a[j] = temp;
      i++;
      j--;
    }
  } while (i <= j);

  if (left < j)
    quickSort(a, left, j);
  if (i < right)
    quickSort(a, i, right);
}

void dogalSecilim() {
  int topPuan=0;
  for (int i=0; i<jSize; i++) 
    topPuan+= arabalar[i].maxYol;

  Araba[] tempJen= new Araba[jSize];
  double talih;
  for (int i=0; i<jSize; i++) {
    int index=-1;
    talih=(int)random(topPuan);
    for (int j=0; j<jSize; j++) {
      int minSecilimDegeri=0;
      for (int k=j; k>=0; k--)
        minSecilimDegeri += arabalar[k].maxYol;

      if ( talih < minSecilimDegeri && index==-1)
        index=j;
    }
    tempJen[i]=arabalar[index];
  }

  for (int i=0; i<jSize; i++) 
    for (int j=0; j<arabalar[i].neuronlar.length; j++)
      for (int k=0; k<arabalar[i].neuronlar[j].weights.length; k++) {
        arabalar[i].neuronlar[j].weights[k]=tempJen[i].neuronlar[j].weights[k];
      }

  quickSort(arabalar, 0, arabalar.length-1);
}


void caprazla() {

  int[] indexler=new int[jSize];
  for (int i=0; i<jSize; i++)
    indexler[i]=i;

  int index;
  int index2;
  double temp;
  for (int i=0; i<100; i++) {
    index=(int)random(jSize);
    index2=(int)random(jSize);
    temp=indexler[index];
    indexler[index]=indexler[index2];
    indexler[index2]=(int)temp;
  }

  for (int i=0; i<jSize; i++)
    if (i%2==1 && indexler[i]<jSize-2) {
      if (random(1)<caprazProb) {
        int neuronSize= arabalar[i].neuronlar.length;
        int weightSize = arabalar[i].sensor.length;
        for (int j=0; j<(int)random(weightSize); j++) {
          int selectQnt=(int)random(weightSize);
          for (int k=0; k<neuronSize; k++) {
            temp=arabalar[indexler[i]].neuronlar[k].weights[selectQnt];
            arabalar[indexler[i]].neuronlar[k].weights[selectQnt]=arabalar[indexler[i-1]].neuronlar[k].weights[selectQnt]; 
            arabalar[indexler[i-1]].neuronlar[k].weights[selectQnt]=temp;
          }
        }
      }
    }
  index=-1;
  index2=-1;
  for (int i=0; i<jSize; i++) {
    if (indexler[i]>=jSize-2)
      if (index<0)
        index=i;
      else
        index2=i;
  }

  mutasyon(index, index2);
}

void mutasyon(int ilk, int ikinci) {
  for (int i=0; i<jSize; i++)
    if (i!=ilk && i!=ikinci)
      if (random(1)<mutProb) {
        int neuronSize= arabalar[i].neuronlar.length;
        int weightSize = arabalar[i].sensor.length;
        for (int j=0; j<random(weightSize); j++)
          for (int k=0; k<neuronSize; k++) {     
            arabalar[i].neuronlar[k].weights[j]=random(1);
          }
      }
}
