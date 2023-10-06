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
  tcmds = ["left",90,
    "move",Df/2, "right",90, "move",Lf, "left",90,
    "untily",D/2, "right",90, "move",Lb, "right",90, "untily",Dc/2,
    "left",90, "move",Lj1, "right",cone_angle,
    "untilx",Lf+Lb+Lj1+Lj2, "right",90-cone_angle,
    "move",Dt/2,
    "right",90, "untilx",0
  ];
  path = turtle(tcmds);
  polygon(path);
}

module orig_volume() {
  // TODO using huil() here is a hack to get around some goofy problem with manifoldness that results from having to rotate the profile before extuding it. The real fix is to change orig_profile() to be defined as the collet extending into the Y axis, not the X, removing the rotate(90) here, and removing hull(). Hopefully.
  hull() rotate_extrude($fn=16) rotate([0,0,90.00001]) orig_profile();
}

module orig_slot() {
  translate([0,0,Ls/2 + Lf+Lb+Lj1+Lj2 - Ls]) cube([Dc+1, Ws, Ls+eps], center=true);
}

module circular_clearance(diameter=3) {
  translate([0,0,Lf+Lb+Lj1+Lj2 - Ls]) cylinder(h=Ls+eps, d=diameter, $fn=16);
}

module collet(drill_bit_diameter) {
  difference() {
    orig_volume();
    orig_slot();
    circular_clearance(diameter=drill_bit_diameter);
  }
}

collet(3.0 - 0.1);
