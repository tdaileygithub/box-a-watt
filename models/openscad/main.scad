include <rBox.scad>
include <lightBox.scad>

//clearance = 1.0;  // 1mm on each side
//wallThickness = 2.0  // 
//outerWall = measuredInnerLength - clearance

// Object Modifierers:
//   * - Ignore object (do not draw or use in rendering)
//   % - Completely ignore object when rendering but draw it anyway.
//       Object is drawn in in Grey but is not used for anything!
//       DANGER -- when used with differences as first object!  
//   # - Debug Modifier (Draw in transparent mode)
//   ! - Use this as main object and ignore everything else

tilt = 4;
thickness = 10.0 + 1.5;  // From inner model (need to cleanup code/refactor)

%rotate([-tilt, 0, 0])translate([0,0,thickness/2.0])lightBox_model();
lightBox_wedge(angle=tilt);
