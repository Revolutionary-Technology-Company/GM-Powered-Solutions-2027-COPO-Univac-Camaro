// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Module: dash_power_housing.scad (Avionics Isolated Cockpit Power Enclosure)
// Objective: Secure mechanical casing protecting the low-voltage master dash bus
// Center Origin (0,0,0) = Enclosure Base Geometrical Center
// ====================================================================================

$fn = 100; // CNC milling optimization finish parameters

// --- Parametric Enclosure Dimensions (mm) ---
box_length        = 180.00;
box_width         = 120.00;
box_height        = 75.00;
wall_thickness    = 4.50;  // Ruggedized enclosure thickness shielding cross-talk
cushion_register_d= 75.00; // Tailored mount register matching shocks.scad rubber cores

module master_avionics_enclosure() {
    difference() {
        // Outer raw protective enclosure brick
        translate([-box_length/2, -box_width/2, 0])
            cube([box_length, box_width, box_height]);
        
        // Internal component cavity mapping out assembly clearance space
        translate([-box_length/2 + wall_thickness, -box_width/2 + wall_thickness, wall_thickness])
            cube([box_length - (2*wall_thickness), box_width - (2*wall_thickness), box_height]);
            
        // Pre-drilled threaded wire exit portal for the upcoming custom dash harness
        translate([box_length/2 - 2, 0, box_height/2])
            rotate([0, 90, 0])
                cylinder(d=35.0, h=wall_thickness + 6, center=true); // Clears custom conduit sleeves
    }
}

module shock_isolation_mount_lugs() {
    // Generates left and right mounting ears that lock into your global rubber dampening cages
    for (side = [-1, 1]) {
        translate([side * (box_length/2 + 25), 0, 0]) {
            difference() {
                // Structural aluminum lug ear flange
                cylinder(d=cushion_register_d + 15, h=12, center=false);
                // Center borehole through which the rubber shock absorber isolator locks
                translate()
                    cylinder(d=cushion_register_d, h=14, center=false);
            }
        }
    }
}

// --- Composite Architecture Instantiation ---
union() {
    master_avionics_enclosure();
    shock_isolation_mount_lugs();
}
