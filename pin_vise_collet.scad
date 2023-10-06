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
Lb = 4.13;
Lj1 = 10.13;
Lj2 = 5.83;
Ws = 0.6;
Ls = 15.44;
// Lf + Lb + Lj1 + Lj2 = 15.44


module orig_profile() {
  cone_angle=atan2((Dc-Dt)/2,Lj2);
  tcmds = ["left",90,
    "move",Df/3, "right",90, "move",Lf, "left",90,
    "untily",D/2, "right",90, "move",Lb, "right",90, "untily",Dc/2,
    "left",90, "move",Lj1, "right",cone_angle,
    "untilx",Lf+Lb+Lj1+Lj2, "right",90-cone_angle,
    "move",Dt/2,
    "right",90, "untilx",0
  ];
  path = turtle(tcmds);
  rotate_extrude($fn=16) rotate([0,0,90]) polygon(path);
}

module orig_slot() {
  translate([0,0,Ls/2 + Lf+Lb+Lj1+Lj2 - Ls]) cube([Dc+1, Ws, Ls], center=true);
}

module circular_clearance(diameter=3) {
  translate([0,0,Ls/2 + Lf+Lb+Lj1+Lj2 - Ls]) cylinder(h=Ls, d=diameter, $fn=16);
}

module collet() {
  difference() {
    orig_profile();
    orig_slot();
    circular_clearance();
  }
}

collet();
