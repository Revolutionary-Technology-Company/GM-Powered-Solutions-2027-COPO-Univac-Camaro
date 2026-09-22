// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: chassis_body_interface.scad (Pre-Body Firewall & Perimeter Sealing Rim)
// Core Objective: Establishes structural mating rims and weatherproof wire passages
// Center Origin (0,0,0) = Firewall Center point along Driveline Longitudinal Axis
// ====================================================================================

$fn = 120; // High-precision geometric rendering resolution

// --- Structural Configuration Constants (mm) ---
inch_to_mm          = 25.4;
frame_rail_width    = 24.0 * inch_to_mm; // 609.6 mm width boundary
firewall_height     = 22.0 * inch_to_mm; // 558.8 mm clear vertical boundary
plate_thickness     = 4.0;               // 4mm high-tensile reinforcement plate

// Pass-Through Portal Dimensional Parameters (ACDelco Shielding Footprint)
conduit_bore_hv     = 65.0;  // High-Voltage 800V isolated main cable pass-through 
conduit_bore_logic  = 45.0;  // Low-Voltage Univac/Snap Circuit data trunk portal

module firewall_shear_plate() {
    color("DimGrey") {
        difference() {
            // Main solid firewall boundary wall protecting the cockpit area
            translate([-frame_rail_width/2, 0, -50])
                cube([frame_rail_width, plate_thickness, firewall_height]);
            
            // 1. HIGH-VOLTAGE PORTAL (Left Side - Routed to SiC Inverter Banks)
            translate([-frame_rail_width/4, 0, firewall_height/3])
                rotate([90, 0, 0])
                    cylinder(d=conduit_bore_hv, h=plate_thickness + 4, center=true);
                    
            // 2. LOW-VOLTAGE DATA PORTAL (Right Side - Routed to 16-State Hex Controllers)
            translate([frame_rail_width/4, 0, firewall_height/3])
                rotate([90, 0, 0])
                    cylinder(d=conduit_bore_logic, h=plate_thickness + 4, center=true);
        }
    }
}

module acdelco_perimeter_sealing_groove() {
    // Generates a continuous recessed structural track along the firewall edge.
    // Holds the form-molded ACDelco pressure-gasket to seal the upcoming body shell.
    color("DarkSlateGrey") {
        translate([-frame_rail_width/2 - 10, -5, -60])
            difference() {
                // Outer mechanical gasket retainment track
                cube([frame_rail_width + 20, plate_thickness + 10, 15]);
                // Internal 6mm x 6mm channel profile for liquid RTV/molded rubber insert
                translate([5, 2, 5])
                    cube([frame_rail_width + 10, 6, 12]);
            }
    }
}

module body_mount_alignment_tabs() {
    // Heavy-duty structural standoffs welded directly to the titanium/steel frame.
    // Provides the exact drilling pin locators to bolt the body panels down securely.
    for (x_offset = [-frame_rail_width/2, frame_rail_width/2]) {
        for (z_height = [50, firewall_height - 100]) {
            translate([x_offset + ((x_offset < 0) ? -15 : 0), -10, z_height]) {
                color("Silver") {
                    difference() {
                        cube([15, 25, 30]);
                        // Reamed hole for high-tensile chassis locating alignment pin
                        translate([7.5, 12.5, -1])
                            cylinder(d=10.2, h=32); // Clears standard M10 body alignment bolts
                    }
                }
            }
        }
    }
}

// --- Composite Structural System Instantiation ---
union() {
    firewall_shear_plate();
    acdelco_perimeter_sealing_groove();
    body_mount_alignment_tabs();
}
