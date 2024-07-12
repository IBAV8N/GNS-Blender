fd_active               = {}
fd_saved                = {}
fd_test_timer	        = {}
fd_ref	                = {}

local fd_test_affirm    = 0
local fd_blink          = 0
local dh_flashing       = 0
local dh_timer          = 0
local dh_blink          = 0
local C90_ap_disco_on 	= 0
local C90_yd_on 		= 0
local C90_yd_disco_on 	= 0
local lastPreMode = C90.pre80.mode
local C90_descent_mode_change_flag = 0

----- FD ANNUNCIATORS ---------------------------------------------------------------
function C90_autopilot_FD_annun()                                           --IBAV8N, Apr20-22, 5s annun flashing upon selection, activation, per POH
    nav_status = 0
	if simDR_hsi_source_sel_pilot == 0 then                                 --RADIO
		if C90.avionics.vor_avail == 1 then                                 --VOR
			if simDR_autopilot_nav_status == 1 then                         --ARMED
				nav_status = 1
			elseif simDR_autopilot_nav_status == 2 then                     --ACTIVE
				nav_status = 2
			end
		elseif C90.avionics.loc_avail == 1 then                             --LOC
			if simDR_autopilot_nav_status == 1 then                         --ARMED
				nav_status = 3
			elseif simDR_autopilot_nav_status == 2 then                     --ACTIVE
				nav_status = 4
			end
		end
	elseif simDR_hsi_source_sel_pilot == 2 then                             --GPS
		if simDR_autopilot_nav_status == 1 then                             --ARMED
			nav_status = 9
		elseif simDR_autopilot_nav_status == 2 then                         --ACTIVE
			nav_status = 10
		end
	end
    fd_active[0] = nav_status
    fd_active[1] = simDR_autopilot_heading_status
    fd_active[2] = simDR_autopilot_speed_status
    fd_active[3] = simDR_autopilot_vvi_status
    fd_active[4] = simDR_autopilot_glideslope_status
    fd_active[5] = simDR_autopilot_alt_hold_status

    for i = 0, 5 do
        if fd_active[i] ~= fd_saved[i] then
            if fd_active[i] > 0 then
                fd_test_timer[i] = 9
                fd_test_affirm = 1
            end
            fd_ref[i] = 0
        end
        fd_saved[i] = fd_active[i]
    end

    if fd_test_affirm == 1 then
        if is_timer_scheduled(fd_annun_flash) == false then
            fd_blink = 0
            run_at_interval(fd_annun_flash, 0.5)
        end
    end

    if simDR_dh_lit_pilot > 0 then                                  --IBAV8N, Apr20-27, 5s DH annun flashing upon reaching DH, per POH
        if dh_flashing == 0 then
            dh_flashing = 1
            dh_timer = 29
            run_at_interval(dh_annun_flash, 0.166666)
        end
    else
        stop_timer(dh_annun_flash)
        dh_timer = 0
        dh_flashing = 0
        dh_blink = 0
    end

    C90DR_autopilot_nav_status          = fd_ref[0]
    C90DR_autopilot_heading_status      = fd_ref[1]
    C90DR_autopilot_speed_status        = fd_ref[2]
    C90DR_autopilot_vvi_status          = fd_ref[3]
    C90DR_autopilot_glideslope_status   = fd_ref[4]
    C90DR_autopilot_alt_hold_status     = fd_ref[5]
    C90DR_dh_lit_pilot                  = simDR_dh_lit_pilot * dh_blink
end

function fd_annun_flash()
    local flash_on = 0
    fd_blink = 1 - fd_blink
    for i = 0, 5 do
        if fd_test_timer[i] > 0 then
            flash_on = 1
            fd_ref[i] = fd_saved[i] * fd_blink
            fd_test_timer[i] = fd_test_timer[i] - 1
        elseif fd_test_timer[i] == 0 then
            fd_ref[i] = fd_saved[i]
        end
    end
    fd_test_affirm = 0

    if flash_on == 0 then
        stop_timer(fd_annun_flash)
    end
end

function dh_annun_flash()
    dh_blink = 1 - dh_blink
    dh_timer = dh_timer - 1
    if dh_timer == 0 then
        stop_timer(dh_annun_flash)
    end
end

----- DESCENT MODE CHANGE ---------------------------------------------------------------
function C90_decent_mode_monitor()
	C90_descent_mode_change_flag = 1
end

function C90_climb_mode()
	if C90_descent_mode_change_flag == 1 then
		if C90DR_autopilot_DSC_status == 1 then
			if (math.abs(simDR_gauges_ind_vvi_fpm) > math.abs(simDR_autopilot_vvi_dial_fpm) - 10)
				and (simDR_gauges_ind_vvi_fpm < simDR_autopilot_vvi_dial_fpm + 10)
			then
				C90DR_autopilot_DSC_status = 0
				C90_descent_mode_change_flag = 0
			end
		end
	end
end

----- AUTOPILOT DISCO ------------------------------------------------------------------
function C90_ap_disco_flash()
	C90_ap_disco_on = 1 - C90_ap_disco_on
end

function C90_ap_disco()
	if simDR_annun_ap_disco == 1 then
		if is_timer_scheduled(C90_ap_disco_flash) == false then
			run_timer(C90_ap_disco_flash, 0, 0.5)
		end
	else
		stop_timer(C90_ap_disco_flash)
		C90_ap_disco_on = 0
	end
end

----- YAW DAMPER DISCO -----------------------------------------------------------------
function C90_yd_timer()
	C90_yd_on = 0
end

function C90_yd_disco_flash()
	C90_yd_disco_on = 1 - C90_yd_disco_on
end

function C90_yd_disco()
	if simDR_autopilot_yaw_damper_on == 1 then
		C90_yd_on = 1
	end
	if simDR_autopilot_yaw_damper_on == 0 and C90_yd_on == 1 then
		if is_timer_scheduled(C90_yd_timer) == false then
			run_after_time(C90_yd_timer, 5)
		end
		if is_timer_scheduled(C90_yd_disco_flash) == false then
			run_timer(C90_yd_disco_flash, 0, 0.5)
		end
	else
		stop_timer(C90_yd_disco_flash)
		stop_timer(C90_yd_timer)
		C90_yd_disco_on = 0
	end
end

----- ALTITUDE SELECTOR ----------------------------------------------------------------
function C90_ap_altitude_alert()
	local wow 		= C90_ternary((simDR_gear_on_ground[0] > 0 and simDR_gear_on_ground[1] > 0 and simDR_gear_on_ground[2] > 0), 1, 0)
	local altDelta 	= math.abs(simDR_altitude - simDR_autopilot_alt_dial_ft)
	local voltage = math.max(simDR_bus_volts[0], simDR_bus_volts[1], simDR_bus_volts[2])
	if wow == 0 then
		----- ACTIVATE THE ALTITUDE PRESELECTOR LOGIC
		if simDR_radio_altitude_ft > 1000
			and C90.pre80.mode == 0
			and voltage > 5
		then
			C90.pre80.mode = 1
		end
		----- ALTITUDE PRESELECTOR MODE & ALERT LOGIC
		--[ OFF MODE]--
		if C90.pre80.mode == 0 then
			C90.pre80.alert = 0				-- LIGHT OFF
		--[ ACQUISTION ARMED MODE ]--
		elseif C90.pre80.mode == 1 then
			if altDelta <= 1000 and altDelta > 300 then
				C90.pre80.alert = 1			-- LIGHT ON
				C90.pre80.mode 	= 2
			end
		--[ ACQUISTION ARMED MODE ]--
		elseif C90.pre80.mode == 2 then
			if altDelta > 1000 then		-- OUTSIDE ACQUISTION MODE RANGE
				C90.pre80.alert = 2			-- LIGHT FLASHING
				C90.pre80.mode 	= 1
			elseif altDelta < 5 then		-- ACQUISTION
				C90.pre80.alert = 0			-- LIGHT OFF
				C90.pre80.mode 	= 3
			elseif altDelta <= 300 then	-- 300 FEET TO ACQUISTION ALTITIUDE
				C90.pre80.alert = 2			-- LIGHT FLASHING
			end
		--[ DEVIATION ARMED MODE ]--
		elseif C90.pre80.mode == 3 then
			if altDelta > 300 then		-- DEVIATION FROM ACQUISTION
				C90.pre80.alert = 2
				C90.pre80.mode 	= 2
			end
		end
	else
		C90.pre80.alert = 0
		C90.pre80.mode 	= 0
	end
	if C90.pre80.mode ~= lastPreMode then
		lastPreMode = C90.pre80.mode
	end
end

function C90_autopilot_fd_monitor()                 --IBAV8N, Apr2-22, works properly now
	if C90DR_avionics_EFIS_fd_switch_pos == 0 and simDR_autopilot_on == 1 then
        simCMD_autopilot_fdir_off:once()
	end
end

----- ANNUNCIATORS ---------------------------------------------------------------------
function C90_autopilot_annunciators()

	--[ AUTOPILOT CONTROL PANEL ]--
	C90.autopilot.acp.yaw_engaged		= C90_ternary(simDR_autopilot_yaw_damper_on > 0
														or C90_yd_on > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.yaw_disco			= C90_ternary(C90_yd_disco_on > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.ap_engaged		= C90_ternary(simDR_autopilot_on_or_cws > 0
														or simDR_annun_ap_disco > 0
														or C90.autopilot.lamp_test > 0
														or simDR_autopilot_test_ap_lit == 1									-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.ap_disco			= C90_ternary(C90_ap_disco_on > 0
														or C90.autopilot.lamp_test > 0
														or simDR_autopilot_test_ap_lit == 1									-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.trim_servo		= 0

	C90.autopilot.acp.ap_fail			= C90_ternary(simDR_op_autopilot_fail == 6
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.aileron_servo		= C90_ternary(simDR_ail_servo_fail == 6
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.rudder_servo		= C90_ternary(simDR_rud_servo_fail == 6
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.elevator_servo	= C90_ternary(simDR_elv_servo_fail == 6
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.half_bank			= C90_ternary(simDR_autopilot_half_bank > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.soft_ride			= C90_ternary(simDR_autopilot_soft_ride > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.trim_fail			= C90_ternary(simDR_autopilot_trim_fail > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.acp.trim_operating	= C90_ternary(simDR_autopilot_trim_up > 0
														or simDR_autopilot_trim_down > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)

	--[ FLIGHT CONTROL PANEL ]--
	C90.autopilot.fcp.trim_fail			= C90_ternary(simDR_autopilot_trim_fail > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														or simDR_autopilot_test_ap_lit == 1
														, 1, 0)
	C90.autopilot.fcp.trim_operating	= C90_ternary(simDR_autopilot_trim_up > 0
														or simDR_autopilot_trim_down > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.hdg				= C90_ternary(simDR_autopilot_heading_status > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.nav				= C90_ternary((simDR_autopilot_nav_status > 0
														and simDR_autopilot_approach_status == 0)
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.nav_armed			= C90_ternary(simDR_autopilot_nav_status == 1
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.dr				= C90_ternary(simDR_autopilot_DR_status == 1
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.appr				= C90_ternary(simDR_autopilot_approach_status > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.appr_armed		= C90_ternary(simDR_autopilot_approach_status == 1
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.bc				= C90_ternary(simDR_autopilot_backcrs_status > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.clm				= C90_ternary(simDR_autopilot_climb_adjust > -20000
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.half_bank			= C90_ternary(simDR_autopilot_half_bank > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.soft_ride			= C90_ternary(simDR_autopilot_soft_ride > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.ap_fail			= C90_ternary(simDR_op_autopilot_fail == 6
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														or simDR_autopilot_test_ap_lit == 1
														, 1, 0)
	C90.autopilot.fcp.yaw_engaged		= C90_ternary(simDR_autopilot_yaw_damper_on > 0
														or C90_yd_on > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														or (simDR_autopilot_ready == 0
															and C90.autopilot.sys_diag_test == 1)
														, 1, 0)
	C90.autopilot.fcp.yaw_disco			= C90_ternary(C90_yd_disco_on > 0
														or C90.autopilot.lamp_test > 0
														or simDR_autopilot_test_ap_lit == 1									-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.alt				= C90_ternary(simDR_autopilot_alt_hold_status > 1
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.alt_sel			= C90_ternary(simDR_autopilot_alt_hold_status == 1
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.vs				= C90_ternary((simDR_autopilot_vvi_status > 0
														and simDR_autopilot_des_adjust < -20000)
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.gs				= C90_ternary(simDR_autopilot_glideslope_status > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.gs_armed			= C90_ternary(simDR_autopilot_glideslope_status == 1
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.ias				= C90_ternary((simDR_autopilot_speed_status > 0
														and simDR_autopilot_climb_adjust < -20000)
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.ga				= C90_ternary((simDR_autopilot_TOGA_lat_status > 0
														and simDR_autopilot_TOGA_vert_status > 0)
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														or C90.autopilot.ground_test > 0
														, 1, 0)
	C90.autopilot.fcp.dsc				= C90_ternary(simDR_autopilot_des_adjust > -20000
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														, 1, 0)
	C90.autopilot.fcp.ap_engaged		= C90_ternary(simDR_autopilot_on_or_cws > 0
														or simDR_annun_ap_disco > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														or (simDR_autopilot_ready == 0
															and C90.autopilot.sys_diag_test == 1)
														or simDR_autopilot_test_ap_lit == 1
														, 1, 0)
	C90.autopilot.fcp.ap_disco			= C90_ternary(C90_ap_disco_on > 0
														or C90.autopilot.lamp_test > 0										-- LAMP TEST
														or (simDR_autopilot_ready == 0
															and C90.autopilot.sys_diag_test == 1)
														or simDR_autopilot_test_ap_lit == 1
														, 1, 0)
end
