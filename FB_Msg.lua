function fbh_send_msg(msg)
    local x_ch = UnitInRaid("player") and "RAID" or "PARTY"
    SendChatMessage(msg,x_ch,nil,nil)
end

function fbh_whisper(message, recipient)
    local w_recipient = fbh_targetName()
    if recipient ~= nil then
        w_recipient = recipient
    end
    SendChatMessage(message, "WHISPER", nil, w_recipient)
end

function fbh_portal_msg(city)
    local port_msg = FBHPortalMessage .. city ..  "!"
    fbh_send_msg(port_msg)
end

function fbh_portalmaker(recipient, override)
    local port_maker = override
    if FBHassist ~= nil then
        if port_maker == nil then
            port_maker = FBHassist
        end
        fbh_whisper(FBHMageW .. port_maker, recipient)
    end
end

function fbh_kassierer(recipient)
    if FBHtank ~= nil then
        fbh_whisper("Bezahlen bitte bei " .. FBHtank, recipient)
    end
end

function fbh_port_msg()
    fbh_init()
    fbh_countmembers()
    if(UnitExists("target")) then
        local name, rank, subgroup, level, class, fileName,zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(UnitInRaid(fbh_targetName()))
        --local my_name, my_rank, my_subgroup, my_level, my_class, my_fileName,my_zone, my_online, my_isDead, my_role, my_isML, my_combatRole = GetRaidRosterInfo(UnitInRaid("player"))
        if my_zone==zone or zone==my_zone_backup then
            SendChatMessage("Du bist schon in "..zone..", wenn du dennoch einen Port willst sag Bescheid.","WHISPER",nil,name)
            print("dont port")
        else
            SendChatMessage(zone.." goto "..my_zone,"WHISPER",nil,name)
            SendChatMessage("Port auf "..name.." Bitte klicken!","RAID_WARNING",nil,name)
            if members[3]<5 then
                SetRaidSubgroup(UnitInRaid("target"), 3)
            else
                SetRaidSubgroup(UnitInRaid("target"), 2)
            end
        end
    end    
end

function fbh_info_msg()
    fbh_init()
    if IsInRaid() then
        for i=1,40 do  
            local name, rank, subgroup, level, class, fileName,zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)
            if name then 
                if subgroup==8  then
                    if role=="MAINTANK" then
                         bezahler= name
                    elseif role=="MAINASSIST" then
                         porter=name
                    end
                end
            end
        end
        if bezahler then
            SendChatMessage("Buchung und Bezahlung bei "..bezahler.."!","RAID_WARNING",nil,name)
        end
        if porter then
            SendChatMessage("Bei Eigenanreise Bezahlung bei "..porter.."!","RAID_WARNING",nil,name)    
            SendChatMessage("Portal bei "..porter.."!","RAID_WARNING",nil,name)
        end
    end
end
