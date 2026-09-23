// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_police_hardware.scad (Tactical Police Pursuit Mechanical Array)
// Core Objective: Structural frame-mount armor, recovery winches, and rooftop light bars
// Center Origin (0,0,0) = Mid-point of Front Frame Crossmember Structural Face
// ====================================================================================

$fn = 100; // High-precision CNC cutting and welding profile resolution

// --- Engineering Constants (mm) ---
inch_to_mm         = 25.4;
frame_width_span   = 24.0  * inch_to_mm; // 609.6 mm track width
wheelbase_total    = 114.3 * inch_to_mm; // 2903.22 mm chassis length
tube_thickness_mm  = 6.00;               // Heavy-duty reinforced structural steel plate

// Auxiliary Electronic Footprints
lightbar_length    = 48.0 * inch_to_mm;  // Roof tracking emergency light bar width
winch_drum_width   = 210.00;             // 12,000-lb heavy electric extraction winch spool

module front_and_rear_push_bumpers() {
    echo("COMPILING FRONT AND REAR PURSUIT ARMOR OVERLAYS");
    // 1. FRONT INTERCEPTOR PUSH BUMPER (Bolts straight to front frame horn tabs)
    color("Black") {
        translate([-frame_width_span/2 - 40, -120, -100]) {
            difference() {
                // Main horizontal push beam faceplate
                cube([frame_width_span + 80, 80, 250]);
                // Cutout window passage for the winch line fairlead guide rollers
                translate([frame_width_span/2 + 40 - 100, -1, 40])
                    cube([200, 82, 50]);
            }
            // Left vertical pushing vertical ram tooth
            translate([100, -40, -50]) cube([60, 40, 350]);
            // Right vertical pushing vertical ram tooth
            translate([frame_width_span, -40, -50]) cube([60, 40, 350]);
        }
    }
    
    // 2. REAR RAM REINFORCEMENT BUMPER (Protects fuel cell during high-speed PIT maneuvers)
    color("DarkSlateGrey") {
        translate([-frame_width_span/2 - 20, -wheelbase_total + 100, -100])
            cube([frame_width_span + 40, 60, 180]);
    }
}

module integrated_frame_winch() {
    // 12,000-lb extraction winch nested deep within the front frame crossmember cavity
    color("DimGrey") {
        translate([-winch_drum_width/2, -40, -20]) {
            // Main high-torque planetary gearbox motor drum cylinder
            rotate([0, 90, 0])
                cylinder(d=110, h=winch_drum_width);
            // Electronic control solenoid terminal pack box
            translate([winch_drum_width/3, -30, 60])
                cube([80, 50, 45]);
        }
    }
}

module tactical_hardware_mounts() {
    // 3. ROOFTOP LIGHT BAR MOUNTING FLANGES: Anchors straight onto the roll cage roof halo
    color("Silver") {
        translate([-lightbar_length/2, -1200, 1100]) // Positioned at 1969 roof apex height
            difference() {
                cube([lightbar_length, 45, 12]);
                translate([20, 10, -1]) cube([lightbar_length - 40, 25, 14]); // Weight relief channel
            }
    }
    
    // 4. COCKPIT COMPUTER STAND PEDESTAL: Heavy dual-swivel post anchored to transmission tunnel frame
    color("LightGrey") {
        translate([180, -650, -80]) { // Positioned in passenger footwell section
            cylinder(d=50, h=400); // Main support pillar pipe
            translate([-100, -80, 400])
                cube([200, 160, 15]); // Standard 10" x 8" laptop/terminal display tray base
        }
    }
}

// --- Composite Tactical System Instantiation ---
union() {
    front_and_rear_push_bumpers();
    integrated_frame_winch();
    tactical_hardware_mounts();
}
