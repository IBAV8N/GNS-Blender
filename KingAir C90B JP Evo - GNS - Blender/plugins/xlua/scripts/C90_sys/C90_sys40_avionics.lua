
----- DME AUDIO SELECTOR ----------------------------------------------------------------
function C90_avionics_dme_audio_selector()
	if C90DR_avionics_dme_channel_sel_switch_pos == 0 then
		simDR_audio_selection_dme1 = 1 * simDR_audio_dme_enabled
		simDR_audio_selection_dme2 = 0 * simDR_audio_dme_enabled
	elseif C90DR_avionics_dme_channel_sel_switch_pos == 1 then
		simDR_audio_selection_dme1 = 0 * simDR_audio_dme_enabled
		simDR_audio_selection_dme2 = 1 * simDR_audio_dme_enabled
	end
end

----- AUDIO VOLUME ----------------------------------------------------------------------
function C90_avionics_audio_vol()
	if simDR_acf_descrip == "C90B EVO GNS" then
	    simDR_com1_audio_vol = C90DR_avionics_com1_vol_control_dial * C90DR_avionics_master_vol_ctrl_dial_pilot
	    simDR_com2_audio_vol = C90DR_avionics_com2_vol_control_dial * C90DR_avionics_master_vol_ctrl_dial_pilot
	    simDR_nav1_audio_vol = C90DR_avionics_nav1_vol_control_dial * C90DR_avionics_master_vol_ctrl_dial_pilot
	    simDR_nav2_audio_vol = C90DR_avionics_nav2_vol_control_dial * C90DR_avionics_master_vol_ctrl_dial_pilot
	end
    if simDR_acf_descrip == "C90B - G1000, Blackhawk" then  --IBAV8N, Sept30-23 - G1ks control Nav/Com volumes, master controls MKR, DME volumes, Avonics_on cycle resets master to 1.
        --local radio_panels_on = C90_ternary(C90DR_avionics_on_sw_pos == 1, C90DR_avionics_master_vol_ctrl_dial_pilot, 0)
	    simDR_mkr_audio_vol = C90DR_avionics_on_sw_pos
	    simDR_audio_volume_dme1 = C90DR_avionics_on_sw_pos
	    --simDR_adf1_audio_vol = radio_panels_on --this plane has no ADF
        --if C90DR_avionics_on_sw_pos == 0 then C90DR_avionics_master_vol_ctrl_dial_pilot = 1 end
    end
    if simDR_acf_descrip ~= "C90B - G1000, Blackhawk" then
	    simDR_adf1_audio_vol = C90DR_avionics_adf1_vol_control_dial * C90DR_avionics_master_vol_ctrl_dial_pilot
	    simDR_audio_volume_dme1 = C90DR_avionics_dme_vol_dial * C90DR_avionics_master_vol_ctrl_dial_pilot
	    simDR_audio_volume_dme2 = C90DR_avionics_dme_vol_dial * C90DR_avionics_master_vol_ctrl_dial_pilot
	    simDR_mkr_audio_vol = C90DR_avionics_mkr_bkn_vol_dial * C90DR_avionics_master_vol_ctrl_dial_pilot
    end
end

----- PILOT'S AUTOCOMM FUNCTION --------------------------------------------------------
function autocomm()
    if C90DR_avionics_auto_comm_switch_pos_pilot == 0 then
        simDR_com1_monitor = C90DR_avionics_com1_audio_switch_pos_pilot
        simDR_com2_monitor = C90DR_avionics_com2_audio_switch_pos_pilot
        if C90DR_avionics_mic_sel_dial_pos_pilot == 0 then
            simCMD_xmit_audio_com1_man:once()
        elseif C90DR_avionics_mic_sel_dial_pos_pilot == 1 then
            simCMD_xmit_audio_com2_man:once()
        end
    elseif C90DR_avionics_auto_comm_switch_pos_pilot == 1 then
        if C90DR_avionics_mic_sel_dial_pos_pilot == 0 then
            simCMD_xmit_audio_com1_man:once()
            simDR_com1_monitor = 1
            simDR_com2_monitor = C90DR_avionics_com2_audio_switch_pos_pilot
        elseif C90DR_avionics_mic_sel_dial_pos_pilot == 1 then
            simCMD_xmit_audio_com2_man:once()
            simDR_com2_monitor = 1
            simDR_com1_monitor = C90DR_avionics_com1_audio_switch_pos_pilot
        else
            simDR_com1_monitor = 0
            simDR_com2_monitor = 0
        end
    end
    stop_timer(autocomm)
end

----- LATERAL DEVIATION DISPLAY STATUS FOR EADI GENERIC INSTRUMENT ----------------------
function C90_radio_lat_dev_type()                               -- IBAV8N, May16-22, added GPS capability for lateral deviation bug on EADI.
	C90DR_avionics_lat_dev_dispay_status = 0
	if simDR_hsi_display_horizontal == 1 then                   -- HORIZONTAL SIGNAL IS BEING RECEIVED
		if simDR_hsi_source_sel_pilot == 0 then                 -- NAV 1
			if C90.avionics.vor_avail == 1 then                 -- VOR
				C90DR_avionics_lat_dev_dispay_status = 1
			elseif C90.avionics.loc_avail == 1 then             -- LOC
				C90DR_avionics_lat_dev_dispay_status = 2
			end
		elseif simDR_hsi_source_sel_pilot == 2 then             -- GPS
		    C90DR_avionics_lat_dev_dispay_status = 3
		end
	end
end

----- DECISION HEIGHT -------------------------------------------------------------------
function C90_decision_ht()
	simDR_radio_alt_bug_ft_pilot = C90DR_avionics_decision_height_dial_pos
	C90DR_avionics_EFIS_dh = C90DR_avionics_decision_height_dial_pos --IBAV8N
end

----- RADIO ALTITUDE --------------------------------------------------------------------
function C90_radio_altitude()
	if simDR_radio_altitude_ft <= 1000 then
		C90DR_avionics_radio_altitude = C90_rndToIncr(simDR_radio_altitude_ft, 10)
	elseif simDR_radio_altitude_ft > 1000 then
		C90DR_avionics_radio_altitude = C90_rndToIncr(simDR_radio_altitude_ft, 50)
	end

end

----- EHSI COURSE SELECT ----------------------------------------------------------------       IBAV8N, May2-22, Continuously updates avail nav, radio CDI Sept5-23 polishing
function C90_EHSI_course_select()
    C90.avionics.vor_avail  = C90_ternary(simDR_radio_nav1_type == 4, 1, 0)
    C90.avionics.loc_avail = C90_ternary(simDR_radio_nav1_type == 8 or simDR_radio_nav1_type == 16 or simDR_radio_nav1_type == 40, 1, 0)
	if C90DR_avionics_crs_sel_cycle_active == 0 then                                                            -- DO NOT ALLOW IF A SOURCE SELECTION IS IN PROCESS
        if simDR_hsi_source_sel_pilot == 0 then                                                                 -- HSI SOURCE IS RADIO
            if C90DR_avionics_cur_crs_sel_index < 3 then                                                        -- RADIO SOURCE IS ACTIVELY RADIO AND NOT GPS
				if C90.avionics.vor_avail == 1 then                                                             -- IF AVAILABLE NAV TYPE IS VOR
					C90DR_avionics_cur_crs_sel_index = 1                                                        -- SET COURSE TO VOR
				elseif C90.avionics.loc_avail == 1 then                                                         -- IF AVAILABLE NAV TYPE IS LOC
					C90DR_avionics_cur_crs_sel_index = 2                                                        -- SET COURSE TO LOC
                    if C90DR_avionics_crs_sensor_sel_dial_pos == 1 then                                         -- IF NOT IN PRE MODE
                        if C90DR_avionics_EFIS_pre_loc_active == 1 then                                         -- BUT PRE LOC IS ACTIVE      
				            simDR_radio_nav1_OBS_deg = C90DR_avionics_EFIS_pre_loc_crs                          -- ACTIVE PILOTS OBS TAKES ON PRE LOC COURSE
				            simDR_hsi_source_sel_pilot = 0                                                      -- NAV SOURCE SET TO RADIO LOC
                            C90DR_avionics_EFIS_pre_loc_active = 0                                              -- PRE LOC NO LONGER ACTIVE
				            C90DR_avionics_EFIS_pre_loc_dsply = 0                                               -- PRE LOC NO LONGER VISIBLE
                        end
                    end
				elseif C90DR_avionics_cur_crs_sel_index > 0 then                                                -- IF TUNED RADIO FREQ HAS NO SIGNAL
                    C90DR_avionics_cur_crs_sel_index = 0                                                        -- REVERT TO NO RADIO SOURCE
				end
            end
        elseif simDR_hsi_source_sel_pilot == 2 then                                                             -- HSI SOURCE IS GPS
            if simDR_gps530_power ~= 1 then                                                                     -- IF GPS LOSES/HAS NO POWER
                simDR_hsi_source_sel_pilot = 0                                                                  -- RESET SOURCE TO RADIOS
                C90DR_avionics_cur_crs_sel_index = 0                                                            -- RESET THE SELECT AVAIL PROCESS
            end
		end
	end
    if simDR_hsi_source_sel_pilot == 2 then                                                                     -- IF IN GPS MODE AND PRE ARROW IS DISPLAYED, SIMULATE CDI FOR RADIO
        local compass
        if gps_crs_sel == 0 then                                                                                -- IBAV8N, Sept3-23, SUSPEND IF THE CRS-SEL BUTTON IS BEING PRESSED, FOR CDI CENTERING
            if (C90DR_avionics_EFIS_pre_crs_cycle_index == 0 and C90DR_avionics_EFIS_pre_loc_dsply == 1) or     -- IF IN RADIO LOC AND PRE LOC DISPLAYED
                (C90DR_avionics_EFIS_pre_crs_cycle_index == 1 and C90DR_avionics_EFIS_pre_vor_dsply == 1) then  -- OR IN RADIO VOR AND PRE VOR DISPLAYED
                if C90.avionics.vor_avail == 1 then                                                             -- VOR FREQ IS TUNED
                    compass = C90_compass(simDR_radio_nav1_bearing_deg, simDR_radio_nav1_OBS_deg_co, 0)         -- DETERMINE DELTA OF NAV1 BRG AND OBS TO
                    if compass < 90 and compass > -90 then                                                      -- IF WITHIN 180 DEG OF TO
                        simDR_nav1_hdef_dot2 = C90_set_animation_position(simDR_nav1_hdef_dot2, 0.25 * compass, -2.5, 2.5, 1.5)
                    else                                                                                        -- IF FROM
                        compass = C90_compass(simDR_radio_nav1_bearing_deg, simDR_radio_nav1_OBS_deg_co, 180)   -- DETERMINE DELTA OF NAV1 BRG AND OBS FROM
                        simDR_nav1_hdef_dot2 = C90_set_animation_position(simDR_nav1_hdef_dot2, 0.25 * compass, -2.5, 2.5, 1.5)
                    end
                elseif C90.avionics.loc_avail == 1 then                                                         -- LOC FREQ IS TUNED
                    compass = C90_compass(simDR_radio_nav1_bearing_deg, simDR_nav1_course_deg_mag_pilot, 0)     -- ILS ONLY ALIGNS IF 'TO'
                    simDR_nav1_hdef_dot2 = C90_set_animation_position(simDR_nav1_hdef_dot2, compass, -2.5, 2.5, 1.5)
                end
            end
        end
    end
end

function C90_ttg_time()                     --IBAV8N, Feb26-21
    if C90DR_avionics_nav_data_sel_dial_pos == 2 then
        if is_ttg_running == 1 then
            if is_timer_scheduled(ttg_time_calc) == false then
                run_at_interval(ttg_time_calc, 0.25)
            end
        elseif is_ttg_running == 0 then
            if is_timer_scheduled(ttg_time_calc) == false then
                run_at_interval(ttg_time_calc, 0.05)
            end
        end
    else
        C90DR_avionics_EFIS_ttg_minutes = 0
        C90DR_avionics_EFIS_ttg_seconds = 0
        stop_timer(ttg_time_calc)
        is_ttg_running = 0
    end
end

function ttg_time_calc()
    if C90DR_avionics_cur_crs_sel_index < 3 then
        C90DR_avionics_EFIS_ttg_minutes = math.floor(simDR_nav1_dme_time_min)
        C90DR_avionics_EFIS_ttg_seconds = math.floor(math.fmod(simDR_nav1_dme_time_min, 1) * 60)
    else
        C90DR_avionics_EFIS_ttg_minutes = math.floor(simDR_gps_dme_time_min)
        C90DR_avionics_EFIS_ttg_seconds = math.floor(math.fmod(simDR_gps_dme_time_min, 1) * 60)
    end
    is_ttg_running = 1
    stop_timer(ttg_time_calc)
end

