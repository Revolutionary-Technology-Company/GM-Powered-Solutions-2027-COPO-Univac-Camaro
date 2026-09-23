// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_fan_cooling.scad (Active Thermal Exhaust Blower Mounts)
// Core Standard: RT-Certified Centrifugal Thermal Infrastructure / Multi-Stage Fan Duct
// Center Origin (0,0,0) = Geometric Centerpoint of the 80mm Blower Intake Ring
// ====================================================================================

$fn = 100; // High-precision injection-molding toolpath resolution

// --- Parametric Fan Dimension Constants (mm) ---
inch_to_mm         = 25.4;
fan_casing_size    = 80.00;            // Standardized low-noise 80mm performance fan box
fan_thickness      = 25.00;            // Axial depth spacing parameter
intake_bore_dia    = 76.00;            // Optimized clear throat entry diameter
fastener_grid_space= 71.50;            // Center-to-center horizontal mounting screw grid
screw_hole_dia     = 4.30;             // Through-clearance for vibration-isolated M4 studs

module low_noise_blower_shroud() {
    echo("COMPILING RT HIGH-DURABILITY ELECTRONICS COOLING SHROUD ARRAY");
    color("DarkCharcoal") {
        difference() {
            // Main solid square fan housing envelope
            cube([fan_casing_size, fan_casing_size, fan_thickness], center=true);
            
            // Primary circular central air intake bore passage tunnel
            cylinder(d=intake_bore_dia, h=fan_thickness + 2, center=true);
            
            // 4-Corner Parametric Structural Fastener Drilling Pattern
            for (x = [-fastener_grid_space/2, fastener_grid_space/2]) {
                for (y = [-fastener_grid_space/2, fastener_grid_space/2]) {
                    translate([x, y, 0])
                        cylinder(d=screw_hole_dia, h=fan_thickness + 4, center=true);
                }
            }
        }
    }
}

module integrated_exhaust_louvers() {
    // Angled aerodynamic louver blades protecting the electronics bay from rain/dust back-blow
    color("DimGrey") {
        translate([0, 0, fan_thickness/2 + 2]) {
            difference() {
                cube([fan_casing_size - 4, fan_casing_size - 4, 6], center=true);
                
                // Cut directional 45-degree cooling vent slots across the surface window
                for (offset = [-30 : 15 : 30]) {
                    translate([0, offset, 0])
                        rotate([45, 0, 0])
                            cube([fan_casing_size - 10, 4.0, 15.0], center=true);
                }
            }
        }
    }
}

// --- Composite Thermal Module Instantiation ---
union() {
    low_noise_blower_shroud();
    integrated_exhaust_louvers();
}
