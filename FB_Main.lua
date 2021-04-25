local FBHA = CreateFrame("Frame", "FBHA", UIParent)
C_ChatInfo.RegisterAddonMessagePrefix(FBHPrefix)
C_ChatInfo.RegisterAddonMessagePrefix(FBHStatus)
C_ChatInfo.RegisterAddonMessagePrefix(FBHHookSender)
FBHA:RegisterEvent("ADDON_LOADED")
FBHA:RegisterEvent("CHAT_MSG_ADDON")
FBHA:RegisterEvent("CHAT_MSG_SYSTEM")
FBHA:RegisterEvent("CHAT_MSG_WHISPER")
FBHA:RegisterEvent("GROUP_ROSTER_UPDATE")

function FBHA_OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        fbh_loaded = true
    end
    if fbh_loaded then
        if event == "CHAT_MSG_WHISPER" then
            local fbh_f_msg, fbh_f_sender = select('1', ...), gsub(select('2', ...), FBHREALM, "")
            if strfind(fbh_f_msg, FBHCode, 1) == 1 then
                fbh_hook_sender(fbh_f_sender)
                local kunde = gsub(fbh_f_msg, FBHCode, "")
                InviteUnit(kunde)
            end
        end
        if event == "CHAT_MSG_SYSTEM" then
            local fbh_cmc = select('1', ...)
            if strfind(fbh_cmc, FBHoffline, 1) == 1 then
                fbh_unhook_offline_sender(fbh_cmc)
            end
            if strmatch(fbh_cmc, FBHnewMember) and UnitIsGroupLeader("player") then
                local new_raid_member = gsub(fbh_cmc, FBHnewMember, "")
                newMembers(new_raid_member)
            end
        end
        if event == "CHAT_MSG_ADDON" then
            fbh_player_inRaid()
            fbh_player_hasRights()
            local cma_pre, cma_msg, cma_typ, cma_from = select('1', ...), select('2', ...), select('3', ...), gsub(select('4', ...), FBHREALM, "")
            -- if cma_pre == FBHPrefix or cma_pre == FBHStatus or cma_pre == FBHDelete or cma_pre == FBHHookSender then
                -- print("CHAT_MSG_ADDON " .. cma_from .. " : " .. cma_pre .. " : " .. cma_msg )
            -- end
            if cma_pre == FBHStatus then
                if cma_msg == "Status#delete" then
                    fbh_delete_status(cma_from)
                else    
                    fbh_hook_status(cma_msg)
                end
            elseif cma_pre == FBHHookSender then
                if FBHRAID and FBHLeadOrAssi then
                    fbh_hook_sender(cma_from)
                    fbh_set_status_msg()
                    fbh_send_status()
                end
            end
        end
        if event == "GROUP_ROSTER_UPDATE" then
            fbh_roster_update()
            if not UnitInRaid("player") then
                fbh_kill_status()
            else
                if FBHassist == nil or FBHtank == nil then
                    fbh_get_tankassist()
                end
                if getn(fbh_hooked_sender) > 0 then
                    fbh_set_status_msg()
                    fbh_send_status()
                end
            end
        end
    end


end

FBHA:SetScript("OnEvent", FBHA_OnEvent)
