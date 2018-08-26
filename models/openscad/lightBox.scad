include <rBox.scad>
include <backLight.scad>
include <cameraMount.scad>

// Measurements of the the lightbox.
// Box Dimensions (mm)
measuredInnerWidth    =  55.0;    // varies 54.7 to 55.7 (backside: 52.25mm)
measuredOuterWidth    =  58.0;    // varies 57.5 to 59.0 (backside: 58.75mm)
measuredWallThickness =   2.0;    // Backside of box is up to 3.6mm
measuredLength        = 176.0;

// For curved edges use a small radius (or 0).
// This amount is shaved off each edge and the part prints smaller.
measuredCornerRadius  =   1.0;

additionalThickness   =  15.0; 

// Return the thickness which is used in other modules
function lightBox_get_default_thickness() = additionalThickness;

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
    // Need to remove an additional 0.5mm from all inner sides.
    // Easier to add to thickness.
    innerLipPullback = 0.5;

    rounded_sloped_box_gasket(
        width=measuredOuterWidth,
        height=measuredOuterWidth,
        wallThickness=(measuredWallThickness+innerLipPullback),
        cornerRadius=measuredCornerRadius,
        additionalThickness=additionalThickness,
        angle=angle
        );
}


module lightBox_camera_mount(widthAdjustment=0, heightAdjustment=0)
{
    camera_mount(plateWidth=measuredInnerWidth+widthAdjustment, plateHeight=measuredInnerWidth+heightAdjustment, plateThickness=4.0);
}