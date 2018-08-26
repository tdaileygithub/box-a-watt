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

showModels = true;
//showModels = false;

// =================================================
// Print the wedge
// =================================================
if (!showModels) {
    translate([75,0,0]) {
        lightBox_wedge(angle=tilt);
        //%rotate([-tilt, 0, 0])translate([0,0,thickness])lightBox_model();
        //%translate([0,0, thickness-6]) rotate([-tilt, 0, 0])lightBox_model();
	}
    }

// =================================================
// Print the Camera Mount
// Show models of wedge and light box
// =================================================
adjustment=3.0;  // Backside of box is a lot different than front side!!!
translate([adjustment/2, adjustment/2, 0])
    lightBox_camera_mount(widthAdjustment=-adjustment, heightAdjustment=-adjustment);

if (showModels) {
    // Show the lightBox model
    %lightBox_model();

    // Show the wedge model (flipped and adjusted)
    translate([55.75,0.75,185]) rotate([tilt,180,0]) lightBox_wedge(angle=tilt);
}