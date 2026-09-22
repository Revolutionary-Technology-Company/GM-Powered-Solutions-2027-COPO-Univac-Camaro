/* ==============================================================================
 * REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
 * Subsystem: dash_power_firmware.c (Master Avionics Bus Supervision Node)
 * Core Function: Guarantees rock-solid low voltage power delivery to the cockpit
 * ============================================================================== */

#include <stdint.h>
#include <stdbool.h>

// --- Memory Mapped Avionics Power Control Registers ---
#define POWER_BUS_REG_BASE       0x40054000
#define REG_DASH_12V_SENSE_MV    (*(volatile uint32_t*)(POWER_BUS_REG_BASE + 0x00))
#define REG_DASH_5V_SENSE_MV     (*(volatile uint32_t*)(POWER_BUS_REG_BASE + 0x04))
#define REG_MASTER_BUS_RELAY_CMD (*(volatile uint32_t*)(POWER_BUS_REG_BASE + 0x08))

// --- System Telemetry Compliance Limits ---
#define TARGET_12V_MIN_MV        11400  // 11.4V Low voltage safety ceiling drop boundary
#define TARGET_12V_MAX_MV        12600  // 12.6V High voltage over-surge drop boundary
#define MASTER_BUS_ENABLE_BIT    (1 << 0)
#define MASTER_BUS_TRIP_BIT      (1 << 1)

/**
 * Monitors cockpit power rails. If a short circuit occurs while you 
 * are mounting and wiring dash components, it cuts power in microseconds.
 */
void verify_and_route_dash_power(void) {
    uint32_t current_12v_rail_mv = REG_DASH_12V_SENSE_MV;
    uint32_t current_5v_rail_mv  = REG_DASH_5V_SENSE_MV;

    // Evaluate live rail health against target window tolerances
    if (current_12v_rail_mv < TARGET_12V_MIN_MV || current_12v_rail_mv > TARGET_12V_MAX_MV) {
        /* EMERGENCY COCKPIT POWER FAULT PATHWAY:
         * Instantly trip the master isolation circuit breakers. Isolates 
         * dash equipment from raw 800V DC buck conversion lines. */
        REG_MASTER_BUS_RELAY_CMD = MASTER_BUS_TRIP_BIT;
        
        // Broadcast fault frame backward through the 36-bit Univac mainframe channel
        __asm__("YIELD"); 
        return;
    }

    /* NOMINAL STATUS PATHWAY: 
     * Voltage is perfectly flat and clean. Maintain power flow to the 
     * Phoenix master terminal strip so the team has active power ready at the dash. */
    REG_MASTER_BUS_RELAY_CMD = MASTER_BUS_ENABLE_BIT;
}
