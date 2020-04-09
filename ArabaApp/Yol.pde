class Yol {
  int x, y, w, h, artis;
  public Yol(int _x, int _y, int _w, int _h, int _artis) {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    artis = _artis;
  }

  public void ciz() {
    fill(80);
    rect(x-camX, y-camY, w, h);
    fill(220);
    if (w>h)
      for (int i=0; i<w; i+=h)
        rect(x-camX+i+h/3, y-camY+2*h/5, h/3, h/5);
    else
      for (int i=0; i<h; i+=w)
        rect(x-camX+2*w/5, y-camY+i+w/3, w/5, w/3);
  }
}
