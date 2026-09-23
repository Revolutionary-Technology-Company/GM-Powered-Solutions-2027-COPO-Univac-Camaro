// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: otterbox_master_interior.scad (Unified Dual-Density Cockpit Shell)
// Core Partner: OtterBox Custom Automotive Interior Systems Division
// Center Origin (0,0,0) = Firewall Center point along Driveline Longitudinal Axis
// ====================================================================================

$fn = 120; // High-fidelity injection-mold tooling path resolution

// --- Core Structural Constraints (mm) ---
inch_to_mm         = 25.4;
cabin_width        = 56.0 * inch_to_mm;  // 1422.4 mm internal roof taper clearance
cabin_length       = 78.0 * inch_to_mm;  // 1981.2 mm longitudinal floor bed depth
shell_thickness_pc = 6.00;               // Structural Polycarbonate hard backing core
skin_thickness_tpu = 4.00;               // Impact-dissipating soft-touch rubber wrap

// Standardized Component clearance Pockets
din_radio_width    = 180.00;             // Standard DIN radio unit horizontal cutout room
din_radio_height   = 50.00;              // Standard DIN radio vertical clearance room
peltier_hvac_w     = 180.00;             // Fits copo_peltier_hvac.scad alignment core
dial_panel_w       = 120.00;             // Room for authentic 1969 sliding control sliders

module otterbox_floor_and_doors() {
    echo("COMPILING INTEGRATED OTTERBOX MULTI-MATERIAL INTERIOR MATRIX");
    // 1. FLOOR COVER PAN: Molded piece lining the frame rails to damp track vibration
    color("DarkCharcoal") {
        translate([-cabin_width/2, -cabin_length + 200, -120])
            cube([cabin_width, cabin_length, shell_thickness_pc]);
    }
    
    // 2. INNER DOOR SKINS: Hollowed to clear the aerospace manual window cables
    color("Black") {
        for (side = [-1, 1]) {
            scale([side, 1, 1])
                translate([cabin_width/2 - 10, -cabin_length/2, -100])
                    difference() {
                        cube([shell_thickness_pc, 900, 450]);
                        // Circular clearance bore to mount the 1969 hand-crank handle shaft
                        translate([-1, 450, 200])
                            rotate([0, 90, 0])
                                cylinder(d=35.0, h=shell_thickness_pc + 4);
                    }
        }
    }
}

module otterbox_integrated_dash() {
    // 3. MASTER DASHBOARD PANEL: Connects the Peltier AC vents, LED pods, and radio bay
    color("DimGrey") {
        translate([-cabin_width/2, 0, -50]) {
            difference() {
                // Main dashboard upper structure fascia block
                cube([cabin_width, 280, 240]);
                
                // CENTER CONSOLE RADIO STORAGE OPENING: Standard room left for new radio equipment
                translate([cabin_width/2 - din_radio_width/2, -1, 40])
                    cube([din_radio_width, 282, din_radio_height]);
                
                // 1969 MECHANICAL SLIDER CONTROL SWITCH POCKET
                translate([cabin_width/2 - dial_panel_w/2, -1, 110])
                    cube([dial_panel_w, 282, 35]);
                
                // SOLID-STATE PELTIER AC DUCT VENT HOUSINGS (Left and Right airflow routes)
                for (x = [60, cabin_width - 60 - peltier_hvac_w]) {
                    translate([x, -1, 160])
                        cube([peltier_hvac_w, 282, 45]);
                }
            }
        }
    }
}

module cage_retention_clamps() {
    // OtterBox-designed heavy-duty interlocking wrap-clamps.
    // Snaps directly onto the roll bars to eliminate interior noise or rattle under load.
    for (x_offset = [-cabin_width/3, cabin_width/3]) {
        translate([x_offset, 10, 100]) {
            color("Black") {
                difference() {
                    cube([55, 55, 40], center=true);
                    // Clamps tight to standard 1-5/8" (41.275mm) cage tubes
                    rotate([0, 90, 0])
                        cylinder(d=41.28, h=60, center=true);
                }
            }
        }
    }
}

// --- Composite Master Interior Integration Instantiation ---
union() {
    otterbox_floor_and_doors();
    otterbox_integrated_dash();
    cage_retention_clamps();
}
