module camera_module_import() {
      // Orient the camera correctly and place edge at 0,0.
      // This module wraps this position and orientation so that future
      // transforms on the camera are on the correctly oriented part instead
      // of the original stl model.
      import("../stl/camera_1_3.stl");
}

module camera_standoffs(standoffRadius, standoffHeight) {
       // According to specs, the camera mount holes are in a rectangle centered 12.5mm x 21.0mm spacing
      union() {
          translate([ 0,   0,   standoffHeight/2]) cylinder(r=standoffRadius, h=standoffHeight, center=true);
          translate([ 0,  12.5, standoffHeight/2]) cylinder(r=standoffRadius, h=standoffHeight, center=true);
          translate([21,   0,   standoffHeight/2]) cylinder(r=standoffRadius, h=standoffHeight, center=true);
          translate([21,  12.5, standoffHeight/2]) cylinder(r=standoffRadius, h=standoffHeight, center=true);
          }
}

module camera_mount(plateWidth, plateHeight, plateThickness=4.0) {

       camera_cable_width = 16.5;
       camera_cable_thickness = 0.15;
       camera_cable_width_opening = 25.0;  // Make as wide as camera
       camera_cable_thickness_opening = camera_cable_thickness + 1.5;

       standoffHeight = 5;

       difference() {
           union() {
                   cube([plateWidth, plateHeight, plateThickness]);

                   // Make a bar (4mm x 2mm) to hold the backlight in place
                   translate([4, 2, plateThickness])backLight_holder_bar();

                   // Put the camera standoffs in place so that camera lens is centered
                   translate([27,30,plateThickness]) camera_standoffs(standoffRadius=2, standoffHeight=standoffHeight);
           }
      
           // --------------------------------------------------
           // The following items are subtracted from the design
           // --------------------------------------------------

           // Remove the section for the Camera Cable Slit
           translate([50,5,-plateThickness*2.5])
               rotate([0,0,90])
                   cube([camera_cable_thickness_opening, camera_cable_width_opening, plateThickness*5]); // Cut this out of board


           // make holes for the BackLight power and ground wires
           translate([12,53, -plateThickness*0.5])cylinder(h= plateThickness*5, r=1.0);
           translate([ 8,53, -plateThickness*0.5])cylinder(h= plateThickness*5, r=1.0);

           // Make holes for camera mount (the height should be large to remove any material)
           translate([27, 30, -100]) camera_standoffs(standoffRadius=1, standoffHeight=200);
      }


      // ----------------------------------------------------
      // Show the images of the camera and the backlight
      // but do not use them in building the working object
      // ----------------------------------------------------
      %translate([25,20, plateThickness + standoffHeight + 0.5]) camera_module_import();
      %translate([4,2,plateThickness]) backLight();
}

