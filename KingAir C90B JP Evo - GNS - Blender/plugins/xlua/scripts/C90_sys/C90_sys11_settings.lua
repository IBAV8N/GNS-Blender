----- RESTORE SWITCH/DIAL SETTINGS
function restore_gns_settings()
    print("EVO: 20. Restoring GNS Switch and Dial Settings.")
    local LineVal = ""
	local load = io.open(C90.persistence, "r")
    if load then
		for i = 1, 79 do
			LineVal = load:read("*line")
            if i == 1 then C90DR_ovh_flood = tonumber(LineVal) end
            if i == 2 then C90DR_ovh_indirect = tonumber(LineVal) end
            if i == 3 then C90DR_ovh_pilot_flt = tonumber(LineVal) end
            if i == 4 then C90DR_ovh_pilot_gyro = tonumber(LineVal) end
            if i == 5 then C90DR_ovh_eng_instru = tonumber(LineVal) end
            if i == 6 then C90DR_ovh_avion_pnl = tonumber(LineVal) end
            if i == 7 then C90DR_ovh_sub_pnl = tonumber(LineVal) end
            if i == 8 then C90DR_ovh_side_pnl = tonumber(LineVal) end
            if i == 9 then C90DR_ovh_copilot_gyro = tonumber(LineVal) end
            if i == 10 then C90DR_ovh_copilot_flt = tonumber(LineVal) end
            if i == 11 then C90DR_ovh_master = tonumber(LineVal) end
            if i == 12 then C90DR_avionics_auto_comm_switch_pos_pilot = tonumber(LineVal) end
            if i == 13 then C90DR_avionics_master_vol_ctrl_dial_pilot = tonumber(LineVal) end
            if i == 14 then C90DR_avionics_com1_audio_switch_pos_pilot = tonumber(LineVal) end
            if i == 15 then C90DR_avionics_com2_audio_switch_pos_pilot = tonumber(LineVal) end
            if i == 16 then simDR_audio_selection_nav1 = tonumber(LineVal) end
            if i == 17 then simDR_audio_selection_nav2 = tonumber(LineVal) end
            if i == 18 then C90DR_avionics_mkr_audio_bkn1_switch_pos_pilot = tonumber(LineVal) end
            if i == 19 then C90DR_avionics_mkr_audio_bkn2_switch_pos_pilot = tonumber(LineVal) end
            if i == 20 then simDR_audio_dme_enabled = tonumber(LineVal) end
            if i == 21 then simDR_audio_selection_adf1 = tonumber(LineVal) end
            if i == 22 then C90DR_avionics_mic_sel_dial_pos_pilot = tonumber(LineVal) autocomm() end    --laminar/c90/avionics/dial/mic_sel_pos_pilot
            if i == 23 then C90DR_avionics_hot_intph_switch_pos = tonumber(LineVal) end
            if i == 24 then C90DR_avionics_dme_channel_sel_switch_pos = tonumber(LineVal) end
            if i == 25 then C90DR_avionics_encd_atim_sel_switch_pos = tonumber(LineVal) end
            if i == 26 then C90DR_avionics_mkr_bkn_sense_switch_pos = tonumber(LineVal) end
            if i == 27 then C90DR_avionics_gps_power_switch_pos = tonumber(LineVal) end
            if i == 28 then C90DR_avionics_paging_vol_dial = tonumber(LineVal) end
            if i == 29 then C90DR_avionics_interphone_vol_dial = tonumber(LineVal) end
            if i == 30 then C90DR_avionics_dme_vol_dial = tonumber(LineVal) end
            if i == 31 then C90DR_avionics_mkr_bkn_vol_dial = tonumber(LineVal) end
            if i == 32 then simDR_generic_lights_switch[4] = tonumber(LineVal) end                      --Bar light
            if i == 33 then C90DR_lighting_cabin_brt_dim_switch_pos = tonumber(LineVal) end             --Cabin light switch
            if i == 34 then simDR_generic_lights_switch[5] = tonumber(LineVal) end                      --Cabin lights
	        if i == 35 then C90DR_volt_bus_sel_dial = tonumber(LineVal) end
	        if i == 36 then C90DR_pilot_shade_flip = tonumber(LineVal) end
	        if i == 37 then C90DR_copilot_shade_flip = tonumber(LineVal) end
            if i == 38 then simDR_engine_antiice_left = tonumber(LineVal) end
	        if i == 39 then simDR_engine_antiice_right = tonumber(LineVal) end
            if i == 40 then C90DR_pneumatic_bleed_air_switch_pos_L = tonumber(LineVal) end
            if i == 41 then C90DR_pneumatic_bleed_air_switch_pos_R = tonumber(LineVal) end
            if i == 42 then simDR_pressure_cabin_alt_ft = tonumber(LineVal) end
            if i == 43 then C90DR_airCon_cabin_temp_dial = tonumber(LineVal) end
            if i == 44 then simDR_elevator_trim = tonumber(LineVal) end
            if i == 45 then C90DR_avionics_nav_data_sel_dial_pos = tonumber(LineVal) end
            if i == 46 then C90DR_avionics_EFIS_map_mode_sel_dial_pos = tonumber(LineVal) end
            if i == 47 then C90DR_avionics_crs_sensor_sel_dial_pos = tonumber(LineVal) end
            if i == 48 then simDR_fuel_quantity_l_wing = tonumber(LineVal) end
            if i == 49 then simDR_fuel_quantity_r_wing = tonumber(LineVal) end
            if i == 50 then simDR_fuel_quantity_l_nacelle = tonumber(LineVal) end
            if i == 51 then simDR_fuel_quantity_r_nacelle = tonumber(LineVal) end
            if i == 52 then simDR_fuel_firewall_vlv_L = tonumber(LineVal) end
            if i == 53 then simDR_fuel_firewall_vlv_R = tonumber(LineVal) end
            if i == 54 then C90DR_fuel_firewall_switch_guard_L = tonumber(LineVal) end
            if i == 55 then C90DR_fuel_firewall_switch_guard_R = tonumber(LineVal) end
            if i == 56 then simDR_avitab_power = tonumber(LineVal) end
            if i == 57 then C90DR_autopilot_altSel100_switch_pos = tonumber(LineVal) end
            if i == 58 then C90DR_avionics_ind42_power_switch_pos = tonumber(LineVal) end
            if i == 59 then C90DR_avionics_ind42_mode = tonumber(LineVal) end
            if i == 60 then C90DR_avionics_ind42_channel = tonumber(LineVal) end
            if i == 61 then simDR_transponder_power = tonumber(LineVal) end
            if i == 62 then C90DR_avionics_adf1_vol_control_dial = tonumber(LineVal) end
            if i == 63 then C90DR_avionics_EFIS_eadi_brightness = tonumber(LineVal) end
            if i == 64 then C90DR_avionics_EFIS_ehsi_brightness = tonumber(LineVal) end
            if i == 65 then C90DR_avionics_EFIS_fd_switch_pos = tonumber(LineVal) end
            if i == 66 then C90DR_avionics_EFIS_power_switch_pos = tonumber(LineVal) end
            if i == 67 then C90DR_fltctrl_rudder_boost_switch_pos = tonumber(LineVal) end
            if i == 68 then C90DR_fltctrl_elev_trim_control_switch_pos = tonumber(LineVal) end
            --GNS and GTN diverge here
            if i == 69 then simDR_com1_power = tonumber(LineVal) end
            if i == 70 then simDR_com2_power = tonumber(LineVal) end
            if i == 71 then simDR_nav1_power = tonumber(LineVal) end
            if i == 72 then simDR_nav2_power = tonumber(LineVal) end
            if i == 73 then simDR_adf1_power = tonumber(LineVal) end
            if i == 74 then C90DR_avionics_com1_vol_control_dial = tonumber(LineVal) end
            if i == 75 then C90DR_avionics_com2_vol_control_dial = tonumber(LineVal) end
            if i == 76 then C90DR_avionics_nav1_vol_control_dial = tonumber(LineVal) end
            if i == 77 then C90DR_avionics_nav2_vol_control_dial = tonumber(LineVal) end
            if i == 78 then simDR_cabindoor = tonumber(LineVal) end
            if i == 79 then simDR_avitab_enabled = tonumber(LineVal) end
        end
    end
end

function gns_overrides()
    print("EVO: 20b. Executing GNS overrrides")
    run_at_interval(crossfill, 3)
end

function restore_gtn_settings()
    print("EVO: 20a. Restoring GTN Switch and Dial Settings.")
    local LineVal = ""
	local load = io.open(C90.persistence, "r")
    if load then
		for i = 1, 74 do
			LineVal = load:read("*line")
            if i == 1 then C90DR_ovh_flood = tonumber(LineVal) end
            if i == 2 then C90DR_ovh_indirect = tonumber(LineVal) end
            if i == 3 then C90DR_ovh_pilot_flt = tonumber(LineVal) end
            if i == 4 then C90DR_ovh_pilot_gyro = tonumber(LineVal) end
            if i == 5 then C90DR_ovh_eng_instru = tonumber(LineVal) end
            if i == 6 then C90DR_ovh_avion_pnl = tonumber(LineVal) end
            if i == 7 then C90DR_ovh_sub_pnl = tonumber(LineVal) end
            if i == 8 then C90DR_ovh_side_pnl = tonumber(LineVal) end
            if i == 9 then C90DR_ovh_copilot_gyro = tonumber(LineVal) end
            if i == 10 then C90DR_ovh_copilot_flt = tonumber(LineVal) end
            if i == 11 then C90DR_ovh_master = tonumber(LineVal) end
            if i == 12 then C90DR_avionics_auto_comm_switch_pos_pilot = tonumber(LineVal) end
            if i == 13 then C90DR_avionics_master_vol_ctrl_dial_pilot = tonumber(LineVal) end
            if i == 14 then C90DR_avionics_com1_audio_switch_pos_pilot = tonumber(LineVal) end
            if i == 15 then C90DR_avionics_com2_audio_switch_pos_pilot = tonumber(LineVal) end
            if i == 16 then simDR_audio_selection_nav1 = tonumber(LineVal) end
            if i == 17 then simDR_audio_selection_nav2 = tonumber(LineVal) end
            if i == 18 then C90DR_avionics_mkr_audio_bkn1_switch_pos_pilot = tonumber(LineVal) end
            if i == 19 then C90DR_avionics_mkr_audio_bkn2_switch_pos_pilot = tonumber(LineVal) end
            if i == 20 then simDR_audio_dme_enabled = tonumber(LineVal) end
            if i == 21 then simDR_audio_selection_adf1 = tonumber(LineVal) end
            if i == 22 then C90DR_avionics_mic_sel_dial_pos_pilot = tonumber(LineVal) autocomm() end    --laminar/c90/avionics/dial/mic_sel_pos_pilot
            if i == 23 then C90DR_avionics_hot_intph_switch_pos = tonumber(LineVal) end
            if i == 24 then C90DR_avionics_dme_channel_sel_switch_pos = tonumber(LineVal) end
            if i == 25 then C90DR_avionics_encd_atim_sel_switch_pos = tonumber(LineVal) end
            if i == 26 then C90DR_avionics_mkr_bkn_sense_switch_pos = tonumber(LineVal) end
            if i == 27 then C90DR_avionics_gps_power_switch_pos = tonumber(LineVal) end
            if i == 28 then C90DR_avionics_paging_vol_dial = tonumber(LineVal) end
            if i == 29 then C90DR_avionics_interphone_vol_dial = tonumber(LineVal) end
            if i == 30 then C90DR_avionics_dme_vol_dial = tonumber(LineVal) end
            if i == 31 then C90DR_avionics_mkr_bkn_vol_dial = tonumber(LineVal) end
            if i == 32 then simDR_generic_lights_switch[4] = tonumber(LineVal) end                      --Bar light
            if i == 33 then C90DR_lighting_cabin_brt_dim_switch_pos = tonumber(LineVal) end             --Cabin light switch
            if i == 34 then simDR_generic_lights_switch[5] = tonumber(LineVal) end                      --Cabin lights
	        if i == 35 then C90DR_volt_bus_sel_dial = tonumber(LineVal) end
	        if i == 36 then C90DR_pilot_shade_flip = tonumber(LineVal) end
	        if i == 37 then C90DR_copilot_shade_flip = tonumber(LineVal) end
            if i == 38 then simDR_engine_antiice_left = tonumber(LineVal) end
	        if i == 39 then simDR_engine_antiice_right = tonumber(LineVal) end
            if i == 40 then C90DR_pneumatic_bleed_air_switch_pos_L = tonumber(LineVal) end
            if i == 41 then C90DR_pneumatic_bleed_air_switch_pos_R = tonumber(LineVal) end
            if i == 42 then simDR_pressure_cabin_alt_ft = tonumber(LineVal) end
            if i == 43 then C90DR_airCon_cabin_temp_dial = tonumber(LineVal) end
            if i == 44 then simDR_elevator_trim = tonumber(LineVal) end
            if i == 45 then C90DR_avionics_nav_data_sel_dial_pos = tonumber(LineVal) end
            if i == 46 then C90DR_avionics_EFIS_map_mode_sel_dial_pos = tonumber(LineVal) end
            if i == 47 then C90DR_avionics_crs_sensor_sel_dial_pos = tonumber(LineVal) end
            if i == 48 then simDR_fuel_quantity_l_wing = tonumber(LineVal) end
            if i == 49 then simDR_fuel_quantity_r_wing = tonumber(LineVal) end
            if i == 50 then simDR_fuel_quantity_l_nacelle = tonumber(LineVal) end
            if i == 51 then simDR_fuel_quantity_r_nacelle = tonumber(LineVal) end
            if i == 52 then simDR_fuel_firewall_vlv_L = tonumber(LineVal) end
            if i == 53 then simDR_fuel_firewall_vlv_R = tonumber(LineVal) end
            if i == 54 then C90DR_fuel_firewall_switch_guard_L = tonumber(LineVal) end
            if i == 55 then C90DR_fuel_firewall_switch_guard_R = tonumber(LineVal) end
            if i == 56 then simDR_avitab_power = tonumber(LineVal) end
            if i == 57 then C90DR_autopilot_altSel100_switch_pos = tonumber(LineVal) end
            if i == 58 then C90DR_avionics_ind42_power_switch_pos = tonumber(LineVal) end
            if i == 59 then C90DR_avionics_ind42_mode = tonumber(LineVal) end
            if i == 60 then C90DR_avionics_ind42_channel = tonumber(LineVal) end
            if i == 61 then simDR_transponder_power = tonumber(LineVal) end
            if i == 62 then C90DR_avionics_adf1_vol_control_dial = tonumber(LineVal) end
            if i == 63 then C90DR_avionics_EFIS_eadi_brightness = tonumber(LineVal) end
            if i == 64 then C90DR_avionics_EFIS_ehsi_brightness = tonumber(LineVal) end
            if i == 65 then C90DR_avionics_EFIS_fd_switch_pos = tonumber(LineVal) end
            if i == 66 then C90DR_avionics_EFIS_power_switch_pos = tonumber(LineVal) end
            if i == 67 then C90DR_fltctrl_rudder_boost_switch_pos = tonumber(LineVal) end
            if i == 68 then C90DR_fltctrl_elev_trim_control_switch_pos = tonumber(LineVal) end
            --GNS and GTN diverge here
            if i == 69 then C90DR_avionics_gtn_volume[0] = tonumber(LineVal) end
            if i == 70 then C90DR_avionics_gtn_volume[1] = tonumber(LineVal) end
            if i == 71 then C90DR_avionics_gtn_sd_card_pos[0] = tonumber(LineVal) end
            if i == 72 then C90DR_avionics_gtn_sd_card_pos[1] = tonumber(LineVal) end
            if i == 73 then simDR_cabindoor = tonumber(LineVal) end
            if i == 74 then simDR_avitab_enabled = tonumber(LineVal) end
        end
    end
end

function gtn_overrides()
    print("EVO: 20b. Executing GTN overrrides")
    simDR_com1_power = 1
    simDR_com2_power = 1
    simDR_nav1_power = 1
    simDR_nav2_power = 1
    simDR_adf1_power = 2
    simDR_adf2_power = 2
    simDR_gps530_power = 1
    simDR_gps430_power = 1
    run_at_interval(C90_gtn_brightness, 60)
end

function restore_g1000_settings()
    print("EVO: 20a. Restoring G1000 Switch and Dial Settings.")
    local LineVal = ""
	local load = io.open(C90.persistence, "r")
    if load then
		for i = 1, 41 do
			LineVal = load:read("*line")
            if i == 1 then C90DR_ovh_flood = tonumber(LineVal) end
            if i == 2 then C90DR_ovh_indirect = tonumber(LineVal) end
            if i == 3 then C90DR_ovh_pilot_flt = tonumber(LineVal) end
            if i == 4 then C90DR_ovh_pilot_gyro = tonumber(LineVal) end
            if i == 5 then C90DR_ovh_eng_instru = tonumber(LineVal) end
            if i == 6 then C90DR_ovh_avion_pnl = tonumber(LineVal) end
            if i == 7 then C90DR_ovh_sub_pnl = tonumber(LineVal) end
            if i == 8 then C90DR_ovh_side_pnl = tonumber(LineVal) end
            if i == 9 then C90DR_ovh_copilot_gyro = tonumber(LineVal) end
            if i == 10 then C90DR_ovh_copilot_flt = tonumber(LineVal) end
            if i == 11 then C90DR_ovh_master = tonumber(LineVal) end
            if i == 12 then simDR_generic_lights_switch[4] = tonumber(LineVal) end                      --Bar light
            if i == 13 then C90DR_lighting_cabin_brt_dim_switch_pos = tonumber(LineVal) end             --Cabin light switch
            if i == 14 then simDR_generic_lights_switch[5] = tonumber(LineVal) end                      --Cabin lights
	        if i == 15 then C90DR_volt_bus_sel_dial = tonumber(LineVal) end
	        if i == 16 then C90DR_pilot_shade_flip = tonumber(LineVal) end
	        if i == 17 then C90DR_copilot_shade_flip = tonumber(LineVal) end
            if i == 18 then simDR_engine_antiice_left = tonumber(LineVal) end
	        if i == 19 then simDR_engine_antiice_right = tonumber(LineVal) end
            if i == 20 then C90DR_pneumatic_bleed_air_switch_pos_L = tonumber(LineVal) end
            if i == 21 then C90DR_pneumatic_bleed_air_switch_pos_R = tonumber(LineVal) end
            if i == 22 then simDR_pressure_cabin_alt_ft = tonumber(LineVal) end
            if i == 23 then C90DR_airCon_cabin_temp_dial = tonumber(LineVal) end
            if i == 24 then simDR_elevator_trim = tonumber(LineVal) end
            if i == 25 then simDR_fuel_quantity_l_wing = tonumber(LineVal) end
            if i == 26 then simDR_fuel_quantity_r_wing = tonumber(LineVal) end
            if i == 27 then simDR_fuel_quantity_l_nacelle = tonumber(LineVal) end
            if i == 28 then simDR_fuel_quantity_r_nacelle = tonumber(LineVal) end
            if i == 29 then simDR_fuel_firewall_vlv_L = tonumber(LineVal) end
            if i == 30 then simDR_fuel_firewall_vlv_R = tonumber(LineVal) end
            if i == 31 then C90DR_fuel_firewall_switch_guard_L = tonumber(LineVal) end
            if i == 32 then C90DR_fuel_firewall_switch_guard_R = tonumber(LineVal) end
            if i == 33 then simDR_artificial_horizon_adjust_stby = tonumber(LineVal) end
            if i == 34 then simDR_barometer_setting_in_hg_stby = tonumber(LineVal) end
            if i == 35 then simDR_avitab_power = tonumber(LineVal) end
            if i == 36 then simDR_cabindoor = tonumber(LineVal) end
            if i == 37 then C90DR_pilot_shade_slide = tonumber(LineVal) end
            if i == 38 then C90DR_copilot_shade_slide = tonumber(LineVal) end
            if i == 39 then simDR_avitab_enabled = tonumber(LineVal) end
            if i == 40 then C90DR_fltctrl_rudder_boost_switch_pos = tonumber(LineVal) end
            if i == 41 then C90DR_fltctrl_elev_trim_control_switch_pos = tonumber(LineVal) end
        end
    end
end

function g1000_overrides()
    print("EVO: 20b. Executing G1000 overrides")
    simDR_audio_selection_adf2_copilot = 1
end

----- SAVE SWITCH/DIAL SETTINGS
function save_gns_settings()
    print("EVO: 22. Saving GNS Switch and Dial Settings.")
	local save = io.open(C90.persistence, "w")
	if save then
		save:write(C90DR_ovh_flood.."\n")                                   --LINE 1:   Overhead flood
        save:write(C90DR_ovh_indirect.."\n")                                --LINE 2:   Panel indirect lights
        save:write(C90DR_ovh_pilot_flt.."\n")                               --LINE 3:   Pilot flight lights
        save:write(C90DR_ovh_pilot_gyro.."\n")                              --LINE 4:   Pilot gyro lights
        save:write(C90DR_ovh_eng_instru.."\n")                              --LINE 5:   Engine lights
        save:write(C90DR_ovh_avion_pnl.."\n")                               --LINE 6:   Avionics panel lights
        save:write(C90DR_ovh_sub_pnl.."\n")                                 --LINE 7:   Subpanel lights
        save:write(C90DR_ovh_side_pnl.."\n")                                --LINE 8:   Sidepanel lights
        save:write(C90DR_ovh_copilot_gyro.."\n")                            --LINE 9:   Copilot's gyro lights
        save:write(C90DR_ovh_copilot_flt.."\n")                             --LINE 10:  Copilot's flight lights
        save:write(C90DR_ovh_master.."\n")                                  --LINE 11:  Overhead master lights
        save:write(C90DR_avionics_auto_comm_switch_pos_pilot.."\n")         --LINE 12:  Autocomm switch
        save:write(C90DR_avionics_master_vol_ctrl_dial_pilot.."\n")         --LINE 13:  Radio master volume control
        save:write(C90DR_avionics_com1_audio_switch_pos_pilot.."\n")        --LINE 14:  COM1 monitor
        save:write(C90DR_avionics_com2_audio_switch_pos_pilot.."\n")        --LINE 15:  COM2 monitor
        save:write(simDR_audio_selection_nav1.."\n")                        --LINE 16:  NAV1 monitor
        save:write(simDR_audio_selection_nav2.."\n")                        --LINE 17:  NAV2 monitor
        save:write(C90DR_avionics_mkr_audio_bkn1_switch_pos_pilot.."\n")    --LINE 18:  Marker beacon 1 monitor
        save:write(C90DR_avionics_mkr_audio_bkn2_switch_pos_pilot.."\n")    --LINE 19:  Marker beacon 2 monitor
        save:write(simDR_audio_dme_enabled.."\n")                           --LINE 20:  DME monitor
        save:write(simDR_audio_selection_adf1.."\n")                        --LINE 21:  ADF monitor
        save:write(C90DR_avionics_mic_sel_dial_pos_pilot.."\n")             --LINE 22:  Comm1 mic select dial
        save:write(C90DR_avionics_hot_intph_switch_pos.."\n")               --LINE 23:  Hot interphone
        save:write(C90DR_avionics_dme_channel_sel_switch_pos.."\n")         --LINE 24:  DME channel select
        save:write(C90DR_avionics_encd_atim_sel_switch_pos.."\n")           --LINE 25:  Encoder select
        save:write(C90DR_avionics_mkr_bkn_sense_switch_pos.."\n")           --LINE 26:  Marker beacon Hi-Lo select
		save:write(C90DR_avionics_gps_power_switch_pos.."\n")               --LINE 27:  GPS power
        save:write(C90DR_avionics_paging_vol_dial.."\n")                    --LINE 28:  Paging volume
        save:write(C90DR_avionics_interphone_vol_dial.."\n")                --LINE 29:  Interphone volume
        save:write(C90DR_avionics_dme_vol_dial.."\n")                       --LINE 30:  DME volume
        save:write(C90DR_avionics_mkr_bkn_vol_dial.."\n")                   --LINE 31:  Marker beacon volume
        save:write(simDR_generic_lights_switch[4].."\n")                    --LINE 32:  Bar light
        save:write(C90DR_lighting_cabin_brt_dim_switch_pos.."\n")           --LINE 33:  Cabin light switch
        save:write(simDR_generic_lights_switch[5].."\n")                    --LINE 34:  Cabin lights
        save:write(C90DR_volt_bus_sel_dial.."\n")                           --LINE 35:  Overhead voltage select dial
		save:write(C90DR_pilot_shade_flip.."\n")                            --LINE 36:  Pilot's shade
		save:write(C90DR_copilot_shade_flip.."\n")                          --LINE 37:  Copilot's shade
        save:write(simDR_engine_antiice_left.."\n")                         --LINE 38:  Left engine anti-ice
        save:write(simDR_engine_antiice_right.."\n")                        --LINE 39:  Right engine anti-ice
		save:write(C90DR_pneumatic_bleed_air_switch_pos_L.."\n")            --LINE 40:  Left bleed
		save:write(C90DR_pneumatic_bleed_air_switch_pos_R.."\n")            --LINE 41:  Right bleed
		save:write(simDR_pressure_cabin_alt_ft.."\n")                       --LINE 42:  Cabin pressure setting
        save:write(C90DR_airCon_cabin_temp_dial.."\n")                      --LINE 43:  Cabin temperature knob degree setting
        save:write(simDR_elevator_trim.."\n")                               --LINE 44:  Elevator trim
        save:write(C90DR_avionics_nav_data_sel_dial_pos.."\n")              --LINE 45:  Nav Data Select: GSP, Wind...
        save:write(C90DR_avionics_EFIS_map_mode_sel_dial_pos.."\n")         --LINE 46:  EFIS map mode
        save:write(C90DR_avionics_crs_sensor_sel_dial_pos.."\n")            --LINE 47:  PRE/ACT/XFR dial
        save:write(simDR_fuel_quantity_l_wing.."\n")                        --LINE 48:  Fuel L wing
        save:write(simDR_fuel_quantity_r_wing.."\n")                        --LINE 49:  Fuel R wing
        save:write(simDR_fuel_quantity_l_nacelle.."\n")                     --LINE 50:  Fuel L nacelle
        save:write(simDR_fuel_quantity_r_nacelle.."\n")                     --LINE 51:  Fuel R nacelle
        save:write(simDR_fuel_firewall_vlv_L.."\n")                         --LINE 52:  Left firewall valve
        save:write(simDR_fuel_firewall_vlv_R.."\n")                         --LINE 53:  Right firewall valve
        save:write(C90DR_fuel_firewall_switch_guard_L.."\n")                --LINE 54:  Left firewall guard
        save:write(C90DR_fuel_firewall_switch_guard_R.."\n")                --LINE 55:  Right firewall guard
        save:write(avitab_on.."\n")                                         --LINE 56:  Avitab power global variable
        save:write(C90DR_autopilot_altSel100_switch_pos.."\n")              --LINE 57:  Alt select 1k knob position
	    save:write(C90DR_avionics_ind42_power_switch_pos.."\n")             --LINE 58:  IND-42 power
	    save:write(C90DR_avionics_ind42_mode.."\n")                         --LINE 59:  IND-42 mode
		save:write(C90DR_avionics_ind42_channel.."\n")                      --LINE 60:  IND-42 channel
		save:write(simDR_transponder_power.."\n")                           --LINE 61:  XPNDR power
		save:write(C90DR_avionics_adf1_vol_control_dial.."\n")              --LINE 62:  ADF volume
		save:write(C90DR_avionics_EFIS_eadi_brightness.."\n")               --LINE 63:  EADI brightness dial
		save:write(C90DR_avionics_EFIS_ehsi_brightness.."\n")               --LINE 64:  EHSI brightness dial
		save:write(C90DR_avionics_EFIS_fd_switch_pos.."\n")                 --LINE 65:  flight director
		save:write(C90DR_avionics_EFIS_power_switch_pos.."\n")              --LINE 66:  EFIS power
		save:write(C90DR_fltctrl_rudder_boost_switch_pos.."\n")             --LINE 67:  rudder boost
		save:write(C90DR_fltctrl_elev_trim_control_switch_pos.."\n")        --LINE 68:  elevator trim
        --GNS and GTN diverge here
		save:write(simDR_com1_power.."\n")                                  --LINE 69:  COM1 power
		save:write(simDR_com2_power.."\n")                                  --LINE 70:  COM2 power
		save:write(simDR_nav1_power.."\n")                                  --LINE 71:  NAV1 power
		save:write(simDR_nav2_power.."\n")                                  --LINE 72:  NAV2 power
		save:write(simDR_adf1_power.."\n")                                  --LINE 73:  ADF1 power
		save:write(C90DR_avionics_com1_vol_control_dial.."\n")              --LINE 74:  COM1 volume
		save:write(C90DR_avionics_com2_vol_control_dial.."\n")              --LINE 75:  COM2 volume
		save:write(C90DR_avionics_nav1_vol_control_dial.."\n")              --LINE 76:  NAV1 volume
		save:write(C90DR_avionics_nav2_vol_control_dial.."\n")              --LINE 77:  NAV2 volume
		save:write(simDR_cabindoor.."\n")                                   --LINE 78:  Cabin door
		save:write(simDR_avitab_enabled.."\n")                              --LINE 79:  Avitab yoke-mounted
		save:close()	--@pilotmarcog 4-01-2022 - fix log error io.close statement
    end
end

function save_gtn_settings()
    print("EVO: 22. Saving GTN Switch and Dial Settings.")
	local save = io.open(C90.persistence, "w")
	if save then
		save:write(C90DR_ovh_flood.."\n")                                   --LINE 1:   Overhead flood
        save:write(C90DR_ovh_indirect.."\n")                                --LINE 2:   Panel indirect lights
        save:write(C90DR_ovh_pilot_flt.."\n")                               --LINE 3:   Pilot flight lights
        save:write(C90DR_ovh_pilot_gyro.."\n")                              --LINE 4:   Pilot gyro lights
        save:write(C90DR_ovh_eng_instru.."\n")                              --LINE 5:   Engine lights
        save:write(C90DR_ovh_avion_pnl.."\n")                               --LINE 6:   Avionics panel lights
        save:write(C90DR_ovh_sub_pnl.."\n")                                 --LINE 7:   Subpanel lights
        save:write(C90DR_ovh_side_pnl.."\n")                                --LINE 8:   Sidepanel lights
        save:write(C90DR_ovh_copilot_gyro.."\n")                            --LINE 9:   Copilot's gyro lights
        save:write(C90DR_ovh_copilot_flt.."\n")                             --LINE 10:  Copilot's flight lights
        save:write(C90DR_ovh_master.."\n")                                  --LINE 11:  Overhead master lights
        save:write(C90DR_avionics_auto_comm_switch_pos_pilot.."\n")         --LINE 12:  Autocomm switch
        save:write(C90DR_avionics_master_vol_ctrl_dial_pilot.."\n")         --LINE 13:  Radio master volume control
        save:write(C90DR_avionics_com1_audio_switch_pos_pilot.."\n")        --LINE 14:  COM1 monitor
        save:write(C90DR_avionics_com2_audio_switch_pos_pilot.."\n")        --LINE 15:  COM2 monitor
        save:write(simDR_audio_selection_nav1.."\n")                        --LINE 16:  NAV1 monitor
        save:write(simDR_audio_selection_nav2.."\n")                        --LINE 17:  NAV2 monitor
        save:write(C90DR_avionics_mkr_audio_bkn1_switch_pos_pilot.."\n")    --LINE 18:  Marker beacon 1 monitor
        save:write(C90DR_avionics_mkr_audio_bkn2_switch_pos_pilot.."\n")    --LINE 19:  Marker beacon 2 monitor
        save:write(simDR_audio_dme_enabled.."\n")                           --LINE 20:  DME monitor
        save:write(simDR_audio_selection_adf1.."\n")                        --LINE 21:  ADF monitor
        save:write(C90DR_avionics_mic_sel_dial_pos_pilot.."\n")             --LINE 22:  Comm1 mic select dial
        save:write(C90DR_avionics_hot_intph_switch_pos.."\n")               --LINE 23:  Hot interphone
        save:write(C90DR_avionics_dme_channel_sel_switch_pos.."\n")         --LINE 24:  DME channel select
        save:write(C90DR_avionics_encd_atim_sel_switch_pos.."\n")           --LINE 25:  Encoder select
        save:write(C90DR_avionics_mkr_bkn_sense_switch_pos.."\n")           --LINE 26:  Marker beacon Hi-Lo select
		save:write(C90DR_avionics_gps_power_switch_pos.."\n")               --LINE 27:  GPS power
        save:write(C90DR_avionics_paging_vol_dial.."\n")                    --LINE 28:  Paging volume
        save:write(C90DR_avionics_interphone_vol_dial.."\n")                --LINE 29:  Interphone volume
        save:write(C90DR_avionics_dme_vol_dial.."\n")                       --LINE 30:  DME volume
        save:write(C90DR_avionics_mkr_bkn_vol_dial.."\n")                   --LINE 31:  Marker beacon volume
        save:write(simDR_generic_lights_switch[4].."\n")                    --LINE 32:  Bar light
        save:write(C90DR_lighting_cabin_brt_dim_switch_pos.."\n")           --LINE 33:  Cabin light switch
        save:write(simDR_generic_lights_switch[5].."\n")                    --LINE 34:  Cabin lights
        save:write(C90DR_volt_bus_sel_dial.."\n")                           --LINE 35:  Overhead voltage select dial
		save:write(C90DR_pilot_shade_flip.."\n")                            --LINE 36:  Pilot's shade
		save:write(C90DR_copilot_shade_flip.."\n")                          --LINE 37:  Copilot's shade
        save:write(simDR_engine_antiice_left.."\n")                         --LINE 38:  Left engine anti-ice
        save:write(simDR_engine_antiice_right.."\n")                        --LINE 39:  Right engine anti-ice
		save:write(C90DR_pneumatic_bleed_air_switch_pos_L.."\n")            --LINE 40:  Left bleed
		save:write(C90DR_pneumatic_bleed_air_switch_pos_R.."\n")            --LINE 41:  Right bleed
		save:write(simDR_pressure_cabin_alt_ft.."\n")                       --LINE 42:  Cabin pressure setting
        save:write(C90DR_airCon_cabin_temp_dial.."\n")                      --LINE 43:  Cabin temperature knob degree setting
        save:write(simDR_elevator_trim.."\n")                               --LINE 44:  Elevator trim
        save:write(C90DR_avionics_nav_data_sel_dial_pos.."\n")              --LINE 45:  Nav Data Select: GSP, Wind...
        save:write(C90DR_avionics_EFIS_map_mode_sel_dial_pos.."\n")         --LINE 46:  EFIS map mode
        save:write(C90DR_avionics_crs_sensor_sel_dial_pos.."\n")            --LINE 47:  PRE/ACT/XFR dial
        save:write(simDR_fuel_quantity_l_wing.."\n")                        --LINE 48:  Fuel L wing
        save:write(simDR_fuel_quantity_r_wing.."\n")                        --LINE 49:  Fuel R wing
        save:write(simDR_fuel_quantity_l_nacelle.."\n")                     --LINE 50:  Fuel L nacelle
        save:write(simDR_fuel_quantity_r_nacelle.."\n")                     --LINE 51:  Fuel R nacelle
        save:write(simDR_fuel_firewall_vlv_L.."\n")                         --LINE 52:  Left firewall valve
        save:write(simDR_fuel_firewall_vlv_R.."\n")                         --LINE 53:  Right firewall valve
        save:write(C90DR_fuel_firewall_switch_guard_L.."\n")                --LINE 54:  Left firewall guard
        save:write(C90DR_fuel_firewall_switch_guard_R.."\n")                --LINE 55:  Right firewall guard
        save:write(avitab_on.."\n")                                         --LINE 56:  Avitab power global variable
        save:write(C90DR_autopilot_altSel100_switch_pos.."\n")              --LINE 57:  Alt select 1k knob position
		save:write(C90DR_avionics_ind42_power_switch_pos.."\n")             --LINE 58:  IND-42 power
		save:write(C90DR_avionics_ind42_mode.."\n")                         --LINE 59:  IND-42 mode
		save:write(C90DR_avionics_ind42_channel.."\n")                      --LINE 60:  IND-42 channel
		save:write(simDR_transponder_power.."\n")                           --LINE 61:  XPNDR power
		save:write(C90DR_avionics_adf1_vol_control_dial.."\n")              --LINE 62:  ADF volume
		save:write(C90DR_avionics_EFIS_eadi_brightness.."\n")               --LINE 63:  EADI brightness dial
		save:write(C90DR_avionics_EFIS_ehsi_brightness.."\n")               --LINE 64:  EHSI brightness dial
		save:write(C90DR_avionics_EFIS_fd_switch_pos.."\n")                 --LINE 65:  flight director
		save:write(C90DR_avionics_EFIS_power_switch_pos.."\n")              --LINE 66:  EFIS power
		save:write(C90DR_fltctrl_rudder_boost_switch_pos.."\n")             --LINE 67:  rudder boost
		save:write(C90DR_fltctrl_elev_trim_control_switch_pos.."\n")        --LINE 68:  elevator trim
        --GNS and GTN diverge here
        save:write(C90DR_avionics_gtn_volume[0].."\n")                      --LINE 69:  GTN left volume
        save:write(C90DR_avionics_gtn_volume[1].."\n")                      --LINE 70:  GTN right volume
        save:write(C90DR_avionics_gtn_sd_card_pos[0].."\n")                 --LINE 71:  ADF2 left SD
        save:write(C90DR_avionics_gtn_sd_card_pos[1].."\n")                 --LINE 72:  ADF2 right SD
		save:write(simDR_cabindoor.."\n")                                   --LINE 73:  Cabin door
		save:write(simDR_avitab_enabled.."\n")                              --LINE 74:  Avitab yoke-mounted
		save:close()	--@pilotmarcog 4-01-2022 - fix log error io.close statement
    end
end

function save_g1000_settings()
    print("EVO: 22. Saving G1000 Switch and Dial Settings.")
	local save = io.open(C90.persistence, "w")
	if save then
		save:write(C90DR_ovh_flood.."\n")                                   --LINE 1:   Overhead flood
        save:write(C90DR_ovh_indirect.."\n")                                --LINE 2:   Panel indirect lights
        save:write(C90DR_ovh_pilot_flt.."\n")                               --LINE 3:   Pilot flight lights
        save:write(C90DR_ovh_pilot_gyro.."\n")                              --LINE 4:   Pilot gyro lights
        save:write(C90DR_ovh_eng_instru.."\n")                              --LINE 5:   Engine lights
        save:write(C90DR_ovh_avion_pnl.."\n")                               --LINE 6:   Avionics panel lights
        save:write(C90DR_ovh_sub_pnl.."\n")                                 --LINE 7:   Subpanel lights
        save:write(C90DR_ovh_side_pnl.."\n")                                --LINE 8:   Sidepanel lights
        save:write(C90DR_ovh_copilot_gyro.."\n")                            --LINE 9:   Copilot's gyro lights
        save:write(C90DR_ovh_copilot_flt.."\n")                             --LINE 10:  Copilot's flight lights
        save:write(C90DR_ovh_master.."\n")                                  --LINE 11:  Overhead master lights
        save:write(simDR_generic_lights_switch[4].."\n")                    --LINE 12:  Bar light
        save:write(C90DR_lighting_cabin_brt_dim_switch_pos.."\n")           --LINE 13:  Cabin light switch
        save:write(simDR_generic_lights_switch[5].."\n")                    --LINE 14:  Cabin lights
        save:write(C90DR_volt_bus_sel_dial.."\n")                           --LINE 15:  Overhead voltage select dial
		save:write(C90DR_pilot_shade_flip.."\n")                            --LINE 16:  Pilot's shade
		save:write(C90DR_copilot_shade_flip.."\n")                          --LINE 17:  Copilot's shade
        save:write(simDR_engine_antiice_left.."\n")                         --LINE 18:  Left engine anti-ice
        save:write(simDR_engine_antiice_right.."\n")                        --LINE 19:  Right engine anti-ice
		save:write(C90DR_pneumatic_bleed_air_switch_pos_L.."\n")            --LINE 20:  Left bleed
		save:write(C90DR_pneumatic_bleed_air_switch_pos_R.."\n")            --LINE 21:  Right bleed
		save:write(simDR_pressure_cabin_alt_ft.."\n")                       --LINE 22:  Cabin pressure setting
        save:write(C90DR_airCon_cabin_temp_dial.."\n")                      --LINE 23:  Cabin temperature knob degree setting
        save:write(simDR_elevator_trim.."\n")                               --LINE 24:  Elevator trim
        save:write(simDR_fuel_quantity_l_wing.."\n")                        --LINE 25:  Fuel L wing
        save:write(simDR_fuel_quantity_r_wing.."\n")                        --LINE 26:  Fuel R wing
        save:write(simDR_fuel_quantity_l_nacelle.."\n")                     --LINE 27:  Fuel L nacelle
        save:write(simDR_fuel_quantity_r_nacelle.."\n")                     --LINE 28:  Fuel R nacelle
        save:write(simDR_fuel_firewall_vlv_L.."\n")                         --LINE 29:  Left firewall valve
        save:write(simDR_fuel_firewall_vlv_R.."\n")                         --LINE 30:  Right firewall valve
        save:write(C90DR_fuel_firewall_switch_guard_L.."\n")                --LINE 31:  Left firewall guard
        save:write(C90DR_fuel_firewall_switch_guard_R.."\n")                --LINE 32:  Right firewall guard
        save:write(simDR_artificial_horizon_adjust_stby.."\n")              --LINE 33:  Standby horizon adjust
        save:write(simDR_barometer_setting_in_hg_stby.."\n")                --LINE 34:  Standby altimeter
        save:write(avitab_on.."\n")                                         --LINE 35:  Avitab power
		save:write(simDR_cabindoor.."\n")                                   --LINE 36:  Cabin door
		save:write(C90DR_pilot_shade_slide.."\n")                           --LINE 37:  Horizontal sunshade position pilot
		save:write(C90DR_copilot_shade_slide.."\n")                         --LINE 38:  Horizontal sunshade position copilot
		save:write(simDR_avitab_enabled.."\n")                              --LINE 39:  Avitab yoke-mounted
		save:write(C90DR_fltctrl_rudder_boost_switch_pos.."\n")             --LINE 40:  rudder boost
		save:write(C90DR_fltctrl_elev_trim_control_switch_pos.."\n")        --LINE 41:  elevator trim
		save:close()	--@pilotmarcog 4-01-2022 - fix log error io.close statement
    end
end


