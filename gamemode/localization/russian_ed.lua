-- Basic information
LANG.Name		= "Russian (font)"	-- Native name for language
LANG.Id			= "rus"		-- Find corresponding ID in garrysmod/resource/localization
LANG.Author		= "Totor"		-- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

-- Common
LANG.Cinema						= "CINEMA"
LANG.Volume						= "Ãðîìêîñòý"
LANG.Voteskips					= "Ïðîïóñê"
LANG.Loading					= "Çàãðóçêà..."
LANG.Invalid					= "[ÍÅÏÐÀÂÈËÝÍÎ]"
LANG.NoVideoPlaying				= "Íåò âèäåî"
LANG.Cancel						= "Îòìåíà"
LANG.Set						= "Óñòàíîâèòý"

//SetClipboardText(translations.replacer(LANG.NoVideoPlaying))

-- Theater Announcements
-- modules/theater/cl_init.lua
-- modules/theater/sh_commands.lua
-- modules/theater/sh_theater.lua
LANG.Theater_VideoRequestedBy 		= C("Текущее видео поставил ",ColHighlight,"%s",ColDefault,".")
LANG.Theater_InvalidRequest 		= "Неправильный запрос видео."
LANG.Theater_AlreadyQueued 			= "Выбранное видео уже есть в очереди."
LANG.Theater_ProcessingRequest 		= C("Обработка ",ColHighlight,"%s",ColDefault," запроса...")
LANG.Theater_RequestFailed 			= "Возникла проблема во время обработки выбранного видео."
LANG.Theater_Voteskipped 			= "Это видео было пропущено из за голосования."
LANG.Theater_ForceSkipped 			= C(ColHighlight,"%s",ColDefault," выключил текущее видео.")
LANG.Theater_PlayerReset 			= C(ColHighlight,"%s",ColDefault," перезагрузил театр.")
LANG.Theater_LostOwnership 			= "Вы потеряли владения над театром из за выхода из театра."
LANG.Theater_NotifyOwnership 		= "Вы стали владельцем этого приватного театра."
LANG.Theater_OwnerLockedQueue 		= "Владелец театра отключил возможность вставку видео в очередь."
LANG.Theater_LockedQueue 			= C(ColHighlight,"%s",ColDefault," закрыл возможность вставки видео.")
LANG.Theater_UnlockedQueue 			= C(ColHighlight,"%s",ColDefault," открыл возможность вставки видео.")
LANG.Theater_OwnerUseOnly 			= "Только владелец театра может использовать это."
LANG.Theater_PublicVideoLength 		= "Максимальный лимит видео в Публичном Театре %s секунд(ы) в длину."
LANG.Theater_PlayerVoteSkipped 		= C(ColHighlight,"%s",ColDefault," проголосовал за пропуск ",ColHighlight,"(%s/%s)",ColDefault,".")
LANG.Theater_VideoAddedToQueue 		= C(ColHighlight,"%s",ColDefault," было добавлено в очередь.")

-- Warnings
-- cl_init.lua
LANG.Warning_Unsupported_Line1	= "Òåêóúà¦ êàðòà íå ïîääåðæèâàåòñ¦ èãðîâüì ðåæèìîì Cinema"
LANG.Warning_Unsupported_Line2	= "Íàæìèòå F1 øòîáü íàéòè îôèöèàëýíüå êàðòü â ÂîðêÙîïå"
LANG.Warning_OSX_Line1			= "Ó Mac OS X ïîëýçîâàòåëåé ìîãóò âîçíèêíóòý ïóñòüå þêðàíü â Êèíîòåàòðå"
LANG.Warning_OSX_Line2	       = "Íàæìèòå F1 øòîáü ïîëóøèòý ñîâåòü ïî óñòðàíåíèÿ íåïîëàäîê è çàêðüòý þòî ñîîáúåíèå"

-- Queue
-- modules/scoreboard/cl_queue.lua
LANG.Queue_Title				= "Îøåðåäý"
LANG.Request_Video 				= "Ïîñòàâèòý Âèäåî"
LANG.Vote_Skip 					= "Ãîëîñîâàòý Çà Ïðîïóñê"
LANG.Toggle_Fullscreen 			= "Ïîëíîþêðàííüé Ðåæèì"
LANG.Refresh_Theater			= "Ïåðåçàãðóçèòý Òåàòð"

-- Theater controls
-- modules/scoreboard/cl_admin.lua
LANG.Theater_Admin				= "Àäìèí"
LANG.Theater_Owner				= "Âëàäåëåö"
LANG.Theater_Skip				= "Óáðàòý Âèäåî"
LANG.Theater_Seek				= "Ïåðåìîòàòý"
LANG.Theater_Reset				= "Ïåðåçàãðóçèòý"
LANG.Theater_ChangeName			= "Ñìåíèòý èì¦"
LANG.Theater_QueueLock			= "Çàêðüòý Âñòàâêó Âèäåî"
LANG.Theater_SeekQuery			= "ЧЧ:ММ:СС или число в секундах (пример. 1:30:00 или 5400)"


-- Theater list
-- modules/scoreboard/cl_theaterlist.lua
LANG.TheaterList_NowShowing		= "Ñåéøàñ Ïîêàçüâàÿò"

//SetClipboardText(translations.replacer(LANG.TheaterList_NowShowing))
-- Request Panel
-- modules/scoreboard/cl_request.lua
LANG.Request_History			= "Èñòîðè¦"
LANG.Request_Clear				= "Îøèñòèòý"
LANG.Request_DeleteTooltip		= "Óäàëèòý âèäåî èç èñòîðèè"
LANG.Request_PlayCount			= "%d ïðîñìîòðà(îâ)" -- e.g. 10 request(s)
LANG.Request_Url				= "Âüáðàòý Âèäåî"
LANG.Request_Url_Tooltip		= "Íàæìèòå ñÿäà øòîáü äîáàâèòý âèäåî â îøåðåäý.\nÊíîïêà áóäåò êðàñíà¦ åñëè ññüëêà íå ïðàâèëýíà¦."


-- Scoreboard settings panel
-- modules/scoreboard/cl_settings.lua
LANG.Settings_Title				= "Íàñòðîéêè"
LANG.Settings_ClickActivate		= "Êëèê øòîáü àêòèâèðîâàòý ìüùêó"
LANG.Settings_VolumeLabel		= "Ãðîìêîñòý"
LANG.Settings_VolumeTooltip		= "Èñïîëýçóéòå +/- êíîïêè øòîáü óâåëèøèòý/óìåíýùèòý ãðîìêîñòý."
LANG.Settings_HDLabel			= "ïðîèãðüâàòý âèäåî â HD"
LANG.Settings_HDTooltip			= "Âêëÿøèòý âîñïðîèçâåäåíèå âèäåî âüñîêîé øåòêîñòè íà HD, åñëè âèäåî â HD."
LANG.Settings_HidePlayersLabel	= "ïð¦òàòý èãðîêîâ â òåàòðå"
LANG.Settings_HidePlayersTooltip = "Â òåàòðàõ èãðîêè ñòàíóò íåâèäèìüå äë¦ âàñ."
LANG.Settings_MuteFocusLabel	= "ãëóùèòý çâóê â íå èãðü"
LANG.Settings_MuteFocusTooltip	= "Îòêëÿøåíèå çâóêà òåàòðà êîãäà âü â íå èãðü (íàïðèìåð. èãðà ñâåðíóòà)."

//SetClipboardText(translations.replacer(LANG.Settings_MuteFocusLabel))
-- Video Services
LANG.Service_EmbedDisabled 		= "Запрещено вставлять выбранное видео."
LANG.Service_PurchasableContent = "Данное видео имеет запрещенный контент, и не может быть вставлено в очередь."
LANG.Service_StreamOffline 		= "Запрашиваемый стрим оффлайн."

-- Version 1.1
LANG.TranslationsCredit = "Перевод запилил %s"