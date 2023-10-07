
include <BOSL2/std.scad>

use <pin_vise_collet.scad>;

// all the sizes of the Harbor Freight Micro Drill Bit Set
drill_bit_sizes = [0.5, 0.6, 0.8, 1.0, 1.2, 1.5, 1.8, 2.0, 2.35, 3.0];



for(i = [ 0 : len(drill_bit_sizes) - 1 ]) {
  translate([10*i, 0, 0]) collet(drill_bit_sizes[i]-0.1);
}