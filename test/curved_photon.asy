import feynmanmf;

// define vertex and external points

real L = 50;

pair zl = (-2.75*L,0);
pair zr = (+2.75*L,0);

pair p_zl = zl+(L,0);
pair p_zr = zr-(L,0);


drawFermion(zl--zr);

path g = arc((p_zl+p_zr)/2, p_zl, p_zr);

drawPhoton(g);
