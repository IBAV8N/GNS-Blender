
----- ANNUNCIATORS ---------------------------------------

function C90_lighting_annun()
	local bus1power = C90_rescale(0, 0, 24, 1, simDR_bus_volts[0])
	local bus2power = C90_rescale(0, 0, 24, 1, simDR_bus_volts[1])
	local bus3power = C90_rescale(0, 0, 24, 1, simDR_bus_volts[2])
	local buspower = math.max(bus1power, bus2power, bus3power)

	local dimMode = C90_ternary(
		(simDR_annun_generator_off[0] == 0 or simDR_annun_generator_off[1] == 0)            -- ANY GEN ON LINE
		and simDR_generic_lights_switch[0] < 0.1                                            -- OVHD FLOOD LIGHT OFF
		and C90DR_ovh_master == 1                                                           -- MASTER PANEL LIGHTS SWITCH IS ON
        and simDR_instr_brightness_ratio_man[2] > 0.4                                       -- PILOT FLIGHT LIGHTS ON
		and simDR_photo_auto_atten < 0.4                                                    -- AMBIENT LIGHT IS LOW
		, 0.5, 1.0)                                                                         -- SET LEVEL (DIM, BRIGHT)

	local wca_lightLevel = buspower * dimMode
    local ap_lightLevel = simDR_instr_brightness_ratio_man[15] * buspower
	local ind_lightLevel = simDR_instr_brightness_ratio_man[10] * C90DR_avionics_ind42_power_switch_pos

    function annun_lights(condition)      --IMC
        if C90DR_electrical_annun_test_on > 0 then return buspower
        elseif condition > 0 then return wca_lightLevel
        else return 0
        end
    end

    -- WARNING, CAUTION, AND ADVISORY ANNUNCIATORS
    C90DR_lighting_annun_blank              = C90DR_electrical_annun_test_on * buspower                                                       --IBAV8N, MaY22-22
    C90DR_lighting_annun_fuel_press_L 		= annun_lights(C90.warning.fuel_press_L)
    C90DR_lighting_annun_fuel_press_R		= annun_lights(C90.warning.fuel_press_R)
    C90DR_lighting_annun_oil_press_L		= annun_lights(C90.warning.oil_press_L)
    C90DR_lighting_annun_oil_press_R		= annun_lights(C90.warning.oil_press_R)
    C90DR_lighting_annun_inverter			= annun_lights(C90.warning.inverter)
    C90DR_lighting_annun_ap_fail			= annun_lights(C90.warning.ap_fail)
    C90DR_lighting_annun_ap_trim_fail		= annun_lights(C90.warning.ap_trim_fail)
    C90DR_lighting_annun_cabin_alt_hi		= annun_lights(C90.warning.cabin_alt_hi)
    C90DR_lighting_annun_cabin_door			= annun_lights(C90.warning.cabin_door)
    C90DR_lighting_annun_baggage_door		= annun_lights(C90.warning.baggage_door)
    C90DR_lighting_annun_engine_fire_L		= annun_lights(C90.warning.engine_fire_L)
    C90DR_lighting_annun_engine_fire_R		= annun_lights(C90.warning.engine_fire_R)
    C90DR_lighting_annun_dc_gen_L			= annun_lights(C90.warning.dc_gen_L)
    C90DR_lighting_annun_dc_gen_R			= annun_lights(C90.warning.dc_gen_R)
    C90DR_lighting_annun_no_fuel_xfr_L		= annun_lights(C90.warning.no_fuel_xfr_L)
    C90DR_lighting_annun_no_fuel_xfr_R		= annun_lights(C90.warning.no_fuel_xfr_R)
    C90DR_lighting_annun_rvs_not_ready		= annun_lights(C90.warning.rvs_not_ready)
    C90DR_lighting_annun_chip_detect_L		= annun_lights(C90.warning.chip_detect_L)
    C90DR_lighting_annun_chip_detect_R		= annun_lights(C90.warning.chip_detect_R)
    C90DR_lighting_annun_eng_ice_fail_L		= annun_lights(C90.warning.eng_ice_fail_L)
    C90DR_lighting_annun_eng_ice_fail_R		= annun_lights(C90.warning.eng_ice_fail_R)
    C90DR_lighting_annun_gen_tie_open_L		= annun_lights(C90.warning.gen_tie_open_L)
    C90DR_lighting_annun_gen_tie_open_R		= annun_lights(C90.warning.gen_tie_open_R)
    C90DR_lighting_annun_bat_tie_open		= annun_lights(C90.warning.bat_tie_open)
    C90DR_lighting_annun_pitch_trim_off		= annun_lights(C90.warning.pitch_trim_off)
    C90DR_lighting_annun_ignition_on_L		= annun_lights(C90.warning.ignition_on_L)
    C90DR_lighting_annun_ignition_on_R		= annun_lights(C90.warning.ignition_on_R)
    C90DR_lighting_annun_autofeather_L		= annun_lights(C90.warning.autofeather_L)
    C90DR_lighting_annun_autofeather_R		= annun_lights(C90.warning.autofeather_R)
    C90DR_lighting_annun_engine_antiice_L	= annun_lights(C90.warning.engine_antiice_L)
    C90DR_lighting_annun_engine_antiice_R	= annun_lights(C90.warning.engine_antiice_R)
    C90DR_lighting_annun_man_ties_close		= annun_lights(C90.warning.man_ties_close)
    C90DR_lighting_annun_fuel_crossfeed		= annun_lights(C90.warning.fuel_crossfeed)
    C90DR_lighting_annun_hyd_fluid_lo		= annun_lights(C90.warning.hyd_fluid_lo)
    C90DR_lighting_annun_battery_charge		= annun_lights(C90.warning.battery_charge)
    C90DR_lighting_annun_ext_power			= annun_lights(C90.warning.ext_power)
    C90DR_lighting_annun_ldg_taxi_light		= annun_lights(C90.warning.ldg_taxi_light)

    if simDR_acf_descrip ~= "C90B - G1000, Blackhawk" then
        -- PRESET FREQUENCY DISPLAYS ARE DIMMER THAN ACTIVE
	    simDR_switch_instr_brightness_ratio[13] = simDR_switch_instr_brightness_ratio[10] * 0.7
	    simDR_switch_instr_brightness_ratio[30] = simDR_switch_instr_brightness_ratio[10]
	    simDR_switch_instr_brightness_ratio[31] = simDR_switch_instr_brightness_ratio[10] * 0.7
        -- EFIS AUX POWER
        C90DR_lighting_annun_EFIS_aux_test      = C90_ternary(C90DR_electrical_annun_test_on > 0, buspower, C90_ternary(C90DR_avionics_EFIS_aux_pwr_on_switch_pos == -1, 1, 0))
	    C90DR_lighting_annun_EFIS_aux_on        = C90_ternary(C90DR_electrical_annun_test_on > 0, buspower, simDR_battery_3 * C90DR_avionics_EFIS_aux_pwr_on_switch_pos)
	    C90DR_lighting_annun_EFIS_aux_arm       = C90_ternary(C90DR_electrical_annun_test_on > 0, buspower, C90_ternary(C90DR_avionics_EFIS_aux_pwr_on_switch_pos == 1 and simDR_battery_3 == 0, 1, 0))
	    -- EADI AUTOPILOT DISCO
	    C90DR_autopilot_autopilot_disco	= C90.autopilot.acp.ap_disco * simDR_instr_brightness_ratio_man[11]
	    -- AUTOPILOT CONTROL PANEL
	    C90DR_lighting_annun_acp_yaw_eng		= C90.autopilot.acp.yaw_engaged * ap_lightLevel
	    C90DR_lighting_annun_acp_yaw_disc		= C90.autopilot.acp.yaw_disco * ap_lightLevel
	    C90DR_lighting_annun_acp_ap_eng			= C90.autopilot.acp.ap_engaged * ap_lightLevel
	    C90DR_lighting_annun_acp_ap_disc		= C90.autopilot.acp.ap_disco * ap_lightLevel
	    C90DR_lighting_annun_acp_t				= C90.autopilot.acp.trim_servo * ap_lightLevel
	    C90DR_lighting_annun_acp_ap_fail		= C90.autopilot.acp.ap_fail * ap_lightLevel
	    C90DR_lighting_annun_acp_a				= C90.autopilot.acp.aileron_servo * ap_lightLevel
	    C90DR_lighting_annun_acp_r				= C90.autopilot.acp.rudder_servo * ap_lightLevel
	    C90DR_lighting_annun_acp_e				= C90.autopilot.acp.elevator_servo * ap_lightLevel
	    C90DR_lighting_annun_acp_half			= C90.autopilot.acp.half_bank * ap_lightLevel
	    C90DR_lighting_annun_acp_sr				= C90.autopilot.acp.soft_ride * ap_lightLevel
	    C90DR_lighting_annun_acp_trim_fail		= C90.autopilot.acp.trim_fail * ap_lightLevel
	    C90DR_lighting_annun_acp_trim_op		= C90.autopilot.acp.trim_operating * ap_lightLevel
	    -- FLIGHT CONTROL PANEL
	    C90DR_lighting_annun_fcp_trim_fail		= C90.autopilot.fcp.trim_fail * ap_lightLevel
	    C90DR_lighting_annun_fcp_trim_operating	= C90.autopilot.fcp.trim_operating * ap_lightLevel
	    C90DR_lighting_annun_fcp_hdg			= C90.autopilot.fcp.hdg * ap_lightLevel
	    C90DR_lighting_annun_fcp_nav			= C90.autopilot.fcp.nav * ap_lightLevel
	    C90DR_lighting_annun_fcp_nav_armed		= C90.autopilot.fcp.nav_armed * ap_lightLevel
	    C90DR_lighting_annun_fcp_dr				= C90.autopilot.fcp.dr * ap_lightLevel
	    C90DR_lighting_annun_fcp_appr			= C90.autopilot.fcp.appr * ap_lightLevel
	    C90DR_lighting_annun_fcp_appr_armed		= C90.autopilot.fcp.appr_armed * ap_lightLevel
	    C90DR_lighting_annun_fcp_bc				= C90.autopilot.fcp.bc * ap_lightLevel
	    C90DR_lighting_annun_fcp_clm			= C90.autopilot.fcp.clm * ap_lightLevel
	    C90DR_lighting_annun_fcp_half_bank		= C90.autopilot.fcp.half_bank * ap_lightLevel
	    C90DR_lighting_annun_fcp_soft_ride		= C90.autopilot.fcp.soft_ride * ap_lightLevel
	    C90DR_lighting_annun_fcp_ap_fail		= C90.autopilot.fcp.ap_fail * ap_lightLevel
	    C90DR_lighting_annun_fcp_yaw_engaged	= C90.autopilot.fcp.yaw_engaged * ap_lightLevel
	    C90DR_lighting_annun_fcp_yaw_disco		= C90.autopilot.fcp.yaw_disco * ap_lightLevel
	    C90DR_lighting_annun_fcp_alt			= C90.autopilot.fcp.alt * ap_lightLevel
	    C90DR_lighting_annun_fcp_alt_sel		= C90.autopilot.fcp.alt_sel * ap_lightLevel
	    C90DR_lighting_annun_fcp_vs				= C90.autopilot.fcp.vs * ap_lightLevel
	    C90DR_lighting_annun_fcp_gs				= C90.autopilot.fcp.gs * ap_lightLevel
	    C90DR_lighting_annun_fcp_gs_armed		= C90.autopilot.fcp.gs_armed * ap_lightLevel
	    C90DR_lighting_annun_fcp_ias			= C90.autopilot.fcp.ias * ap_lightLevel
	    C90DR_lighting_annun_fcp_ga				= C90.autopilot.fcp.ga * ap_lightLevel
	    C90DR_lighting_annun_fcp_dsc			= C90.autopilot.fcp.dsc * ap_lightLevel
	    C90DR_lighting_annun_fcp_ap_engaged		= C90.autopilot.fcp.ap_engaged * ap_lightLevel
	    C90DR_lighting_annun_fcp_ap_disco		= C90.autopilot.fcp.ap_disco * ap_lightLevel
	    -- ALTITUDE ALERT
	    C90DR_lighting_annun_alt_alert			= C90_ternary(simDR_indicator_alt_alert_lit > 0, simDR_instr_brightness_ratio[16], 0)
        -- IND42 ANNUNCIATORS
	    C90DR_lighting_annun_ind42_channel_1	= C90_ternary(C90DR_avionics_ind42_channel == 1, ind_lightLevel, 0)
	    C90DR_lighting_annun_ind42_channel_2	= C90_ternary(C90DR_avionics_ind42_channel == 2, ind_lightLevel, 0)
	    C90DR_lighting_annun_ind42_channel_3	= C90_ternary(C90DR_avionics_ind42_channel == 3, ind_lightLevel, 0)
	    C90DR_lighting_annun_ind42_wpt			= 0
	    C90DR_lighting_annun_ind42_nm			= C90DR_avionics_ind42_power_switch_pos * ind_lightLevel
	    C90DR_lighting_annun_ind42_hld			= 0
	    C90DR_lighting_annun_ind42_kt			= C90_ternary(C90DR_avionics_ind42_mode == 1, ind_lightLevel, 0)
	    C90DR_lighting_annun_ind42_min			= C90_ternary(C90DR_avionics_ind42_mode == 2, ind_lightLevel, 0)
	    C90DR_lighting_annun_ind42_id			= C90_ternary(C90DR_avionics_ind42_mode == 0, ind_lightLevel, 0)

	    C90DR_lighting_annun_clt62_adf_act		= simDR_adf1_tone
	    C90DR_lighting_annun_clt62_adf_mem		= sto_adf1_stby
	    C90DR_lighting_annun_clt62_adf_rmt		= 0
	    C90DR_lighting_annun_clt62_adf_tx		= 0
	    C90DR_lighting_annun_clt62_adf_hld		= 0

        -- COCKPIT SPILL LIGHTS
	    C90DR_lighting_inclinometer_spill_L[3]  = simDR_avionics_power_on * C90_rescale(0, 0, 0.75, 1, simDR_instr_brightness_ratio[11] * buspower)
	    C90DR_lighting_inclinometer_spill_R[3]  = simDR_avionics_power_on * C90_rescale(0, 0, 0.75, 1, simDR_instr_brightness_ratio[11] * buspower)
	    C90DR_lighting_alt_alert_spill[3] 		= simDR_indicator_alt_alert_lit * simDR_instr_brightness_ratio[16] * 0.75 * buspower
    end
    if simDR_acf_descrip == "C90B EVO GNS" then
        -- COLLINS PLII RADIOS                              --IBAV8N, Aug24-23  add LR ATC ACT and TX 
	    C90DR_lighting_annun_clt22_com1_act		= C90_ternary(simDR_com1_fail ~= 6, 1, 0) * math.max(simDR_pilotedge_receive_com1, simDR_xpilot_com1_rx, simDR_com1_active) * simDR_avionics_power_on * simDR_com1_power
	    C90DR_lighting_annun_clt22_com1_mem		= sto_com1_stby
	    C90DR_lighting_annun_clt22_com1_rmt		= math.max(((1 - simDR_g430n1_nav_com_sel) * g430n1_navcom_rmt), g430n1_ff_com_rmt) * simDR_avionics_power_on * simDR_com1_power * gps530_power
	    C90DR_lighting_annun_clt22_com1_tx		= C90_ternary(simDR_com1_fail ~= 6, 1, 0) * math.max(simDR_pilotedge_transmit_com1, simDR_xpilot_ptt * simDR_xpilot_status, simDR_com1_tx) * C90_ternary(C90DR_avionics_mic_sel_dial_pos_pilot == 0, 1, 0)
	    C90DR_lighting_annun_clt22_com1_hld		= simDR_pilotedge_connected
	    C90DR_lighting_annun_clt22_com2_act		= C90_ternary(simDR_com2_fail ~= 6, 1, 0) * math.max(simDR_pilotedge_receive_com2, simDR_xpilot_com2_rx, simDR_com2_active) * simDR_avionics_power_on * simDR_com2_power
	    C90DR_lighting_annun_clt22_com2_mem		= sto_com2_stby
	    C90DR_lighting_annun_clt22_com2_rmt		= math.max(((1 - simDR_g430n2_nav_com_sel) * g430n2_navcom_rmt), g430n2_ff_com_rmt) * simDR_avionics_power_on * simDR_com2_power * gps430_power
	    C90DR_lighting_annun_clt22_com2_tx		= C90_ternary(simDR_com2_fail ~= 6, 1, 0) * math.max(simDR_pilotedge_transmit_com2, simDR_xpilot_ptt * simDR_xpilot_status, simDR_com2_tx) * C90_ternary(C90DR_avionics_mic_sel_dial_pos_pilot == 1, 1, 0)
	    C90DR_lighting_annun_clt22_com2_hld		= 0
	    C90DR_lighting_annun_clt32_nav1_act		= simDR_nav1_tone
	    C90DR_lighting_annun_clt32_nav1_mem		= sto_nav1_stby
	    C90DR_lighting_annun_clt32_nav1_rmt		= math.max((simDR_g430n1_nav_com_sel * g430n1_navcom_rmt), g430n1_ff_nav_rmt) * simDR_avionics_power_on * simDR_com1_power * gps530_power
	    C90DR_lighting_annun_clt32_nav1_tx		= 0
	    C90DR_lighting_annun_clt32_nav1_hld		= 0
	    C90DR_lighting_annun_clt32_nav2_act		= simDR_nav2_tone
	    C90DR_lighting_annun_clt32_nav2_mem		= sto_nav2_stby
	    C90DR_lighting_annun_clt32_nav2_rmt		= math.max((simDR_g430n2_nav_com_sel * g430n2_navcom_rmt), g430n2_ff_nav_rmt) * simDR_avionics_power_on * simDR_com2_power * gps430_power
	    C90DR_lighting_annun_clt32_nav2_tx		= 0
	    C90DR_lighting_annun_clt32_nav2_hld		= 0
	    C90DR_lighting_annun_clt92_atc_act		= 0
	    C90DR_lighting_annun_clt92_atc_mem		= 0
	    C90DR_lighting_annun_clt92_atc_rmt		= C90_ternary(simDR_fseconomy_finish == 1 and simDR_fseconomy_started == 1,1,0)
	    C90DR_lighting_annun_clt92_atc_tx		= C90_ternary(simDR_xpndr_fail == 0 and simDR_transponder_power > 1 and simDR_battery_on > 0 and simDR_avionics_power_on == 1, simDR_transponder_light, 0)
	    C90DR_lighting_annun_clt92_atc_hld		= C90_ternary(simDR_fseconomy_connected == 1 and simDR_fseconomy_started == 1, 1, simDR_fseconomy_connected * simDR_wigwag)
    end
    if simDR_acf_descrip == "C90B - G1000, Blackhawk" then
        -- G1000 prop-sync annunciator              --IMC
	    imcDR_annun_prop_sync_on = math.max(C90DR_electrical_annun_test_on * buspower, math.max(power, simDR_battery_3) * simDR_prop_sync_on * math.max(0.3, simDR_instr_brightness_ratio_man[3]))
        -- Standby battery annunciators
	    C90DR_lighting_annun_EFIS_aux_on = math.max(C90DR_electrical_annun_test_on * buspower, simDR_battery_3 * C90DR_avionics_EFIS_aux_pwr_on_switch_pos)
	    C90DR_lighting_annun_EFIS_aux_arm = math.max(C90DR_electrical_annun_test_on * buspower, C90_ternary(C90DR_avionics_EFIS_aux_pwr_on_switch_pos == 1 and simDR_battery_3 == 0, math.max(0.3, simDR_instr_brightness_ratio_man[3]), 0))
        function gfc710_lights(condition)      --IMC
            if condition then return wca_lightLevel * simDR_autopilot_powered
            elseif C90DR_electrical_annun_test_on > 0 then return buspower
            else return 0
            end
        end
        --G1000 autopilot panel
        local ap_state = simDR_autopilot_state
        --local ap_powered = simDR_autopilot_powered > 0
        C90DR_imc_gfc710_indicator_alt  = gfc710_lights(bit.band(ap_state, 0x4000)>0)-- Altitude hold engage
        C90DR_imc_gfc710_indicator_ap   = gfc710_lights(simDR_autopilot_servos_on > 0)
        C90DR_imc_gfc710_indicator_ap_1 = gfc710_lights(simDR_autopilot_source == 0)  -- AP source 1
        C90DR_imc_gfc710_indicator_ap_2 = gfc710_lights(simDR_autopilot_source == 1) -- AP source 2
        C90DR_imc_gfc710_indicator_apr  = gfc710_lights(simDR_autopilot_approach_status > 0)
        C90DR_imc_gfc710_indicator_bank = gfc710_lights(simDR_autopilot_half_bank > 0) 
        C90DR_imc_gfc710_indicator_bc   = gfc710_lights(simDR_autopilot_backcrs_status > 0)
        C90DR_imc_gfc710_indicator_fd   = gfc710_lights(simDR_annun_flight_director > 0) 
        C90DR_imc_gfc710_indicator_flc  = gfc710_lights(bit.band(ap_state, 0x40) > 0)  -- Flight level change engage
        C90DR_imc_gfc710_indicator_hdg  = gfc710_lights(bit.band(ap_state, 0x2) > 0)  -- Heading Select Engage
        C90DR_imc_gfc710_indicator_nav  = gfc710_lights(bit.band(ap_state, 0x200) > 0)  -- Nav Engaged
        C90DR_imc_gfc710_indicator_vnv  = gfc710_lights((bit.band(ap_state, 0x40000) > 0) or (bit.band(ap_state, 0x20000)) > 0)  
        C90DR_imc_gfc710_indicator_vs   = gfc710_lights(bit.band(ap_state, 0x10) > 0)  -- V/S Engage
        C90DR_imc_gfc710_indicator_yd   = gfc710_lights(simDR_annun_yaw_damper > 0)
        -- bitfield see: https://developer.x-plane.com/article/accessing-the-x-plane-autopilot-from-datarefs/

    end
end
