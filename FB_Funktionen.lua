local addonName, FBH = ...

local fbh_timer = C_Timer.NewTicker(fbh_UpdateInterval, function() FBH_OnUpdate() end)

function FBH_OnUpdate()
    fbh_roster_update()
    check_new_list()
end

function fbh_targetName()
    if(UnitExists("target")) then
        local fbh_tan = GetUnitName("target")
        local fbh_tir_check = fbh_targetInRaid(fbh_tan)
        if fbh_tir_check then
            return fbh_tan
        end
    else
        return false
    end
end

function fbh_targetInRaid(fbh_tir_name)
    local tir_gm = GetNumGroupMembers()
    local tir_tir = false
    for i = 1, tir_gm do
        local name = GetRaidRosterInfo(i)
        if name == fbh_tir_name then
            tir_tir = true
        end
    end
    return tir_tir
end

function fbh_getZone(check_name)
    local fbh_unit = nil
    if check_name ~= nil then 
        fbh_unit = check_name
    else
        fbh_unit = "target"
    end
    if (UnitExists(fbh_unit)) then
        local fbh_taz = fbh_unit
        if fbh_unit ~= "target" then
            fbh_taz = fbh_unit
        else
            fbh_taz = fbh_targetName()
        end
        local fbh_num = GetNumGroupMembers()
        for nuz = 1, fbh_num do
            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(nuz);
            if name == fbh_taz then
                fbh_target_zone = zone
                return fbh_target_zone
            end
        end
    else
        return false
    end
end

function fbh_roster_update()
    reloadRaidList()
    fbh_player_hasRights()
    fbh_get_tankassist()
    fbh_player_zone = GetZoneText()
end

function newMembers(new_name)
    local newMembers_size = getn(FBHnewMemberList)
    if newMembers_size == 0 then
        FBHnewMemberList[1] = new_name
    elseif newMembers_size > 0 then
        for arr = 1, newMembers_size do
            if FBHnewMemberList[arr] == new_name then
                return false
            else
                FBHnewMemberList[newMembers_size + 1] = new_name
            end
        end
    end
end

function check_new_list()
    local cnl = getn(FBHnewMemberList)
    local temp_name = nil
    if cnl > 0 then
        for arr = 1, cnl do
            temp_name = FBHnewMemberList[arr]
            if FBHRaidList[temp_name].zone ~= "Offline" then
                fbh_check_portal(temp_name)
                FBHnewMemberList[arr] = nil
            end
        end
    end
end

function check_ini(drin_oder_draussen)
    local isNichtDrin
    local isIni, iniTyp = IsInInstance()
    if drin_oder_draussen == nil or drin_oder_draussen == "drin" then
        isNichtDrin = isIni
    end
    if drin_oder_draussen == "draussen" then
        isNichtDrin = true and not isIni
    end
    return isNichtDrin
end

function fbh_check_portal(check_name)
    local isRaus = check_ini("draussen")
    if FBHleader and isRaus then
        local new_name = check_name
        local new_zone = FBHRaidList[new_name].zone
        local new_has_dm = check_dm_buffs(new_name)
        if new_has_dm > 0 and new_zone == FBHdmz then
            SetRaidSubgroup(UnitInRaid(new_name), 7)
        elseif new_has_dm == 0 then
            if new_zone == FBHdmz or new_zone == FBHdmf then
                SetRaidSubgroup(UnitInRaid(new_name), 5)
            end
        end
    end
end

function reloadRaidList()
    wipe{FBHRaidList}
    FBHRaidList = FBH.getRaidMembers()
end

local fbh_raidMemberList = {}
function FBH.getRaidMembers()
    wipe(fbh_raidMemberList)
    for ci = 1, MAX_RAID_MEMBERS do
        local name, rank, subgroup, level, class, classFileName, zone, online, isDead, role, isML = GetRaidRosterInfo(ci)
        -- Set online to boolean variable
        if (online == 1) or (online == true) then
            online = true
        else
            online = false
        end
        if name ~= nil then
            fbh_raidMemberList[name] = {
            name = name,
            -- rank=rank,
            -- level=level,
            -- class=class,
            zone = zone,
            online = online,
            -- classFileName=classFileName,
            subgroup = subgroup,
            index = ci,
            }
        end
    end
    return fbh_raidMemberList
end

function fbh_kickto(fbh_id_gruppenfuehrer, hide_msg)
    fbh_add_dnd_author(fbh_id_gruppenfuehrer)
    if hide_msg ~= nil and hide_msg == 0 then
        hide_kick = true
    else
        hide_kick = false
    end
    if UnitInRaid("player") then
        FBHKicker = true
        local fbh_kunde = fbh_targetName()
        if fbh_kunde then
            SendChatMessage(FBHKickMessageW .. fbh_id_gruppenfuehrer, "WHISPER", nil, fbh_kunde)
            UninviteUnit(fbh_kunde)
            SendChatMessage(FBHCode .. fbh_kunde, "WHISPER", nil, fbh_id_gruppenfuehrer)
        end
    end
end

function fbh_player_inRaid()
    FBHRAID = false
    local fbh_raidCheck = UnitInRaid("player")
    if fbh_raidCheck then
        FBHRAID = true
    else
        fbh_guiFrame:Hide()
    end
    return FBHRAID
end

function fbh_player_hasRights()
    FBHLeadOrAssi = false
    FBHleader = UnitIsGroupLeader("player")
    local fbh_assistCheck = UnitIsGroupAssistant("player")
    if FBHleader or fbh_assistCheck then
        FBHLeadOrAssi = true
    end
    return FBHLeadOrAssi
end

function fbh_count_wait()
    local cwait_gm = GetNumGroupMembers()
    local cwait_count = 0
    for i = 1, cwait_gm do
        local cwait_name, cwait_rank, cwait_subgroup = GetRaidRosterInfo(i)
        if cwait_subgroup >= 1 and cwait_subgroup <= 5 then
            cwait_count = cwait_count + 1
        end
    end
    return cwait_count 
end

function fbh_count_ini()
    local cini_gm = GetNumGroupMembers()
    local cini_count = 0
    for i = 1, cini_gm do
        local cini_name, cini_rank, cini_subgroup = GetRaidRosterInfo(i)
        if cini_subgroup == 6 then
            cini_count = cini_count + 1
        end
    end
    return cini_count
end

function fbh_get_tankassist()
    FBHtank = nil
    FBHassist = nil
    local gngm = GetNumGroupMembers()
    for raidIndex = 1, gngm do
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(raidIndex);
        if role == "MAINTANK" then
            FBHtank = name
        end
        if role == "MAINASSIST" then
            FBHassist = name
        end
    end
end

function fbh_statusempfang(to_hook)
    fbh_player_inRaid()
    if to_hook ~= nil and FBHRAID then
        C_ChatInfo.SendAddonMessage(FBHHookSender, 1, "WHISPER", to_hook)
    end
end

function fbh_hook_sender(fbh_sender_hook)
    local sender_to_hook = gsub(fbh_sender_hook, FBHREALM, "")
    local sender_hook_size = getn(fbh_hooked_sender)
    if sender_hook_size == 0 then
        fbh_hooked_sender[1] = sender_to_hook
    elseif sender_hook_size > 0 then
        for arr = 1, sender_hook_size do
            if fbh_hooked_sender[arr] == sender_to_hook then
                return false
            else
                fbh_hooked_sender[sender_hook_size + 1] = sender_to_hook
            end
        end
    end
end

function fbh_unhook_offline_sender(to_unhook)
    local fbh_unhook_array = {strsplit("'", to_unhook)}
    local fbh_unhook_name = fbh_unhook_array[2]
    local sender_hook_size = getn(fbh_hooked_sender)
    if sender_hook_size > 0 then
        for arr = 1, sender_hook_size do
            if fbh_hooked_sender[arr] == fbh_unhook_name then
                print(fbh_unhook_name .. " ist aus der Statusliste entfernt worden.")
                fbh_hooked_sender[arr] = nil
            end
        end
    end
end

function fbh_hook_status(fbh_status_hook)
    if strfind(fbh_status_hook, FBHStatusCode, 1) == 1 then
        fbh_named_status = gsub(fbh_status_hook, FBHStatusCode, "")
        fbh_status_name, fbh_status_msg = strsplit(fbh_name_separator, fbh_named_status)
    end
    fbh_hooked_status[fbh_status_name] = fbh_status_msg
    fbh_update_status()
end

function fbh_update_status()
    local win_height = 25
    if not next(fbh_hooked_status) then
        fbh_guiFrame:Hide()
        return false
    else
        local height_count = 0
        fbh_status_window = true
        local new_names = ""
        local new_status = ""
        for t_name, t_status in pairs (fbh_hooked_status) do
            new_names = new_names .. t_name .. fbh_newline
            new_status = new_status .. t_status .. fbh_newline
            win_height = win_height + 30
            height_count = height_count + 1
        end
    fbh_show_window()
    statusName:SetText(new_names)
    statusText:SetText(new_status)
    fbh_guiFrame:SetSize(fbh_width, win_height - 10)
    end
end

function fbh_set_status_msg()
    if FBHLeadOrAssi then
        local gru_ini = fbh_count_ini()
        local gru_wait = fbh_count_wait()
        fbh_id_status = "Status#"..FBHPLAYER..":"..gru_ini.." drin "..gru_wait.." in Warteposition"
    end
end

function fbh_send_status()
    if FBHLeadOrAssi then
        local send_hook_size = getn(fbh_hooked_sender)
        if send_hook_size > 0 then
            for arr = 1, send_hook_size do
                C_ChatInfo.SendAddonMessage(FBHStatus, fbh_id_status, "WHISPER", fbh_hooked_sender[arr])
            end
        else
            return false
        end
    end
end

function fbh_kill_status()
    fbh_id_status = FBHStatusCode .. "delete"
    fbh_send_status()
    fbh_id_status = ""
    fbh_hooked_sender = {}
end

function fbh_delete_status(to_delete)
    for t_name, t_status in pairs (fbh_hooked_status) do
        if t_name == to_delete then
            fbh_hooked_status[t_name] = nil
        end
    end
    fbh_update_status()
end

function fbh_show_window()
    if not next(fbh_hooked_status) then
        fbh_status_window = false
    else
        fbh_status_window = true
    end
    if fbh_status_window then
        fbh_guiFrame:Show()
    else
        fbh_guiFrame:Hide()
    end
end

function check_dm_buffs(dm_name)
    target_has_dm_buffs = 0
    c_thdm = 0
    if fbh_check_for_spell(dm_name,22820,0) then c_thdm = c_thdm + 1 end
    if fbh_check_for_spell(dm_name,22817,0) then c_thdm = c_thdm + 1 end
    if fbh_check_for_spell(dm_name,22818,0) then c_thdm = c_thdm + 1 end
    target_has_dm_buffs = c_thdm
    return target_has_dm_buffs
end

function fbh_check_for_spell(checkPlayer, checkSpellID, treshhold)-- return false if buff is running out or not exiting
    for i = 1, MAX_RAID_MEMBERS do
    name, _, _, debuffType, duration, expirationTime , _, _, _, spellId, _ = UnitBuff(checkPlayer,i)
    if name then 
        if spellId == checkSpellID then
        runout = ((GetTime() - expirationTime))
        runout_str = format("%.2f", runout)
        duration_str = format("%.2f", duration)
        --print(name.."=".."exptime= "..expirationTime..":"..runout.."/"..duration.."s")
            if runout < duration * treshhold then
                return false
            else
                return true
            end
        end
    end
    end
    return false
end

function fbh_summon_msg(group, kassierer, portale)
    if FBHassist == nil or FBHtank == nil then
        fbh_get_tankassist()
    end
    local kunde = GetUnitName("target")
    local zone = GetZoneText()
    local port_msg = kunde .. ", ich beschwöre Dich nach " .. zone
    local draussen = check_ini("draussen")
    fbh_send_msg(port_msg)
    fbh_whisper(FBHSummonMessageW, kunde)
    if portale ~= nil and portale == 1 then
        fbh_portalmaker(kunde)
    end
    if kassierer ~= nil and kassierer == 1 then
        fbh_kassierer(kunde)
    end
    if group ~= nil and group ~= 0 and draussen then
        if group >= 1 or group <= 7 then
            SetRaidSubgroup(UnitInRaid("target"), group)
        end
    end
end

function fbh_add_dnd_author(author_to_add)
    local name_to_add = gsub(author_to_add, FBHREALM, "")
    local author_filter_size = getn(fbh_dnd_filter_author)
    if author_filter_size == 0 then
        fbh_dnd_filter_author[1] = name_to_add
    elseif author_filter_size > 0 then
        for arr = 1, author_filter_size do
            if fbh_dnd_filter_author[arr] == name_to_add then
                return false
            else
                fbh_dnd_filter_author[author_filter_size + 1] = name_to_add
            end
        end
    end
end

local function fbh_hideDND(self, event, msg, author, ...)
    ret_dnd = false
    local dnd_author = gsub(author, FBHREALM, "")
    local author_dnd_size = getn(fbh_dnd_filter_author)
    if author_dnd_size >= 1 then
        for arr = 1, author_dnd_size do
            if fbh_dnd_filter_author[arr] == dnd_author then
                ret_dnd = true
            end
        end
    end
    return ret_dnd
end

local function hideKICKWhispers(self, event, msg, author, ...)
    hide_whisper = false
    if hide_kick then
        if msg:find(FBHCode, 1, true) then
            hide_whisper = true
        end
    end
    return hide_whisper
end

function count_shards()
    return GetItemCount(6265)
end

function fbh_ask_shards(warlock)
    C_ChatInfo.SendAddonMessage(FBHShards, "status", "WHISPER", warlock)
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", fbh_hideDND)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", hideKICKWhispers)
