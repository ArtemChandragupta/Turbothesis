import obj;

size(25cm);

currentprojection=orthographic(-0.3,-1,0.3);

draw(obj("blade.obj", brown));
draw(obj("blade_stator.obj", red));
