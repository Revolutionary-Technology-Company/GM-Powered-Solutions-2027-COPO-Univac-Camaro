/* ==============================================================================
 * REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
 * Subsystem: copo_system_registers.h (Master 32-Bit Parallel Control Matrix)
 * Architecture Reference: Teletank-controller-for-Alweg-Mark-II Framework
 * ============================================================================== */

#ifndef COPO_SYSTEM_REGISTERS_H
#define COPO_SYSTEM_REGISTERS_H

#include <stdint.h>

// --- 1. LOCOMOTION & PROPULSION MODULES (Bits 0-7) ---
#define COPO_REG_SQUARE_TOOTH_STEP1  (1 << 0)  // 0x00000001 - Low-speed staging launch mode
#define COPO_REG_SQUARE_TOOTH_STEP2  (1 << 1)  // 0x00000002 - Mid-range linear torque ramp
#define COPO_REG_SQUARE_TOOTH_STEP3  (1 << 2)  // 0x00000004 - Full parallel un-governed power (1350 Nm)
#define COPO_REG_REVERSE_POLARITY    (1 << 4)  // 0x00000010 - Directional field drum relay flip
#define COPO_REG_BREMBO_BRAKE_LOCK   (1 << 8)  // 0x00000100 - Solenoid pressure valve hold line

// --- 2. BIOMETRICS & TRACKING ENVELOPE (Bits 12-16) ---
#define COPO_REG_IRIS_CAM_ACTIVE     (1 << 12) // 0x00001000 - Powers the center wheel eye-tracking module
#define COPO_REG_PEDAL_CROSSCHECK_OK (1 << 13) // 0x00002000 - Dual-channel Hall encoder verification flag
#define COPO_REG_STEERING_EPAS_HIGH  (1 << 14) // 0x00004000 - Boosts firewall servo current under tracking drift
#define COPO_REG_WATCHDOG_HEARTBEAT  (1 << 30) // 0x40000000 - High-priority safety bit (Refreshes every 100ms)

// --- 3. REGENERATIVE SUSPENSION GRIDS (Bits 17-20) ---
#define COPO_REG_MULTIMUX_SELECT_A   (1 << 17) // 0x00020000 - Mux routing line select bit 0
#define COPO_REG_MULTIMUX_SELECT_B   (1 << 18) // 0x00040000 - Mux routing line select bit 1
#define COPO_REG_SIC_GATE_CHARGE_ON  (1 << 19) // 0x00080000 - Fires Silicon Carbide charging gates for shocks

#endif // COPO_SYSTEM_REGISTERS_H
