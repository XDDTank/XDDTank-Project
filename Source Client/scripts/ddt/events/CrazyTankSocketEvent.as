package ddt.events
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class CrazyTankSocketEvent extends Event
   {
      
      public static const POPUP_LEAGUESTART_NOTICE:String = "popup_leagueStart_notice";
      
      public static const LEFT_GUN_ROULETTE:String = "left_gun_roulette";
      
      public static const LEFT_GUN_ROULETTE_START:String = "left_gun_roulette_start";
      
      public static const USER_LUCKYNUM:String = "userluckynum";
      
      public static const LITTLEGAME_ACTIVED:String = "littlegameactived";
      
      public static const BAG_LOCKED:String = "bagLocked";
      
      public static const OPEN_BAG_CELL:String = "openbagCell";
      
      public static const CONSORTIA_EQUIP_CONTROL:String = "consortiaEquipControl";
      
      public static const PLAYER_START_MOVE:String = "playerStartMove";
      
      public static const PLAYER_STOP_MOVE:String = "playerStopMove";
      
      public static const PLAY_FINISH:String = "playeFinished";
      
      public static const PLAYER_MOVE:String = "playerMove";
      
      public static const BOMB_DIE:String = "bombDie";
      
      public static const DAILY_AWARD:String = "dailyAward";
      
      public static const DIRECTION_CHANGED:String = "playerDirection";
      
      public static const CHANGE_BALL:String = "changeBall";
      
      public static const PLAYER_GUN_ANGLE:String = "playerGunAngle";
      
      public static const PLAYER_SHOOT:String = "playerShoot";
      
      public static const PLAYER_ALL_SHOOT:String = "player_all_shoot";
      
      public static const PLAYER_SHOOT_TAG:String = "playerShootTag";
      
      public static const PLAYER_BEAT:String = "playerBeat";
      
      public static const BOX_DISAPPEAR:String = "boxdisappear";
      
      public static const PLAYER_CHANGE:String = "playerChange";
      
      public static const PLAYER_BLOOD:String = "playerBlood";
      
      public static const PLAYER_FROST:String = "playerFrost";
      
      public static const PLAYER_INVINCIBLY:String = "playerInvincibly";
      
      public static const PLAYER_HIDE:String = "playerHide";
      
      public static const PLAYER_CARRY:String = "playerCarry";
      
      public static const PLAYER_BECKON:String = "playerBeckon";
      
      public static const PLAYER_NONOLE:String = "playerNoNole";
      
      public static const PLAYER_PROPERTY:String = "playerProperty";
      
      public static const CHANGE_STATE:String = "changeState";
      
      public static const PLAYER_VANE:String = "playerVane";
      
      public static const PLAYER_APK:String = "playerAPK";
      
      public static const PLAYER_PICK_BOX:String = "playerPick";
      
      public static const PLAYER_FIGHT_PROP:String = "playerFightProp";
      
      public static const PLAYER_STUNT:String = "playerStunt";
      
      public static const PLAYER_PROP:String = "playerProp";
      
      public static const PLAYER_DANDER:String = "playerDander";
      
      public static const REDUCE_DANDER:String = "reduceDander";
      
      public static const LOAD:String = "load";
      
      public static const PLAYER_ADDATTACK:String = "playerAddAttack";
      
      public static const PLAYER_ADDBAL:String = "playerAddBall";
      
      public static const SHOOTSTRAIGHT:String = "shootStaight";
      
      public static const SUICIDE:String = "suicide";
      
      public static const USE_PET_SKILL:String = "usePetSkill";
      
      public static const PET_BEAT:String = "petBeat";
      
      public static const PET_SKILL_CD:String = "petSkillCD";
      
      public static const WISHOFDD:String = "wishofdd";
      
      public static const PET_BUFF:String = "petBuff";
      
      public static const PING:String = "ping";
      
      public static const NETWORK:String = "netWork";
      
      public static const GAME_TAKE_TEMP:String = "gameTakeTemp";
      
      public static const CONNECT_SUCCESS:String = "connectSuccess";
      
      public static const LOGIN:String = "login";
      
      public static const PFINFO:String = "pfInfo";
      
      public static const GAME_ROOM_CREATE:String = "gameRoomCreate";
      
      public static const GAME_ROOMLIST_UPDATE:String = "gameRoomListUpdate";
      
      public static const ROOMLIST_PASS:String = "RoomListPass";
      
      public static const SCENE_ADD_USER:String = "sceneAddUser";
      
      public static const GAME_PLAYER_ENTER:String = "gamePlayerEnter";
      
      public static const KIT_USER:String = "kitUser";
      
      public static const UPDATE_PRIVATE_INFO:String = "updateAllSorce";
      
      public static const QQTIPS_GET_INFO:String = "QQTIPSGETINFO";
      
      public static const EDICTUM_GET_VERSION:String = "edictum_get_version";
      
      public static const GAME_ROOM_UPDATE_PLACE:String = "gameRoomOpen";
      
      public static const GAME_ROOM_KICK:String = "gameRoomKick";
      
      public static const GAME_PLAYER_EXIT:String = "GamePlayerExit";
      
      public static const GAME_WAIT_RECV:String = "recvGameWait";
      
      public static const GAME_WAIT_FAILED:String = "GameWaitFailed";
      
      public static const GAME_AWIT_CANCEL:String = "GameWaitCancel";
      
      public static const GMAE_STYLE_RECV:String = "GameStyleRecv";
      
      public static const GAME_ROOM_LOGIN:String = "gameLogin";
      
      public static const GAME_TEAM:String = "gameTeam";
      
      public static const GAME_PLAYER_STATE_CHANGE:String = "playerState";
      
      public static const GAME_ROOM_FULL:String = "gameRoomFull";
      
      public static const GAME_CREATE:String = "gameCreate";
      
      public static const GAME_START:String = "gameStart";
      
      public static const GAME_LOAD:String = "gameLoad";
      
      public static const GAME_MISSION_INFO:String = "gameMissionInfo";
      
      public static const SCENE_CHANNEL_CHANGE:String = "sceneChannelChange";
      
      public static const SCENE_CHAT:String = "scenechat";
      
      public static const SCENE_FACE:String = "sceneface";
      
      public static const SCENE_REMOVE_USER:String = "sceneRemoveUser";
      
      public static const DELETE_GOODS:String = "deletegoods";
      
      public static const BUY_GOODS:String = "buygoods";
      
      public static const BUY_BEAD:String = "buybead";
      
      public static const CHANGE_GOODS_PLACE:String = "changegoodsplace";
      
      public static const BREAK_GOODS:String = "breakgoods";
      
      public static const CHAIN_EQUIP:String = "chainequip";
      
      public static const UNCHAIN_EQUIP:String = "unchainequip";
      
      public static const SELL_GOODS:String = "sellgoods";
      
      public static const REPAIR_GOODS:String = "repairGoods";
      
      public static const SEND_EMAIL:String = "sendEmail";
      
      public static const DELETE_MAIL:String = "deleteMail";
      
      public static const GET_MAIL_ATTACHMENT:String = "getMailAttachment";
      
      public static const MAIL_CANCEL:String = "mailCancel";
      
      public static const MAIL_RESPONSE:String = "mailResponse";
      
      public static const CONSORTION_MAIL:String = "consortionMail";
      
      public static const GRID_PROP:String = "gridProp";
      
      public static const GRID_GOODS:String = "gridgoods";
      
      public static const UPDATE_COUPONS:String = "updateCoupons";
      
      public static const UPDATE_OFFER:String = "updateoffer";
      
      public static const ITEM_STORE:String = "itemStore";
      
      public static const CHECK_CODE:String = "checkCode";
      
      public static const GET_DYNAMIC:String = "get_dynamic";
      
      public static const CONSORTIA_RESPONSE:String = "consortiaresponse";
      
      public static const CONSORTIA_USER_GRADE_UPDATE:String = "consortiagradeuodateevent";
      
      public static const CONSORTIA_CREATE:String = "consortiacreateevent";
      
      public static const CONSORTIA_TRYIN:String = "consortiatryinevent";
      
      public static const CONSORTIA_TRYIN_DEL:String = "consortiatryindelevent";
      
      public static const CONSORTIA_PLACARD_UPDATE:String = "consortiaPlacardUpdate";
      
      public static const CONSORTIA_DESCRIPTION_UPDATE:String = "consortiadescriptionupdate";
      
      public static const CONSORTIA_DISBAND:String = "consortiadisbandevent";
      
      public static const CONSORTIA_APPLY_STATE:String = "consortiaapplystateevent";
      
      public static const CONSORTIA_INVITE_PASS:String = "consortiainvatepassevent";
      
      public static const CONSORTIA_INVITE_DELETE:String = "consortiainvatedeleteevent";
      
      public static const CONSORTIA_INVITE:String = "consortiainvateevent";
      
      public static const CONSORTIA_RENEGADE:String = "consortiarenegadeevent";
      
      public static const CONSORTIA_DUTY_DELETE:String = "consortiadutydeleteevent";
      
      public static const CONSORTIA_DUTY_UPDATE:String = "consortiadutyupdateevent";
      
      public static const CONSORTIA_BANCHAT_UPDATE:String = "consortiabanchatupdateevent";
      
      public static const CONSORTIA_USER_REMARK_UPDATE:String = "consortiauserremarkupdateevent";
      
      public static const CONSORTIA_CHAT:String = "consortiachatevent";
      
      public static const CONSORTIA_ALLY_APPLY_UPDATE:String = "consortiaAllyAppleUpdate";
      
      public static const CONSORTIA_ALLY_UPDATE:String = "consortiaallyupdate";
      
      public static const CONSORTIA_ALLY_APPLY_DELETE:String = "consortiaallyapplydelete";
      
      public static const CONSORTIA_ALLY_APPLY_ADD:String = "consortiaallyapplyadd";
      
      public static const CONSORTIA_LEVEL_UP:String = "consortialevelup";
      
      public static const CONSORTIA_HALL_UP:String = "consortiahallup";
      
      public static const CONSORTIA_SHOP_UP:String = "consortiashopup";
      
      public static const CONSORTIA_SKILL_UP:String = "consortiaskillup";
      
      public static const CONSORTIA_CHAIRMAN_CHAHGE:String = "consortiachairmanchange";
      
      public static const CONSORTIA_TRYIN_PASS:String = "consortiatryinpass";
      
      public static const CONSORTIA_RICHES_OFFER:String = "consortiaRichesOffer";
      
      public static const CONSORTIA_MAIL_MESSAGE:String = "consortiaMailMessage";
      
      public static const CONSORTIA_UPGRADE_PLACARD:String = "consortionupgradeplacard";
      
      public static const BUY_BADGE:String = "buyBadge";
      
      public static const GAME_OVER:String = "gameOver";
      
      public static const MISSION_OVE:String = "missionOver";
      
      public static const MISSION_COMPLETE:String = "missionOver";
      
      public static const GAME_ALL_MISSION_OVER:String = "gameAllMissionOver";
      
      public static const GAME_TAKE_OUT:String = "gameTakeOut";
      
      public static const GAME_ROOM_SETUP_CHANGE:String = "gameRoomSetUp";
      
      public static const EQUIP_CHANGE:String = "equipchange";
      
      public static const MARRYINFO_GET:String = "marryinfoget";
      
      public static const AMARRYINFO_REFRESH:String = "amarryinforefresh";
      
      public static const GAME_OPEN_SELECT_LEADER:String = "gameOpenSelectLeader";
      
      public static const GAME_WANNA_LEADER:String = "gameWannaLeader";
      
      public static const GAME_CAPTAIN_CHOICE:String = "gamecaptionchoice";
      
      public static const GAME_CAPTAIN_AFFIRM:String = "gamecaptainaffirm";
      
      public static const SCENE_USERS_LIST:String = "sceneuserlist";
      
      public static const GAME_INVITE:String = "gameinvite";
      
      public static const UPDATE_PLAYER_INFO:String = "updatestyle";
      
      public static const TEMP_STYLE:String = "tempStyle";
      
      public static const S_BUGLE:String = "sbugle";
      
      public static const B_BUGLE:String = "bbugle";
      
      public static const C_BUGLE:String = "cbugle";
      
      public static const CHAT_PERSONAL:String = "chatpersonal";
      
      public static const FRIEND_ADD:String = "friendAdd";
      
      public static const FRIEND_REMOVE:String = "friendremove";
      
      public static const FRIEND_UPDATE:String = "friendupdate";
      
      public static const FRIEND_STATE:String = "friendstate";
      
      public static const ITEM_COMPOSE:String = "itemCompose";
      
      public static const ITEM_SPLITE:String = "itemSplite";
      
      public static const ITEM_STRENGTH:String = "itemstrength";
      
      public static const ITEM_TRANSFER:String = "itemtransfer";
      
      public static const GET_COMPOSE_SKILL:String = "getComposeSkill";
      
      public static const HOLE_EQUIP:String = "hole equip";
      
      public static const MOSAIC_EQUIP:String = "mosaic equip";
      
      public static const DEFY_AFFICHE:String = "DefyAffiche";
      
      public static const ITEM_REFINERY_PREVIEW:String = "itemRefineryPreview";
      
      public static const ITEM_REFINERY:String = "itemRefinery";
      
      public static const ITEM_EMBED:String = "itemEmbed";
      
      public static const OPEN_FIVE_SIX_HOLE_EMEBED:String = "open_five_six_hole_embed";
      
      public static const CLEAR_STORE_BAG:String = "clearStoreBag";
      
      public static const SYS_CHAT_DATA:String = "syschatdata";
      
      public static const SYS_NOTICE:String = "sysnotice";
      
      public static const ITEM_CONTINUE:String = "itemContinue";
      
      public static const ITEM_EQUIP:String = "itemEquip";
      
      public static const FRIEND_RESPONSE:String = "friendresponse";
      
      public static const ITEM_OBTAIN:String = "itemObtain";
      
      public static const SYS_DATE:String = "sysDate";
      
      public static const QUEST_UPDATE:String = "quiestUpdate";
      
      public static const QUEST_OBTAIN:String = "quiestObtain";
      
      public static const QUEST_CHECK:String = "quiestCheck";
      
      public static const QUEST_FINISH:String = "quiestFinish";
      
      public static const QUEST_ONEKEYFINISH:String = "questOneKeyFinsh";
      
      public static const AUCTION_DELETE:String = "auctionDelete";
      
      public static const AUCTION_UPDATE:String = "auctionUpdate";
      
      public static const AUCTION_ADD:String = "auctionAdd";
      
      public static const AUCTION_REFRESH:String = "auctionRefresh";
      
      public static const CID_CHECK:String = "CIDCheck";
      
      public static const ENTHRALL_LIGHT:String = "CIDInfo";
      
      public static const BUFF_INFO:String = "buffInfo";
      
      public static const BUFF_OBTAIN:String = "buffObtain";
      
      public static const BUFF_ADD:String = "buffAdd";
      
      public static const BUFF_UPDATE:String = "buffUpdate";
      
      public static const USE_COLOR_CARD:String = "useColorCard";
      
      public static const USE_COLOR_SHELL:String = "useColorShell";
      
      public static const MARRY_ROOM_CREATE:String = "marry room create";
      
      public static const MARRY_ROOM_LOGIN:String = "marry room login";
      
      public static const MARRY_SCENE_LOGIN:String = "marry scene login";
      
      public static const MARRY_SCENE_CHANGE:String = "marry scene change";
      
      public static const PLAYER_ENTER_MARRY_ROOM:String = "player enter room";
      
      public static const PLAYER_EXIT_MARRY_ROOM:String = "exit marry room";
      
      public static const MARRY_APPLY:String = "marray apply";
      
      public static const MARRY_APPLY_REPLY:String = "marry apply reply";
      
      public static const DIVORCE_APPLY:String = "divorce apply";
      
      public static const MARRY_STATUS:String = "marry status";
      
      public static const MOVE:String = "church move";
      
      public static const HYMENEAL:String = "hymeneal";
      
      public static const CONTINUATION:String = "church continuation";
      
      public static const INVITE:String = "church invite";
      
      public static const LARGESS:String = "church largess";
      
      public static const USEFIRECRACKERS:String = "use firecrackers";
      
      public static const KICK:String = "church kick";
      
      public static const FORBID:String = "church forbid";
      
      public static const MARRY_ROOM_STATE:String = "marry room state";
      
      public static const HYMENEAL_STOP:String = "hymeneal stop";
      
      public static const MARRY_ROOM_DISPOSE:String = "marry room dispose";
      
      public static const MARRY_ROOM_UPDATE:String = "marry room update";
      
      public static const MARRYPROP_GET:String = "marryprop get";
      
      public static const GUNSALUTE:String = "Gun Salute";
      
      public static const MATE_ONLINE_TIME:String = "Mate_Online_Time";
      
      public static const MARRYROOMSENDGIFT:String = "marryRoomSendGift";
      
      public static const MARRYINFO_UPDATE:String = "marryinfo update";
      
      public static const MARRYINFO_ADD:String = "marryInfo add";
      
      public static const PLAY_MOVIE:String = "playMovie";
      
      public static const ADD_LIVING:String = "addLiving";
      
      public static const ADD_MAP_THINGS:String = "addMapThing";
      
      public static const LIVING_MOVETO:String = "livingMoveTo";
      
      public static const LIVING_FALLING:String = "livingFalling";
      
      public static const LIVING_JUMP:String = "livingJump";
      
      public static const LIVING_BEAT:String = "livingBeat";
      
      public static const LIVING_SAY:String = "livingSay";
      
      public static const LIVING_RANGEATTACKING:String = "livingRangeAttacking";
      
      public static const BARRIER_INFO:String = "barrierInfo";
      
      public static const ADD_MAP_THING:String = "addMapThing";
      
      public static const UPDATE_BOARD_STATE:String = "updateBoardState";
      
      public static const GAME_MISSION_START:String = "gameMissionStart";
      
      public static const GAME_MISSION_PREPARE:String = "gameMissionPrepare";
      
      public static const SHOW_CARDS:String = "showCard";
      
      public static const UPDATE_BUFF:String = "updateBuff";
      
      public static const GEM_GLOW:String = "gemGlow";
      
      public static const LINKGOODSINFO_GET:String = "linkGoodsInfo";
      
      public static const FOCUS_ON_OBJECT:String = "focusOnObject";
      
      public static const GAME_ROOM_INFO:String = "gameRoomInfo";
      
      public static const ADD_TIP_LAYER:String = "addTipLayer";
      
      public static const PLAY_INFO_IN_GAME:String = "playInfoInGame";
      
      public static const PAYMENT_TAKE_CARD:String = "playmentTakeCard";
      
      public static const INSUFFICIENT_MONEY:String = "insufficientMoney";
      
      public static const GAME_MISSION_TRY_AGAIN:String = "gameMissionTryAgain";
      
      public static const GET_ITEM_MESS:String = "getItemMess";
      
      public static const USER_ANSWER:String = "userAnswer";
      
      public static const PLAY_SOUND:String = "playSound";
      
      public static const LOAD_RESOURCE:String = "loadResource";
      
      public static const PLAY_ASIDE:String = "playWordTip";
      
      public static const FORBID_DRAG:String = "forbidDrag";
      
      public static const TOP_LAYER:String = "topLayer";
      
      public static const GOODS_PRESENT:String = "goodsPresents";
      
      public static const GOODS_COUNT:String = "goodsCount";
      
      public static const CONTROL_BGM:String = "controlBGM";
      
      public static const FIGHT_LIB_INFO_CHANGE:String = "fightLibInfoChange";
      
      public static const USE_DEPUTY_WEAPON:String = "Use_Deputy_Weapon";
      
      public static const POPUP_QUESTION_FRAME:String = "popupQuestionFrame";
      
      public static const SHOW_PASS_STORY_BTN:String = "showPassStoryBtn";
      
      public static const LIVING_BOLTMOVE:String = "livingBoltmove";
      
      public static const CHANGE_TARGET:String = "changeTarget";
      
      public static const LIVING_SHOW_BLOOD:String = "livingShowBlood";
      
      public static const LIVING_SHOW_NPC:String = "livingShowNpc";
      
      public static const ACTION_MAPPING:String = "actionMapping";
      
      public static const FIGHT_ACHIEVEMENT:String = "fightAchievement";
      
      public static const APPLYSKILL:String = "applySkill";
      
      public static const REMOVESKILL:String = "removeSkill";
      
      public static const CHANGEMAXFORCE:String = "changedMaxForce";
      
      public static const HOTSPRING_ROOM_CREATE:String = "hotSpringRoomCreate";
      
      public static const HOTSPRING_ROOM_ADD_OR_UPDATE:String = "hotSpringListRoomAddOrUpdate";
      
      public static const HOTSPRING_ROOM_REMOVE:String = "hotSpringRoomRemove";
      
      public static const HOTSPRING_ROOM_LIST_GET:String = "hotSpringRoomListGet";
      
      public static const HOTSPRING_ROOM_ENTER:String = "hotSpringRoomEnter";
      
      public static const HOTSPRING_ROOM_PLAYER_ADD:String = "hotSpringRoomPlayerAdd";
      
      public static const HOTSPRING_ROOM_PLAYER_REMOVE:String = "hotSpringRoomPlayerRemove";
      
      public static const HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE:String = "hotSpringRoomPlayerRemoveNotice";
      
      public static const HOTSPRING_ROOM_PLAYER_TARGET_POINT:String = "hotSpringRoomPlayerTargetPoint";
      
      public static const HOTSPRING_ROOM_RENEWAL_FEE:String = "hotSpringRoomRenewalFee";
      
      public static const HOTSPRING_ROOM_INVITE:String = "hotSpringRoomInvite";
      
      public static const HOTSPRING_ROOM_TIME_UPDATE:String = "hotSpringRoomTimeUpdate";
      
      public static const HOTSPRING_ROOM_ENTER_CONFIRM:String = "hotSpringRoomEnterConfirm";
      
      public static const HOTSPRING_ROOM_PLAYER_CONTINUE:String = "hotSpringRoomPlayerContinue";
      
      public static const GET_TIME_BOX:String = "getTimeBox";
      
      public static const UPDATE_TIME_BOX:String = "updateTimeBox";
      
      public static const ACHIEVEMENT_UPDATE:String = "achievementUpdate";
      
      public static const ACHIEVEMENT_FINISH:String = "achievementFinish";
      
      public static const ACHIEVEMENT_INIT:String = "achievementInit";
      
      public static const ACHIEVEMENTDATA_INIT:String = "achievementDateInit";
      
      public static const FIGHT_NPC:String = "fightNpc";
      
      public static const FEEDBACK_REPLY:String = "feedbackReply";
      
      public static const LOTTERY_ALTERNATE_LIST:String = "lottery_alternate_list";
      
      public static const LOTTERY_GET_ITEM:String = "lottery_get_item";
      
      public static const LOTTERY_OPNE:String = "lottery_open";
      
      public static const CADDY_GET_AWARDS:String = "caddy_get_awards";
      
      public static const CADDY_GET_CONVERTED:String = "caddy_get_converted";
      
      public static const CADDY_GET_EXCHANGEALL:String = "caddy_get_exchange";
      
      public static const CADDY_GET_BADLUCK:String = "caddy_get_badLuck";
      
      public static const OFFERPACK_COMPLETE:String = "offer_pack_complete";
      
      public static const LOOKUP_EFFORT:String = "lookupEffort";
      
      public static const ANSWERBOX_QUESTIN:String = "AnswerBoxQuestion";
      
      public static const VIP_IS_OPENED:String = "vipIsOpened";
      
      public static const VIP_REWARD_IS_TAKED:String = "vipRewardIsTaked";
      
      public static const ITEM_OPENUP:String = "ITEM_OPENUP";
      
      public static const WEEKLY_CLICK_CNT:String = "weeklyClickCnt";
      
      public static const APPRENTICE_SYSTEM_ANSWER:String = "ApprenticeSystemAnswer";
      
      public static const CARDS_DATA:String = "cards_data";
      
      public static const CARD_RESET:String = "card_reset";
      
      public static const GET_CARD:String = "get_card";
      
      public static const CARDS_SOUL:String = "cards_soul";
      
      public static const CARDS_PLAYER_DATA:String = "cards_player_data";
      
      public static const CHAT_FILTERING_FRIENDS_SHARE:String = "chatFilteringFriendsShare";
      
      public static const POLL_CANDIDATE:String = "pollCandidate";
      
      public static const SKILL_SOCKET:String = "skillSocket";
      
      public static const CONSORTIA_TASK_RELEASE:String = "consortia_task_release";
      
      public static const ONS_EQUIP:String = "onsItemEquip";
      
      public static const GAMESYSMESSAGE:String = "gamesysmessage";
      
      public static const WINDPIC:String = "windPic";
      
      public static const SAME_CITY_FRIEND:String = "sameCityFriend";
      
      public static const ADD_CUSTOM_FRIENDS:String = "addCustomFriends";
      
      public static const ONE_ON_ONE_TALK:String = "oneOnoneTalk";
      
      public static const ELITE_MATCH_TYPE:String = "eliteMatchType";
      
      public static const ELITE_MATCH_RANK_START:String = "eliteMatchRankStart";
      
      public static const ELITE_MATCH_PLAYER_RANK:String = "eliteMatchPlayerRank";
      
      public static const ELITE_MATCH_RANK_DETAIL:String = "eliteMatchRankDetail";
      
      public static const LIVING_CHAGEANGLE:String = "LivingChangeAngele";
      
      public static const WISHBEADEQUIP:String = "wishbeadequip";
      
      public static const REALlTIMES_ITEMS_BY_DISCOUNT:String = "RealTimesItemsByDisCount";
      
      public static const UPDATE_PET:String = "updatePet";
      
      public static const MOVE_PETBAG:String = "movePetBag";
      
      public static const FEED_PET:String = "feedPet";
      
      public static const EQUIP_PET_SKILL:String = "equipPetSkill";
      
      public static const RENAME_PET:String = "renamePet";
      
      public static const RELEASE_PET:String = "releasePet";
      
      public static const ADOPT_PET:String = "adoptPet";
      
      public static const REFRESH_PET:String = "refreshPet";
      
      public static const UPDATE_PET_SPACE:String = "update_pet_space";
      
      public static const PET_BLESS:String = "pet bless";
      
      public static const REFRASH_FARM:String = "RefreshFarm";
      
      public static const GAIN_FIELD:String = "gainField";
      
      public static const SEEDING:String = "seeding";
      
      public static const ACCELERATE_FIELD:String = "accelerateField";
      
      public static const UPROOT_FIELD:String = "uprootField";
      
      public static const OPTION_CHANGE:String = "optionChange";
      
      public static const CHANGE_SEX:String = "changeSex";
      
      public static const UPDATE_PLAYER_PROPERTY:String = "updateplayerproperty";
      
      public static const BEAD_HOLE_INFO:String = "beadHoleInfo";
      
      public static const BEAD_OPEN_PACKAGE:String = "getBead";
      
      public static const WORLDBOSS_INIT:String = "worldboss_init";
      
      public static const WORLDBOSS_OVER:String = "worldboss_over";
      
      public static const WORLDBOSS_ROOM:String = "worldboss_room";
      
      public static const WORLDBOSS_ROOM_LOGIN:String = "worldboss_room_login";
      
      public static const WORLDBOSS_MOVE:String = "worldboss_move";
      
      public static const WORLDBOSS_EXIT:String = "worldboss_exit";
      
      public static const WORLDBOSS_PLAYERSTAUTSUPDATE:String = "worldBoss_playerStautsUpdate";
      
      public static const WORLDBOSS_ROOMCLOSE:String = "worldBoss_roomclose";
      
      public static const WORLDBOSS_BLOOD_UPDATE:String = "boss_blood_update";
      
      public static const WORLDBOSS_ENTER:String = "worldboss_enter";
      
      public static const WORLDBOSS_FIGHTOVER:String = "worldboss_fightOver";
      
      public static const WORLDBOSS_RANKING:String = "worldboss_ranking";
      
      public static const WORLDBOSS_PLAYERREVIVE:String = "worldboss_revive";
      
      public static const WORLDBOSS_RANKING_INROOM:String = "worldboss_ranking_inroom";
      
      public static const WORLDBOSS_BUYBUFF:String = "worldboss_buy_buff";
      
      public static const WORLDBOSS_PRIVATE_INFO:String = "WORLDBOSS_PRIVATE_INFO";
      
      public static const UPDATE_BUFF_LEVEL:String = "UPDATE_BUFF_LEVEL";
      
      public static const SAVE_POINTS:String = "save_points";
      
      public static const SHOW_DIALOG:String = "show_dialog";
      
      public static const WALKSCENE_PLAYER_MOVE:String = "walkscenePlayerMove";
      
      public static const WALKSCENE_PLAYER_ENTER:String = "walkscenePlayerEnter";
      
      public static const WALKSCENE_PLAYER_INFO:String = "walkscenePlayerInfo";
      
      public static const WALKSCENE_PLAYER_EXIT:String = "walkscenePlayerExit";
      
      public static const WALKSCENE_OBJECT_CLICK:String = "walksceneObjectClick";
      
      public static const WALKSCENE_SAVE_POINTS:String = "walksceneSavePoints";
      
      public static const WALKSCENE_ADD_ROBOT:String = "walksceneAddRobot";
      
      public static const WALKSCENE_REMOVE_CD:String = "walkSveneRemoveCD";
      
      public static const SINGLEDUNGEON_MODE_UPDATE:String = "updateSingleDungeonModeInfo";
      
      public static const RELOAD_XML:String = "reloadXML";
      
      public static const BOSS_PLAYER_OBJECT:String = "bossPlayerThings";
      
      public static const DROP_GOODS:String = "dropGoods";
      
      public static const FIGHT_MODEL:String = "fightModel";
      
      public static const FIGHT_TOOL_BOX:String = "fightToolBox";
      
      public static const FIGHT_BOX_SKILL:String = "fightKitSkill";
      
      public static const BEAD_REQUEST_BEAD:String = "bead_request_bead";
      
      public static const BEAD_COMBINE_ONEKEY_TIP:String = "bead_combine_onekey_tip";
      
      public static const BEAD_RLIGHT_STATE:String = "bead_light_state";
      
      public static const BEAD_DEVOUR_PREVIEW:String = "bead_devour_preview";
      
      public static const FATIGUE:String = "fatigue";
      
      public static const EXPEDITION:String = "expedition";
      
      public static const MISSION_ENERGY:String = "mission_energy";
      
      public static const BUY_FATIGUE:String = "buy_fatigue";
      
      public static const TOTEM:String = "totem";
      
      public static const HONOR_UP_COUNT:String = "honor_up_count";
      
      public static const PET_REDUCE:String = "pet_reduce";
      
      public static const CD_COOLING_TIME:String = "cd_cooling_time";
      
      public static const FREE_ENTER:String = "free_enter";
      
      public static const MONEY_ENTER:String = "money_enter";
      
      public static const PUBLISH_TASK:String = "public_task";
      
      public static const ENTER_CONSORTION:String = "enter_consortion";
      
      public static const EXIT_CONSORTION:String = "exit_consortion";
      
      public static const CONSORTIONSENCE_MOVEPLAYER:String = "consortionsence_moveplayer";
      
      public static const CONSORTIONSENCE_ADDPLAYER:String = "consortionsence_addlayer";
      
      public static const CONSORTION_ADDMONSTER:String = "consortion_add_monster";
      
      public static const CONSORTION_REMOVEALLMONSTER:String = "consortion_remove_all_monster";
      
      public static const CONSORTION_MONSTER_STATE:String = "consortion_monster_state";
      
      public static const ENTER_TRNSPORT:String = "enter_transport";
      
      public static const UPDATE_MEMBER_INFO:String = "update_member_info";
      
      public static const GEGIN_CONVOY:String = "begin_convoy";
      
      public static const UPDATE_CAR_INFO:String = "update_car_info";
      
      public static const BUY_CAR:String = "buy_car";
      
      public static const INVITE_CONVOY:String = "invite_convoy";
      
      public static const CONVOY_INVITE_ANSWER:String = "invite_answer";
      
      public static const CANCLE_CONVOY_INVITE:String = "cancle_invite";
      
      public static const CONSORTIA_UPDATE_QUEST:String = "consortia_update_quest";
      
      public static const REQUEST_CONSORTIA_QUEST:String = "request_consortia_quest";
      
      public static const FIGHT_MONSTER:String = "fight_monster";
      
      public static const ACTIVE_STATE:String = "consortion_monster_active_state";
      
      public static const MONSTER_RANK_INFO:String = "monster_rank_info";
      
      public static const SELF_MONSTER_INFO:String = "self_monster_info";
      
      public static const CAR_RECEIVE:String = "car_receive";
      
      public static const HIJACK_CAR:String = "hijack_car";
      
      public static const HIJACK_ANSWER:String = "hijack_answer";
      
      public static const HIJACK_INFO_MESSAGE:String = "hijack_info_message";
      
      public static const SYNC_CONSORTION_RICH:String = "sync_consortion_rich";
      
      public static const SHOP_REFRESH_GOOD:String = "shop_refresh_good";
      
      public static const ONLINE_REWADS:String = "online_rewads";
      
      public static const CONSORTION_STATUS:String = "consortion_status";
      
      public static const UPDATE_EXPERIENCE:String = "update_experience";
      
      public static const ACTIVE_lOG:String = "activeLog";
      
      public static const ACTIVE_EXCHANGE:String = "activeExchange";
      
      public static const DAILY_RECEIVE:String = "dailyReceive";
      
      public static const DAILY_QUEST_UPDATE:String = "dailyQuestUpdate";
      
      public static const DAILY_QUEST_REWARD:String = "dailyQuestReward";
      
      public static const DAILY_QUEST_ONE_KEY:String = "dailyQuestOneKey";
      
      public static const RANDOM_PVE:String = "randomPve";
      
      public static const RANDOM_SCENE:String = "randomScene";
      
      public static const CLOSE_FRIEND_REWARD:String = "closeFriendReward";
      
      public static const CLOSE_FRIEND_CHANGE:String = "closeFriendChange";
      
      public static const CLOSE_FRIEND_ADD:String = "closeFriendAdd";
      
      public static const DIAMOND_AWARD:String = "diamond award";
      
      public static const REFINING:String = "refining";
      
      public static const PLAYER_END_FIRE:String = "player end fire";
      
      public static const LOTTERY_START:String = "lotteryStart";
      
      public static const LOTTERY_RANDOM:String = "lotteryRandom";
      
      public static const LOTTERY_FINISH:String = "lotteryFinish";
      
      public static const TURNPLATE_HISTORY_MESSAGE:String = "turnplateHistoryMessage";
      
      public static const DAMAGE_TYPE:String = "damage type";
      
      public static const ENERGY_RETURN:String = "energyReturn";
      
      public static const FIGHTROBOT_OPEN_FRAME:String = "openFrame";
      
      public static const FIGHTROBOT_CHANGE_PLAYER:String = "changePlayer";
      
      public static const FIGHTROBOT_HISTORY_MESSAGE:String = "fightRobotHistoryMessage";
      
      public static const FIGHTROBOT_CLEAR_CD:String = "fightRobotClearCD";
       
      
      private var _pkg:PackageIn;
      
      public var executed:Boolean;
      
      public function CrazyTankSocketEvent(param1:String, param2:PackageIn = null)
      {
         super(param1,bubbles,cancelable);
         this._pkg = param2;
      }
      
      public function get pkg() : PackageIn
      {
         return this._pkg;
      }
   }
}
