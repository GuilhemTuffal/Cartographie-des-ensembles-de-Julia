/**
 Ce programme permet de représenter une cartographie des ensembles de julia se trouvant dans le rectangle délimité par min_x_+ i * min_y_ et max_x_+ i * max_y_. 
 Il est possible de changer la densité de points en changeant les valeurs de largeur et hauteur, la précision en changeant la valeur nb_d_iterations et le nombre
 d'ensemble de Julia en changeant la valeur de nb_y. Tout ces changements risquent de changer la vitesse d'éxecution du programme. Il est aussi possible de changer
 la couleur de la représentation et l'ordre c'est à dire la puissance à laquelle le nombre complexe va être élevé (voir https://fr.wikipedia.org/wiki/Ensemble_de_Mandelbrot#G%C3%A9n%C3%A9ralisations_et_variantes)
 Les paramètres par défauts rendent le programme lent mais le résultat est magnifique.
 */
 
//variables à changer selon les envies
int ordre=2;//par défault 2
int nb_d_iterations=5000;//max 100000 aucune amélioration aprés en plus devient lent
int nb_y =80;
color couleur=color(255, 171, 0);//format RGB
int largeur=200;
int hauteur=200;
String nom="final.jpg";
 
//variables à changer selon les envies (mais risquent d'affecter l'orthonormalité du résultat)
 
float min_x_=-2.2;//par défaut -2.2
float max_x_=0.6;//par défaut 0.6
float min_y_=0;//par défaut 0
float max_y_=0.6;//par défaut 0.6
float min_x=-1.8;//par défaut -1.8
float max_x=1.8;//par défaut 1.8
 
//Programme
PGraphics big;
boolean grille=false;
float min_y;
float max_y;
float coef;
float nb_de_zoom=1.0;
int decalage_x;
int decalage_y;
float a__=0.0;
float b__=0.0;
boolean clique;
float[] point_de_depart;
float[] point_actuel;
int nb =int(float(nb_y)*2.8);
int compteur=0;
color inverse(color initial) {
  return color(255-red(initial), 255-green(initial), 255-blue(initial));
}
float[] calcul(float[] z, float[] z_) {
  float a=z[0];
  float b=z[1];
  float a_=z[0];
  float b_=z[1];
  float[] z__=new float[2];
  for (int i=0; i<ordre-1; i++) {
    z__[0]=a*a_-b*b_;
    z__[1]=a*b_+b*a_;
    a_=z__[0];
    b_=z__[1];
  }
  z__[0]+=a__;
  z__[1]+=b__;
  return z__;
}

void place(float x, float y) {
  point_de_depart=new float[2];
  point_de_depart[0]=(x+(largeur*min_x/(max_x-min_x)))/coef;
  point_de_depart[1]=-(y+(hauteur*min_y/(max_y-min_y)))/coef;
  point_actuel=new float[2];
  point_actuel[0]=point_de_depart[0];
  point_actuel[1]=point_de_depart[1];
}
float power(float x, int a) {
  return x*x;
}
void dessine(float x, float y) {
  boolean verife=true;
  int temp=0;
  for (int i_=0; i_<nb_d_iterations; i_++) {
    float a=point_actuel[0];
    float b=point_actuel[1];
    point_actuel=calcul(point_actuel, point_de_depart);
    if (power(point_actuel[0], 2)+power(point_actuel[1], 2)>4) {
      verife=false;
      temp=i_;
      break;
    } else if (power(point_actuel[0]-a, 2)+power(point_actuel[1]-b, 2)<0.000000001 && false) {
      break;
    }
  }
  if (verife) {
    compteur++;
    big.stroke(couleur);
  } else {
    big.stroke(min(red(couleur), temp-255+red(couleur)), min(green(couleur), temp-255+green(couleur)), 0);
  }
  big.point((float)(x-largeur/2)+decalage_x, (float)(-(y-hauteur/2+1))+decalage_y);
}
void setup() {
  size(500, 500);
  noSmooth();
  clique=true;
  coef=largeur/( max_x-min_x);
  min_y=min_x;
  max_y=max_x;
  big = createGraphics(largeur*nb, hauteur*nb_y);
  big.beginDraw();
  big.translate(largeur/2, hauteur/2);
  big.background(0);
  for (int xx=-nb/2; xx<(nb%2==0?nb/2:nb/2+1); xx++) {
    for (int yy=0; yy<nb_y; yy++) {
      compteur=0;
      decalage_x=(xx+nb/2)*largeur;
      decalage_y=(yy)*hauteur;
      a__=min_x_+(max_x_-min_x_)*(xx+float(nb/2))/float(nb-1);
      b__=(yy)/float(nb_y-1);
      for (int e=0; e<largeur; e++) {
        for (int j=0; j<hauteur; j++) {
          place(e, j);
          dessine(e, j);
        }
      }
      if (grille) {
        for (int i=0; i<700; i++) {
          stroke(inverse(get(350, i)));
          point(0, i-350);
        }
        for (int i=0; i<700; i++) {
          stroke(inverse(get(i, 350)));
          point(i-350, 0);
        }
        for (int i=0; i<7; i++) {
          for (int a=0; a<10; a++) {
            stroke(inverse(get(a+345, (i-3)*100+350)));
            point(a-5, (i-3)*100);
          }
        }
        for (int i=0; i<7; i++) {
          for (int a=0; a<10; a++) {
            stroke(inverse(get((i-3)*100+350, a+345)));
            point((i-3)*100, a-5);
          }
        }
      }
      //println(a__, b__);
    }
  }
  big.endDraw();
  big.save("resultat/"+(nb==1?nom:2+nom));
  exit();
}

void mouseClicked() {
  clique=true;
  nb_de_zoom*=2.0D;
  coef*=2.0D;
  //println(min_x, "   ", max_x, "   ", min_y, "   ", max_y, "   ");
  float x_=4.5/nb_de_zoom/2.0;
  float y_=2.53125/nb_de_zoom/2.0;
  float temp=(max_x*(float)mouseX/(float)largeur)+min_x*(1.0-(float)mouseX/(float)largeur);
  min_x=temp-x_;
  max_x=temp+x_;
  temp=max_y*((float)hauteur-(float)mouseY)/(float)(hauteur)+min_y*(1.0-((float)hauteur-(float)mouseY)/(float)hauteur);
  min_y=temp-y_;
  max_y=temp+y_;
  //println(min_x, "   ", max_x, "   ", min_y, "   ", max_y);
}
