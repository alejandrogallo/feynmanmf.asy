
import feynmanmf;

// define vertex and external points

real L = 50;

pair zl = (-0.75*L,0);
pair zr = (+0.75*L,0);

pair xu = zl + L*dir(+120);
pair xl = zl + L*dir(-120);

pair yu = zr + L*dir(+60);
pair yl = zr + L*dir(-60);


// draw propagators and vertices

// p
drawFermion(zl--xu);
// s
drawFermion(xl--zl);
// q
drawFermion(zr--yu);
// r
drawFermion(yl--zr);

drawPhoton(zl--zr);


//drawVertex(zl);
//drawVertex(zr);


// draw momentum arrows and momentum labels

label(Label("$s$",RightSide), xl--zl);

label(Label("$p$",LeftSide), xu--zl);


label(Label("$q$",LeftSide), zr--yu);

label(Label("$r$",RightSide), zr--yl);





