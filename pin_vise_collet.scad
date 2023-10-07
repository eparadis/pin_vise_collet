// pin vise collet

include <BOSL2/std.scad>

// design params
// slot_width = 0.6;

// measurements
D = 6.0;
Df = 5.36;
Dt = 4.2;
Dc = 5.7;
Lf = 6.0;
Lb = 4.60;    // original measurement incorrect: 4.13;
Lj1 = 10.17;  // 10.13;
Lj2 = 6.17;   // 5.83;
Ws = 0.6;
Ls = 15.44;
// Lf + Lb + Lj1 + Lj2 = 15.44
overall_length = Lf + Lb + Lj1 + Lj2;
echo(str("overall length is ", overall_length, " and should be 26.72"));
eps = .001;

module orig_profile() {
  cone_angle=atan2((Dc-Dt)/2,Lj2);
  tcmds = [
    "move",Df/2, "left",90, "move",Lf, "right",90,
    "untilx",D/2, "left",90, "move",Lb, "left",90, "untilx",Dc/2,
    "right",90, "move",Lj1, "left",cone_angle,
    "untily",Lf+Lb+Lj1+Lj2, "left",90-cone_angle,
    "untilx",0,
  ];
  path = turtle(tcmds);
  polygon(path);
}

module orig_volume() {
  rotate_extrude($fn=16) orig_profile();
}

module volume() {
  corner_dia = 6.0 / (cos(180/6));
  union() {
    orig_volume();
    rotate([0,0,180/6]) cylinder(h=11, d=corner_dia, $fn=6);
  }
}

module orig_slot(slot_width=Ws) {
  translate([0,0,Ls/2 + Lf+Lb+Lj1+Lj2 - Ls]) cube([Dc+1, slot_width, Ls+eps], center=true);
}

module circular_clearance(diameter=3) {
  translate([0,0,Lf+Lb+Lj1+Lj2 - Ls]) cylinder(h=Ls+eps, d=diameter, $fn=16);
}

module collet(drill_bit_diameter) {
  difference() {
    volume();
    orig_slot( drill_bit_diameter < Ws ? drill_bit_diameter-0.1 : Ws);
    circular_clearance(diameter=drill_bit_diameter);
  }
}

collet(3.0 - 0.1);
