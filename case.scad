// an insert for a medicine bottle to hold the collets

include <BOSL2/std.scad>

module _stop_customizer();

$fn=64;

case_height = 80;

module divider(angle=0) {
  rotate([0,0,angle]) translate([0,-1/2,0]) cube([29.1/2,1,case_height]);
}

module outside() {
  difference() {
    cylinder(h=case_height, d1=29.1, d2=30.8);
    translate([0,0,1]) cylinder(h=case_height, d=28);
  }
}

module handle() {
  cylinder(h=95,d=5);
  translate([0,0,85]) cylinder(h=10,d1=5,d2=10);
}

module dividers_with_pockets(pockets=6, lengths=[10,20,30,40,50,60]) {
  peek=10; // how much the drill bits will "peek out" from the pocket

  angles=[for (i=[0:360/pockets:360]) i];

  for(i=[0:pockets-1]) {
    divider(angles[i]);
    rotate([0,0,angles[i]]) linear_extrude(case_height-lengths[i]+peek) arc(n=64, d=28+0.1, angle=360/pockets, wedge=true);
  }
}

module subtractive_pockets(pockets=6, lengths=[10,20,30,40,50,60]) {
  peek=10; // how much the drill bits will "peek out" from the pocket

  angles=[for (i=[0:360/pockets:360]) i];

  for(i=[0:pockets-1]) {
    translate([0,0,case_height-lengths[i]]) rotate([0,0,angles[i]+2]) linear_extrude(lengths[i]+.1) arc(n=64, d=28+10, angle=360/pockets-2, wedge=true);
  }
}

module dividers(pockets=6) {
  peek=10; // how much the drill bits will "peek out" from the pocket

  angles=[for (i=[0:360/pockets:360]) i];

  for(i=[0:pockets-1]) {
    divider(angles[i]);
  }
}

module labels(pockets=6, pocket_labels=["1.0", "2.0", "3.0", "4.0", "5.0", "6.0"], lengths=[10,20,30,40,50,60]) {
  angles=[for (i=[0:360/pockets:360]) i];

  for(i=[0:pockets-1]) {
    translate([0,0,case_height-lengths[i]-3])
    rotate([0,0,360/10/2+angles[i]])
    translate([14, -3, 0])
    rotate([90,90,90])
    linear_extrude(3, convexity=10)
    text(text=str(pocket_labels[i]), size=7, halign="left");
  }
}

module full_case() {
  union() {
    outside();
    handle();
    dividers_with_pockets(10, [60,55,47,45,40,37,33,30,25,22]);
  }
}

module no_sides_case() {
  difference() {
    union() {
      cylinder(h=case_height, d1=29.1, d2=30.8);
    }
    subtractive_pockets(10, [60,55,47,45,40,37,33,30,25,22]);
    labels(10,
      ["3.0", "2.35", "2.0", "1.8", "1.5", "1.2", "1.0", "0.8", "0.6", "0.5"],
      [60,55,47,45,40,37,33,30,25,22]
    );
  }
  handle();
  dividers(10);
}

//full_case();
no_sides_case();

