include <rBox.scad>
include <backLight.scad>
include <cameraMount.scad>

// Measurements of the the lightbox.
// Box Dimensions (mm)
measuredInnerWidth    =  55.0;
measuredOuterWidth    =  58.0;    // +0.3mm --- varies
measuredWallThickness =   1.5;
measuredLength        = 176.0;

// For curved edges use a small radius (or 0).
// This amount is shaved off each edge and the part prints smaller.
measuredCornerRadius  =   0.5;

additionalThickness   =  15.0; 

// The light box is a simple hollow rectangle.  
module lightBox_model() {
rounded_hollow_box(
        width=measuredOuterWidth,
        height=measuredOuterWidth,
        length=measuredLength,
        thickness=measuredWallThickness,
        cornerRadius=measuredCornerRadius
        );
}


module lightBox_wedge(ange=0.0) {
    rounded_sloped_box_gasket(
        width=measuredOuterWidth,
        height=measuredOuterWidth,
        wallThickness=measuredWallThickness,
        cornerRadius=measuredCornerRadius,
        additionalThickness=additionalThickness,
        angle=angle
        );
}


module lightBox_camera_mount()
{
    // The camera mount is placed in the box.  The width/height of the box vary a lot across the length of the box.
    // To make it easier to place the camera mount adjust it so that the mount is smaller than the box.
    tolerance = 2.5;
    
    camera_mount(plateWidth=measuredInnerWidth-tolerance, plateHeight=measuredInnerWidth-tolerance, plateThickness=4.0);

}