include <rBox.scad>
include <lightBox.scad>


// Object Modifierers:
//   * - Ignore object (do not draw or use in rendering)
//   % - Completely ignore object when rendering but draw it anyway.
//       Object is drawn in in Grey but is not used for anything!
//       DANGER -- when used with differences as first object!  
//   # - Debug Modifier (Draw in transparent mode)
//   ! - Use this as main object and ignore everything else

tilt = 4;
thickness = lightBox_get_default_thickness();

%rotate([-tilt, 0, 0])translate([0,0,thickness])lightBox_model();

// Print the wedge
lightBox_wedge(angle=tilt);

// Print the Camera and Light mount
//translate([75,0,0]) 
//lightBox_camera_mount();

// r=.1;
// w=10;
// h=20;
// l=5;
// t=1.0; // Thicknes
// //translate([r, r, 0]) rounded_solid_box(w, h, l, r);
// //translate([r, r, 0])
// //rounded_hollow_box(w, h, l, t, r);
// %translate([0,0, -3]) rounded_box_gasket(w, h, t, r, 3);
// translate([0,0,-3]) rounded_sloped_box_gasket(w, h, t, r, 3, angle);
// //cube([w,h,l]);