FBH = "FastBuffHelper"
FBHCode = "fbh:ready#"
FBHStatusCode = "Status#"
FBHKickMessageW = "Ich schicke dich in die andere ID, nach dem Kick erfolgt umgehend eine Einladung von "
FBHSummonMessageW = "Hey Du ... Ja genau Du ... Die Beschwörung ist im Gange. "
FBHSummonMessage = " Bitte anschnallen! Dein Flug mit <FastBuff Airlines> wird vorbereitet."
FBHPortalMessage = "<FastBuff Airlines> Achtung, hier entsteht ein Portal nach "
FBHMageW = "Ein Portal gibts auf Wunsch dann am Nordeingang von "
FBHPrefix = "FBHADDON"
FBHStatus = "FBHSTATUS"
FBHHookSender = "FBHHOOKSENDER"
fbh_loaded = false
FBHPLAYER = GetUnitName("player")
FBHREALM = "-"..GetRealmName()
fbh_name_separator = ":"
fbh_dnd_filter_author = {}
fbh_hooked_sender = {}
fbh_hooked_status = {}
fbh_width = 280
fbh_status_window = false
fbh_id_status = ""
fbh_status_name, fbh_status_msg = "", ""
fbh_newline = "\r\n\r\n"
FBHtank = nil
FBHassist = nil
FBHRAID = false
FBHLeadOrAssi = false
ret_dnd = false
hide_kick = false
hide_whisper = false
FBHoffline = "Momentan ist kein Spieler mit dem Namen"