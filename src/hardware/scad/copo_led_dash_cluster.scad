// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_led_dash_cluster.scad (Authentic 1969 Custom LED Cluster Pods)
// Core Objective: Replicates 1969 dual-pod instrumentation layout using discrete LEDs
// Center Origin (0,0,0) = Geometric Centerpoint between Speedometer and Tachometer Axis
// ====================================================================================

$fn = 100; // High-fidelity CNC laser-cut and injection-molding resolution

// --- 1969 Factory Dashboard Cluster Parameters (mm) ---
inch_to_mm          = 25.4;
gauge_pod_outer_dia = 5.25 * inch_to_mm; // Exactly 133.35 mm original circular bezel diameter
pod_center_separation = 7.00 * inch_to_mm; // 177.8 mm center-to-center gauge distance
bezel_depth         = 65.00;              // Internal clearance volume depth
stepping_motor_bore = 35.00;              // Back-plate mounting pocket for step servos

module individual_gauge_pod() {
    difference() {
        // Main protective cylindrical pod structural housing barrel
        cylinder(d=gauge_pod_outer_dia, h=bezel_depth, center=true);
        
        // Internal cavity hollow for faceplates, light pipes, and needle clearances
        translate([0, 0, 5])
            cylinder(d=gauge_pod_outer_dia - 8, h=bezel_depth);
            
        // Precision rear center borehole to anchor the micro-stepping needle motor
        translate([0, 0, -bezel_depth/2 - 1])
            cylinder(d=stepping_motor_bore, h=10);
    }
}

module integrated_1969_bezel_assembly() {
    echo("COMPILING 1969 CUSTOM ANALOG-LED INSTRUMENTATION MASK");
    color("DarkCharcoal") {
        // Left Gauge Pod (Speedometer / Google Maps text vector arrow tracking layout)
        translate([-pod_center_separation/2, 0, 0])
            individual_gauge_pod();
            
        // Right Gauge Pod (Tachometer / Square-Tooth stator RPM monitoring display)
        translate([pod_center_separation/2, 0, 0])
            individual_gauge_pod();
            
        // Center structural joining plate (Replicates the factory 1969 center dash bezel cowl)
        translate([0, 0, -bezel_depth/2 + 2])
            cube([pod_center_separation, gauge_pod_outer_dia - 20, 4], center=true);
    }
}

module acrylic_light_pipe_guides() {
    // Models the internal clear acrylic rings that channel multi-segment LED colors 
    // to illuminate warning arcs (Green/Yellow/Red) around the physical gauge face edge.
    color("LightBlue", 0.5) {
        for (side = [-1, 1]) {
            translate([side * pod_center_separation/2, 0, 15])
                difference() {
                    cylinder(d=gauge_pod_outer_dia - 12, h=6, center=true);
                    cylinder(d=gauge_pod_outer_dia - 20, h=8, center=true);
                }
        }
    }
}

// --- Composite Dashboard Assembly Instantiation ---
union() {
    integrated_1969_bezel_assembly();
    acrylic_light_pipe_guides();
}
