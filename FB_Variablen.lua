FBH = "FastBuffHelper"
FBHCode = "fbh:ready#"
FBHStatusCode = "Status#"
FBHMessage = "Ich schicke dich in die andere ID, nach dem Kick erfolgt umgehend eine Einladung von "
FBHPrefix = "FBHADDON"
FBHStatus = "FBHSTATUS"
FBHDelete = "FBHDELETE"
fbh_loaded = false
FBHPLAYER = GetUnitName("player")
FBHREALM = "-"..GetRealmName()
fbh_name_separator = ":"
fbh_hooked_sender = {}
fbh_hooked_status = {}
-- fbh_hooked_status["Naxxani"] = " 1 drin 1 Warteposition"
-- fbh_hooked_status["Orwell"] = " 2 drin 3 Warteposition"
-- fbh_hooked_status["Portmel"] = " 2 drin 3 Warteposition"
fbh_width = 280
fbh_status_window = false
fbh_id_status = ""
fbh_status_name, fbh_status_msg = "", ""
fbh_newline = "\r\n\r\n"

-- fbh_hooked_status["Naxxani"] = " 1 drin 1 Warteposition"
-- fbh_hooked_status["Orwell"] = " 2 drin 3 Warteposition"
-- fbh_hooked_status["Portmel"] = " 2 drin 3 Warteposition"
-- fbh_hooked_status["Stigmata"] = " 2 drin 3 Warteposition"
-- fbh_hooked_status["Cheapsheep"] = " 2 drin 0 Warteposition"


members={}
member_count_old=0
first_launch = true
sort_once=false
my_name, my_rank, my_subgroup, my_level, my_class, my_fileName,my_zone_backup, my_online, my_isDead, my_role, my_isML, my_combatRole = nil