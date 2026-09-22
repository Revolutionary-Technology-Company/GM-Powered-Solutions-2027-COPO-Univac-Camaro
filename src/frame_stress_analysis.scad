// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: tools/simulation/frame_stress_analysis.scad
// Objective: Parametric Structural Torsional Stress & Strain Matrix Calculation
// Validates structural deformation thresholds under peak instantaneous EV launching torque
// ====================================================================================

// --- FEA Computational Material Selection Parameters ---
// Set to 1 for 4130 Chromoly Steel Baseline; Set to 2 for Titanium Grade 5 Matrix
SIMULATED_MATERIAL_MODE = 2;

// --- Physical Constant Stress Properties ---
torque_instant_nm  = 1350.00;          // Peak instantaneous variable-reluctance stator torque load
track_slick_grip_mu = 1.65;            // Peak coefficient of friction for sticky Pirelli racing slicks
safety_factor_target = 2.5;            // Mandatory engineering safety headroom constant

// Material Mechanical Matrix Tables
youngs_modulus_gpa = (SIMULATED_MATERIAL_MODE == 2) ? 113.8 : 205.0; // Titanium Grade 5 vs Steel
yield_strength_mpa = (SIMULATED_MATERIAL_MODE == 2) ? 880.0 : 435.0; // Titanium yield limits are vastly higher
density_g_cm3      = (SIMULATED_MATERIAL_MODE == 2) ? 4.43  : 7.85;

// Geometric Chassis Boundary Constraints (mm)
crossmember_length = 609.6;            // Width box profile between front frame rails
tube_outer_radius  = 25.4;             // 2.00-inch diameter outer frame bracing tube
tube_wall_thickness= (SIMULATED_MATERIAL_MODE == 2) ? 3.5 : 2.1;
tube_inner_radius  = tube_outer_radius - tube_wall_thickness;

// --- Mathematical Structural Stress Equations ---

// 1. Calculate Area Moment of Inertia (I) for hollow round chassis structural member tube
area_moment_i = (PI / 4) * (pow(tube_outer_radius, 4) - pow(tube_inner_radius, 4));

// 2. Calculate Peak Bending Moment (M) under hard tire launching shock loads
applied_force_newtons = (torque_instant_nm * 1000) / (tube_outer_radius);
max_bending_moment = (applied_force_newtons * crossmember_length) / 4;

// 3. Compute Structural Flexural Strain Deflection (Sigma Stress)
max_stress_mpa = (max_bending_moment * tube_outer_radius) / area_moment_i;
calculated_safety_margin = yield_strength_mpa / max_stress_mpa;

// --- Diagnostic Status Readout Display Window Console Output ---
echo("=======================================================================");
echo("   REVOLUTIONARY TECH & UW PHYSICS MECHANICAL SIMULATION CORE ACTIVE   ");
echo("=======================================================================");
echo(str("EVALUATING ACTIVE MATERIAL MATRIX PROFILE: ", (SIMULATED_MATERIAL_MODE == 2) ? "TITANIUM_GRADE_5_AVIONICS" : "4130_CHROMOLY_STEEL"));
echo(str("-> Young's Modulus: ", youngs_modulus_gpa, " GPa"));
echo(str("-> Yield Material Strength: ", yield_strength_mpa, " MPa"));
echo(str("-> Calculated Structural Peak Stress Under Launch: ", max_stress_mpa, " MPa"));

if (max_stress_mpa > yield_strength_mpa) {
    echo(str("!!! CRITICAL FAILURE: CHASSIS TUBE SHEAR FAULT DETECTED !!!"));
} else {
    echo(str("-> STATUS: STRUCTURAL ENVELOPE SECURE. Safety Factor Multiplier: ", calculated_safety_margin));
}
echo("=======================================================================");

// Visually render the specific simulated crossmember element to evaluate bending deflection gradients
module render_stressed_crossmember() {
    color((max_stress_mpa > yield_strength_mpa) ? "Red" : ((SIMULATED_MATERIAL_MODE == 2) ? "LightBlue" : "LightGrey")) {
        rotate([0, 90, 0]) {
            difference() {
                cylinder(r=tube_outer_radius, h=crossmember_length, center=true);
                cylinder(r=tube_inner_radius, h=crossmember_length + 5, center=true);
            }
        }
    }
    // Anchor indicators pointing directly to your shocks.scad rubber cage integration locations
    for (offset = [-crossmember_length/2, crossmember_length/2]) {
        translate([offset, 0, -20])
            color("Gold") cylinder(d=40, h=20);
    }
}

render_stressed_crossmember();
