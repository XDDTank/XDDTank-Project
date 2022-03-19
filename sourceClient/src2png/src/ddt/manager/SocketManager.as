// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.SocketManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import road7th.comm.ByteSocket;
    import flash.events.Event;
    import road7th.comm.SocketEvent;
    import flash.events.ErrorEvent;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.view.CheckCodeFrame;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import road7th.comm.PackageIn;
    import ddt.data.socket.ePackageType;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.data.socket.CrazyTankPackageType;
    import ddt.data.socket.AcademyPackageType;
    import arena.ArenaManager;
    import militaryrank.MilitaryRankManager;
    import fightRobot.FightRobotPackageType;
    import ddt.data.socket.TurnPlatePackageType;
    import turnplate.TurnPlateController;
    import SingleDungeon.expedition.view.ExpeditionEvents;
    import ddt.data.socket.ExpeditionType;
    import SingleDungeon.model.MiningPackageType;
    import ddt.data.socket.EquipSystemPackageType;
    import ddt.data.socket.FarmPackageType;
    import com.pickgliss.loader.LoaderSavingManager;
    import flash.external.ExternalInterface;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.socket.IMPackageType;
    import ddt.data.socket.ChurchPackageType;
    import ddt.data.socket.DailyQuestPackageType;
    import ddt.data.socket.HotSpringPackageType;
    import ddt.data.socket.ConsortiaPackageType;
    import consortion.data.ConsortiaMonsterPackageTypes;
    import ddt.data.socket.GameRoomPackageType;
    import ddt.data.socket.PetPackageType;
    import worldboss.model.WorldBossPackageType;
    import SingleDungeon.model.WalkSencePackageType;
    import bead.BeadPackageType;
    import totem.data.TotemPackageType;
    import ddt.data.socket.*;

    public class SocketManager extends EventDispatcher 
    {

        public static const PACKAGE_CONTENT_START_INDEX:int = 20;
        private static var _instance:SocketManager;

        private var _socket:ByteSocket;
        private var _out:GameSocketOut;
        private var _isLogin:Boolean;

        public function SocketManager()
        {
            this._socket = new ByteSocket();
            this._socket.addEventListener(Event.CONNECT, this.__socketConnected);
            this._socket.addEventListener(Event.CLOSE, this.__socketClose);
            this._socket.addEventListener(SocketEvent.DATA, this.__socketData);
            this._socket.addEventListener(ErrorEvent.ERROR, this.__socketError);
            this._out = new GameSocketOut(this._socket);
        }

        public static function get Instance():SocketManager
        {
            if (_instance == null)
            {
                _instance = new (SocketManager)();
            };
            return (_instance);
        }


        public function set isLogin(_arg_1:Boolean):void
        {
            this._isLogin = _arg_1;
        }

        public function get isLogin():Boolean
        {
            return (this._isLogin);
        }

        public function get socket():ByteSocket
        {
            return (this._socket);
        }

        public function get out():GameSocketOut
        {
            return (this._out);
        }

        public function connect(_arg_1:String, _arg_2:Number):void
        {
            this._socket.connect(_arg_1, _arg_2);
        }

        private function __socketConnected(_arg_1:Event):void
        {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONNECT_SUCCESS));
            this.out.sendDomainNameAndPort();
            this.out.sendLogin(PlayerManager.Instance.Account);
        }

        private function __socketClose(_arg_1:Event):void
        {
            LeavePageManager.forcedToLoginPath(LanguageMgr.GetTranslation("tank.manager.RoomManager.break"));
        }

        private function __socketError(_arg_1:ErrorEvent):void
        {
            this.errorAlert(LanguageMgr.GetTranslation("tank.manager.RoomManager.false"));
            CheckCodeFrame.Instance.close();
        }

        private function __systemAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.addEventListener(FrameEvent.RESPONSE, this.__systemAlertResponse);
            _local_2.dispose();
            if (_local_2.parent)
            {
                _local_2.parent.removeChild(_local_2);
            };
        }

        private function __socketData(event:SocketEvent):void
        {
            var pkg:PackageIn;
            var type:int;
            var msg:String;
            var systemAlert:BaseAlerFrame;
            try
            {
                pkg = event.data;
                switch (pkg.code)
                {
                    case ePackageType.RSAKEY:
                        break;
                    case ePackageType.SYS_MESSAGE:
                        type = pkg.readInt();
                        msg = pkg.readUTF();
                        if (msg.substr(0, 5) == "撮合成功!")
                        {
                            StateManager.getInGame_Step_2 = true;
                        };
                        switch (type)
                        {
                            case 0:
                                MessageTipManager.getInstance().show(msg, 0, true);
                                ChatManager.Instance.sysChatYellow(msg);
                                break;
                            case 1:
                                MessageTipManager.getInstance().show(msg, 0, true);
                                ChatManager.Instance.sysChatRed(msg);
                                break;
                            case 2:
                                ChatManager.Instance.sysChatYellow(msg);
                                break;
                            case 3:
                                ChatManager.Instance.sysChatRed(msg);
                                break;
                            case 4:
                                systemAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), msg, LanguageMgr.GetTranslation("ok"), "", false, true, true, LayerManager.ALPHA_BLOCKGOUND);
                                systemAlert.addEventListener(FrameEvent.RESPONSE, this.__systemAlertResponse);
                                break;
                            case 5:
                                ChatManager.Instance.sysChatYellow(msg);
                                break;
                            case 6:
                                ChatManager.Instance.sysChatLinkYellow(msg);
                                break;
                            case 7:
                                PetBagManager.instance().pushMsg(msg);
                                break;
                        };
                        break;
                    case ePackageType.DAILY_AWARD:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILY_AWARD, pkg));
                        break;
                    case ePackageType.LOGIN:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOGIN, pkg));
                        break;
                    case ePackageType.KIT_USER:
                        this.kitUser(pkg.readUTF());
                        break;
                    case ePackageType.UPDATE_PLAYER_PROPERTY:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PLAYER_PROPERTY, pkg));
                        break;
                    case ePackageType.PING:
                        this.out.sendPint();
                        break;
                    case ePackageType.EDITION_ERROR:
                        this.cleanLocalFile(pkg.readUTF());
                        break;
                    case ePackageType.BAG_LOCKED:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BAG_LOCKED, pkg));
                        break;
                    case ePackageType.OPEN_BAGCELL:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OPEN_BAG_CELL, pkg));
                        break;
                    case ePackageType.SCENE_ADD_USER:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_ADD_USER, pkg));
                        break;
                    case ePackageType.SCENE_REMOVE_USER:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_REMOVE_USER, pkg));
                        break;
                    case ePackageType.GAME_ROOM:
                        this.createGameRoomEvent(pkg);
                        break;
                    case ePackageType.GAME_CMD:
                        this.createGameEvent(pkg);
                        break;
                    case ePackageType.SCENE_CHANNEL_CHANGE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_CHANNEL_CHANGE, pkg));
                        break;
                    case ePackageType.LEAGUE_START_NOTICE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.POPUP_LEAGUESTART_NOTICE, pkg));
                        break;
                    case ePackageType.GAME_MISSION_START:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_START, pkg));
                        break;
                    case ePackageType.SCENE_CHAT:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_CHAT, pkg));
                        break;
                    case ePackageType.SCENE_FACE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_FACE, pkg));
                        break;
                    case ePackageType.DELETE_GOODS:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DELETE_GOODS, pkg));
                        break;
                    case ePackageType.BUY_GOODS:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_GOODS, pkg));
                        break;
                    case ePackageType.CHANGE_PLACE_GOODS:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_GOODS_PLACE, pkg));
                        break;
                    case ePackageType.CHAIN_EQUIP:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAIN_EQUIP, pkg));
                        break;
                    case ePackageType.UNCHAIN_EQUIP:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UNCHAIN_EQUIP, pkg));
                        break;
                    case ePackageType.SEND_MAIL:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEND_EMAIL, pkg));
                        break;
                    case ePackageType.DELETE_MAIL:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DELETE_MAIL, pkg));
                        break;
                    case ePackageType.GET_MAIL_ATTACHMENT:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_MAIL_ATTACHMENT, pkg));
                        break;
                    case ePackageType.MAIL_CANCEL:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAIL_CANCEL, pkg));
                        break;
                    case ePackageType.SEll_GOODS:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SELL_GOODS, pkg));
                        break;
                    case ePackageType.UPDATE_COUPONS:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_COUPONS, pkg));
                        break;
                    case ePackageType.ITEM_STORE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_STORE, pkg));
                        break;
                    case ePackageType.UPDATE_PRIVATE_INFO:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO, pkg));
                        break;
                    case ePackageType.UPDATE_PLAYER_INFO:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PLAYER_INFO, pkg));
                        break;
                    case ePackageType.GRID_PROP:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GRID_PROP, pkg));
                        break;
                    case ePackageType.EQUIP_CHANGE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EQUIP_CHANGE, pkg));
                        break;
                    case ePackageType.GRID_GOODS:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GRID_GOODS, pkg));
                        break;
                    case ePackageType.NETWORK:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.NETWORK, pkg));
                        break;
                    case ePackageType.GAME_TAKE_TEMP:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_TEMP, pkg));
                        break;
                    case ePackageType.SCENE_USERS_LIST:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_USERS_LIST, pkg));
                        break;
                    case ePackageType.GAME_INVITE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_INVITE, pkg));
                        break;
                    case ePackageType.S_BUGLE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.S_BUGLE, pkg));
                        break;
                    case ePackageType.B_BUGLE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.B_BUGLE, pkg));
                        break;
                    case ePackageType.C_BUGLE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.C_BUGLE, pkg));
                        break;
                    case ePackageType.DEFY_AFFICHE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DEFY_AFFICHE, pkg));
                        break;
                    case ePackageType.CHAT_PERSONAL:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAT_PERSONAL, pkg));
                        break;
                    case ePackageType.ITEM_STRENGTHEN:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_STRENGTH, pkg));
                        break;
                    case ePackageType.ITEM_TRANSFER:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_TRANSFER, pkg));
                        break;
                    case ePackageType.ITEM_REFINERY_PREVIEW:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_REFINERY_PREVIEW, pkg));
                        break;
                    case ePackageType.ITEM_REFINERY:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_REFINERY, pkg));
                        break;
                    case ePackageType.OPEN_FIVE_SIX_HOLE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OPEN_FIVE_SIX_HOLE_EMEBED, pkg));
                        break;
                    case ePackageType.QUEST_UPDATE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_UPDATE, pkg));
                        break;
                    case ePackageType.QUSET_OBTAIN:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_OBTAIN, pkg));
                        break;
                    case ePackageType.QUEST_CHECK:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_CHECK, pkg));
                        break;
                    case ePackageType.QUEST_FINISH:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_FINISH, pkg));
                        break;
                    case ePackageType.ITEM_OBTAIN:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_OBTAIN, pkg));
                        break;
                    case ePackageType.ITEM_CONTINUE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_CONTINUE, pkg));
                        break;
                    case ePackageType.SYS_DATE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYS_DATE, pkg));
                        break;
                    case ePackageType.ITEM_EQUIP:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_EQUIP, pkg));
                        break;
                    case ePackageType.MATE_ONLINE_TIME:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MATE_ONLINE_TIME, pkg));
                        break;
                    case ePackageType.SYS_NOTICE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYS_NOTICE, pkg));
                        break;
                    case ePackageType.MAIL_RESPONSE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAIL_RESPONSE, pkg));
                        break;
                    case ePackageType.AUCTION_REFRESH:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AUCTION_REFRESH, pkg));
                        break;
                    case ePackageType.CHECK_CODE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHECK_CODE, pkg));
                        break;
                    case ePackageType.QUEST_ONEKEYFINISH:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_ONEKEYFINISH, pkg));
                        break;
                    case ePackageType.IM_CMD:
                        this.createIMEvent(pkg);
                        break;
                    case ePackageType.CONSORTIA_CMD:
                        this.createConsortiaEvent(pkg);
                        break;
                    case ePackageType.CONSORTIA_RESPONSE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RESPONSE, pkg));
                        break;
                    case ePackageType.CONSORTIA_MAIL_MESSAGE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_MAIL_MESSAGE, pkg));
                        break;
                    case ePackageType.CID_CHECK:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CID_CHECK, pkg));
                        break;
                    case ePackageType.ENTHRALL_LIGHT:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTHRALL_LIGHT, pkg));
                        break;
                    case ePackageType.BUFF_OBTAIN:
                        if (pkg.clientId == PlayerManager.Instance.Self.ID)
                        {
                            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_OBTAIN, pkg));
                        }
                        else
                        {
                            QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_OBTAIN, pkg));
                        };
                        break;
                    case ePackageType.BUFF_ADD:
                        if (pkg.clientId == PlayerManager.Instance.Self.ID)
                        {
                            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_ADD, pkg));
                        }
                        else
                        {
                            QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_ADD, pkg));
                        };
                        break;
                    case ePackageType.BUFF_UPDATE:
                        if (pkg.clientId == PlayerManager.Instance.Self.ID)
                        {
                            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_UPDATE, pkg));
                        }
                        else
                        {
                            QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_UPDATE, pkg));
                        };
                        break;
                    case ePackageType.USE_COLOR_CARD:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_COLOR_CARD, pkg));
                        break;
                    case ePackageType.AUCTION_UPDATE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AUCTION_UPDATE, pkg));
                        break;
                    case ePackageType.GOODS_PRESENT:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOODS_PRESENT, pkg));
                        break;
                    case ePackageType.GOODS_COUNT:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOODS_COUNT, pkg));
                        break;
                    case ePackageType.UPDATE_SHOP:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REALlTIMES_ITEMS_BY_DISCOUNT, pkg));
                        break;
                    case ePackageType.MARRYINFO_GET:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYINFO_GET, pkg));
                        break;
                    case ePackageType.MARRY_STATUS:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_STATUS, pkg));
                        break;
                    case ePackageType.MARRY_ROOM_CREATE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_CREATE, pkg));
                        break;
                    case ePackageType.MARRY_ROOM_LOGIN:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_LOGIN, pkg));
                        break;
                    case ePackageType.MARRY_SCENE_LOGIN:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_SCENE_LOGIN, pkg));
                        break;
                    case ePackageType.PLAYER_ENTER_MARRY_ROOM:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM, pkg));
                        break;
                    case ePackageType.PLAYER_EXIT_MARRY_ROOM:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM, pkg));
                        break;
                    case ePackageType.MARRY_APPLY:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_APPLY, pkg));
                        break;
                    case ePackageType.MARRY_APPLY_REPLY:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_APPLY_REPLY, pkg));
                        break;
                    case ePackageType.DIVORCE_APPLY:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DIVORCE_APPLY, pkg));
                        break;
                    case ePackageType.MARRY_ROOM_STATE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_STATE, pkg));
                        break;
                    case ePackageType.MARRY_ROOM_DISPOSE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE, pkg));
                        break;
                    case ePackageType.MARRY_ROOM_UPDATE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_UPDATE, pkg));
                        break;
                    case ePackageType.MARRYPROP_GET:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYPROP_GET, pkg));
                        break;
                    case ePackageType.MARRY_CMD:
                        this.createChurchEvent(pkg);
                        break;
                    case ePackageType.AMARRYINFO_REFRESH:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AMARRYINFO_REFRESH, pkg));
                        break;
                    case ePackageType.MARRYINFO_ADD:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYINFO_ADD, pkg));
                        break;
                    case ePackageType.LINKREQUEST_GOODS:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LINKGOODSINFO_GET, pkg));
                        break;
                    case CrazyTankPackageType.INSUFFICIENT_MONEY:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INSUFFICIENT_MONEY, pkg));
                        break;
                    case ePackageType.GET_ITEM_MESS:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_ITEM_MESS, pkg));
                        break;
                    case ePackageType.USER_ANSWER:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_ANSWER, pkg));
                        break;
                    case ePackageType.MARRY_SCENE_CHANGE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_SCENE_CHANGE, pkg));
                        break;
                    case ePackageType.HOTSPRING_CMD:
                        this.createHotSpringEvent(pkg);
                        break;
                    case ePackageType.HOTSPRING_ROOM_CREATE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_CREATE, pkg));
                        break;
                    case ePackageType.HOTSPRING_ROOM_ENTER:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER, pkg));
                        break;
                    case ePackageType.HOTSPRING_ROOM_ADD_OR_UPDATE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE, pkg));
                        break;
                    case ePackageType.HOTSPRING_ROOM_REMOVE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_REMOVE, pkg));
                        break;
                    case ePackageType.HOTSPRING_ROOM_LIST_GET:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_LIST_GET, pkg));
                        break;
                    case ePackageType.HOTSPRING_ROOM_PLAYER_ADD:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD, pkg));
                        break;
                    case ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE, pkg));
                        break;
                    case ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE, pkg));
                        break;
                    case ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER_CONFIRM, pkg));
                        break;
                    case ePackageType.GET_TIME_BOX:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_TIME_BOX, pkg));
                        break;
                    case ePackageType.UPDATE_TIME_BOX:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_TIME_BOX, pkg));
                    case ePackageType.ACHIEVEMENT_UPDATE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_UPDATE, pkg));
                        break;
                    case ePackageType.ACHIEVEMENT_FINISH:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_FINISH, pkg));
                        break;
                    case ePackageType.ACHIEVEMENT_INIT:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_INIT, pkg));
                        break;
                    case ePackageType.ACHIEVEMENTDATA_INIT:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENTDATA_INIT, pkg));
                        break;
                    case ePackageType.FIGHT_NPC:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_NPC, pkg));
                        break;
                    case ePackageType.LOTTERY_ALTERNATE_LIST:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_ALTERNATE_LIST, pkg));
                        break;
                    case ePackageType.LOTTERY_GET_ITEM:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_GET_ITEM, pkg));
                        break;
                    case ePackageType.CADDY_GET_AWARDS:
                        this.handleCaddyGetAwards(pkg);
                        break;
                    case ePackageType.CADDY_CONVERTED_ALL:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_CONVERTED, pkg));
                        break;
                    case ePackageType.CADDY_EXCHANGE_ALL:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_EXCHANGEALL, pkg));
                        break;
                    case ePackageType.CADDY_GET_BADLUCK:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_BADLUCK, pkg));
                        break;
                    case ePackageType.LOOKUP_EFFORT:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOOKUP_EFFORT, pkg));
                        break;
                    case ePackageType.LOTTERY_FINISH:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OFFERPACK_COMPLETE, pkg));
                        break;
                    case ePackageType.QQTIPS_GET_INFO:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QQTIPS_GET_INFO, pkg));
                        break;
                    case ePackageType.EDICTUM_GET_SERVION:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EDICTUM_GET_VERSION, pkg));
                        break;
                    case ePackageType.FEEDBACK_REPLY:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FEEDBACK_REPLY, pkg));
                        break;
                    case ePackageType.ANSWERBOX_QUESTIN:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ANSWERBOX_QUESTIN, pkg));
                        break;
                    case ePackageType.VIP_RENEWAL:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.VIP_IS_OPENED, pkg));
                        break;
                    case ePackageType.USE_CHANGE_COLOR_SHELL:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_COLOR_SHELL, pkg));
                        break;
                    case AcademyPackageType.ACADEMY_FATHER:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.APPRENTICE_SYSTEM_ANSWER, pkg));
                        break;
                    case ePackageType.ITEM_OPENUP:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_OPENUP, pkg));
                        break;
                    case ePackageType.GET_DYNAMIC:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_DYNAMIC, pkg));
                        break;
                    case ePackageType.WEEKLY_CLICK_CNT:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WEEKLY_CLICK_CNT, pkg));
                        break;
                    case ePackageType.LOAD_RESOURCE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD_RESOURCE, pkg));
                        break;
                    case ePackageType.CHAT_FILTERING_FRIENDS_SHARE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAT_FILTERING_FRIENDS_SHARE, pkg));
                        break;
                    case ePackageType.LOTTERY_OPEN_BOX:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_OPNE, pkg));
                        break;
                    case ePackageType.LITTLEGAME_COMMAND:
                        break;
                    case ePackageType.LITTLEGAME_ACTIVED:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LITTLEGAME_ACTIVED, pkg));
                        break;
                    case ePackageType.USER_LUCKYNUM:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_LUCKYNUM, pkg));
                        break;
                    case ePackageType.LEFT_GUN_ROULETTE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LEFT_GUN_ROULETTE, pkg));
                        break;
                    case ePackageType.LEFT_GUN_ROULETTE_START:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LEFT_GUN_ROULETTE_START, pkg));
                        break;
                    case ePackageType.OPTION_CHANGE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OPTION_CHANGE, pkg));
                        break;
                    case ePackageType.PET:
                        this.handlePetPkg(pkg);
                        break;
                    case ePackageType.FARM:
                        this.handFarmPkg(pkg);
                        break;
                    case ePackageType.USE_CHANGE_SEX:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_SEX, pkg));
                        break;
                    case ePackageType.WORLDBOSS_CMD:
                        this.createWorldBossEvent(pkg);
                        break;
                    case ePackageType.RELOAD_XML:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.RELOAD_XML, pkg));
                        break;
                    case ePackageType.SAVE_POINT:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SAVE_POINTS, pkg));
                        break;
                    case ePackageType.WALKSENCE_CMD:
                        this.createWalkSceneEvent(pkg);
                        break;
                    case ePackageType.EQUIP_SYSTEM:
                        this.createEquipSystem(pkg);
                        break;
                    case ePackageType.SHOW_DIALOG:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_DIALOG, pkg));
                        break;
                    case ePackageType.DROP_MOVIE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DROP_GOODS, pkg));
                        break;
                    case ePackageType.FIGHTING_VIP:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_TOOL_BOX, pkg));
                        break;
                    case ePackageType.FATIGUE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FATIGUE, pkg));
                        break;
                    case ePackageType.BEAD_REQUEST_BEAD_RETURN:
                        this.beadReturnEvent(pkg);
                        break;
                    case ePackageType.BEAD_COMBINE_ONEKEY_RETURN:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BEAD_COMBINE_ONEKEY_TIP, pkg));
                        break;
                    case ePackageType.BUY_FATIGUE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_FATIGUE, pkg));
                        break;
                    case ePackageType.ONLINE_REWADS:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ONLINE_REWADS, pkg));
                        break;
                    case ePackageType.TOTEM_CMD:
                        this.totemFunEvent(pkg);
                        break;
                    case ePackageType.EXPEDITION:
                        this.creatExpeditonType(pkg);
                        break;
                    case ePackageType.MINING_DUNGEON:
                        this.mingingEvent(pkg);
                        break;
                    case ePackageType.ACTIVE_LOG:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTIVE_lOG, pkg));
                        break;
                    case ePackageType.GOODS_EXCHANGE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTIVE_EXCHANGE, pkg));
                        break;
                    case ePackageType.DAILY_QUEST:
                        this.createDailyQuestEvent(pkg);
                        break;
                    case ePackageType.ARENA:
                        ArenaManager.instance.dealPackage(pkg);
                        break;
                    case ePackageType.RANK_SHOP:
                        MilitaryRankManager.Instance.setRankShopRecord(pkg);
                        break;
                    case ePackageType.CLOSE_FRIEND_REWARD:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CLOSE_FRIEND_REWARD, pkg));
                        break;
                    case ePackageType.CLOSE_FRIEND_CHANGE:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CLOSE_FRIEND_CHANGE, pkg));
                        break;
                    case ePackageType.CLOSE_FRIEND_ADD:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CLOSE_FRIEND_ADD, pkg));
                        break;
                    case ePackageType.PF_INFO:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PFINFO, pkg));
                        break;
                    case ePackageType.RANDOM_BOX:
                        this.creatRandomBox(pkg);
                        break;
                    case ePackageType.ENERGY_RETURN:
                        dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENERGY_RETURN, pkg));
                    case ePackageType.SHADOW_NPC:
                        this.handleShadowNPC(pkg);
                };
            }
            catch(err:Error)
            {
                SocketManager.Instance.out.sendErrorMsg(((err.message + "\r\n") + err.getStackTrace()));
            };
        }

        private function handleShadowNPC(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            switch (_local_2)
            {
                case FightRobotPackageType.OPEN_FRAME:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHTROBOT_OPEN_FRAME, _arg_1));
                    return;
                case FightRobotPackageType.CHANGE_PLAYER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHTROBOT_CHANGE_PLAYER, _arg_1));
                    return;
                case FightRobotPackageType.HISTORY_MESSAGE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHTROBOT_HISTORY_MESSAGE, _arg_1));
                    return;
                case FightRobotPackageType.CLEAR_CD:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHTROBOT_CLEAR_CD, _arg_1));
                    return;
            };
        }

        private function creatRandomBox(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            switch (_local_2)
            {
                case TurnPlatePackageType.LOTTERY_START:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_START, _arg_1));
                    return;
                case TurnPlatePackageType.LOTTERY_RANDOM:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_RANDOM, _arg_1));
                    return;
                case TurnPlatePackageType.LOTTERY_FINISH:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_FINISH, _arg_1));
                    return;
                case TurnPlatePackageType.LOTTERY_STATE:
                    TurnPlateController.Instance.openStatus(_arg_1);
                    return;
            };
        }

        private function handleCaddyGetAwards(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readInt();
            switch (_local_2)
            {
                case TurnPlateController.TURNPLATE_HISTORY:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TURNPLATE_HISTORY_MESSAGE, _arg_1));
                    return;
            };
        }

        private function creatExpeditonType(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            switch (_local_2)
            {
                case ExpeditionType.START_EXPEDITION:
                    dispatchEvent(new ExpeditionEvents(CrazyTankSocketEvent.EXPEDITION, ExpeditionEvents.START, _arg_1));
                    return;
                case ExpeditionType.STOP_EXPEDITION:
                    dispatchEvent(new ExpeditionEvents(CrazyTankSocketEvent.EXPEDITION, ExpeditionEvents.STOP, _arg_1));
                    return;
                case ExpeditionType.UPDATE_EXPEDITION:
                    dispatchEvent(new ExpeditionEvents(CrazyTankSocketEvent.EXPEDITION, ExpeditionEvents.UPDATE, _arg_1));
                    return;
            };
        }

        private function mingingEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            switch (_local_2)
            {
                case MiningPackageType.CD_COOLING_TIME:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CD_COOLING_TIME, _arg_1));
                    return;
                case MiningPackageType.FREE_ENTER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FREE_ENTER, _arg_1));
                    return;
                case MiningPackageType.MONEY_ENTER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MONEY_ENTER, _arg_1));
                    return;
            };
        }

        private function createEquipSystem(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            var _local_3:CrazyTankSocketEvent;
            switch (_local_2)
            {
                case EquipSystemPackageType.COMPOSE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_COMPOSE, _arg_1));
                    return;
                case EquipSystemPackageType.SPLITE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_SPLITE, _arg_1));
                    return;
                case EquipSystemPackageType.GET_COMPOSE_SKILL:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_COMPOSE_SKILL, _arg_1));
                    return;
                case EquipSystemPackageType.HOLE_EQUIP:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOLE_EQUIP, _arg_1));
                    return;
                case EquipSystemPackageType.MOSAIC_EQUIP:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MOSAIC_EQUIP, _arg_1));
                    return;
                case EquipSystemPackageType.REFINING:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REFINING, _arg_1));
                    return;
            };
        }

        private function handFarmPkg(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            var _local_3:CrazyTankSocketEvent;
            switch (_local_2)
            {
                case FarmPackageType.REFRASH_FARM:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REFRASH_FARM, _arg_1));
                    return;
                case FarmPackageType.SEEDING:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEEDING, _arg_1));
                    return;
                case FarmPackageType.GAIN_FIELD:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAIN_FIELD, _arg_1));
                    return;
                case FarmPackageType.ACCELERATE_FIELD:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACCELERATE_FIELD, _arg_1));
                    return;
                case FarmPackageType.UPROOT_FIELD:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPROOT_FIELD, _arg_1));
                    return;
            };
        }

        private function kitUser(_arg_1:String):void
        {
            this._socket.close();
            if (_arg_1.indexOf(LanguageMgr.GetTranslation("tank.manager.SocketManager.copyRight")) != -1)
            {
                LoaderSavingManager.clearFiles("*.png");
            };
            LeavePageManager.forcedToLoginPath(_arg_1);
        }

        private function errorAlert(_arg_1:String):void
        {
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), _arg_1, "", "", true, false, false, LayerManager.BLCAK_BLOCKGOUND);
            _local_2.addEventListener(FrameEvent.RESPONSE, this.__onAlertClose);
            _local_2.moveEnable = false;
        }

        private function __onAlertClose(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__onAlertClose);
            if (((ExternalInterface.available) && (PathManager.solveAllowPopupFavorite())))
            {
                if (((ExternalInterface.available) && (PathManager.solveAllowPopupFavorite())))
                {
                    if (PlayerManager.Instance.Self.IsFirst <= 1)
                    {
                        ExternalInterface.call("setFavorite", PathManager.solveLogin(), StatisticManager.siteName, "3");
                    }
                    else
                    {
                        ExternalInterface.call("setFavorite", PathManager.solveLogin(), StatisticManager.siteName, "1");
                    };
                };
            };
            LeavePageManager.leaveToLoginPath();
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        private function cleanLocalFile(_arg_1:String):void
        {
            this._socket.close();
            LoaderSavingManager.clearFiles("*.png");
            this.errorAlert(_arg_1);
        }

        private function createIMEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readUnsignedByte();
            var _local_3:CrazyTankSocketEvent;
            switch (_local_2)
            {
                case IMPackageType.FRIEND_ADD:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_ADD, _arg_1));
                    break;
                case IMPackageType.FRIEND_REMOVE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_REMOVE, _arg_1));
                    break;
                case IMPackageType.FRIEND_UPDATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_UPDATE, _arg_1));
                    break;
                case IMPackageType.FRIEND_STATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_STATE, _arg_1));
                    break;
                case IMPackageType.FRIEND_RESPONSE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_RESPONSE, _arg_1));
                    break;
                case IMPackageType.ONS_EQUIP:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ONS_EQUIP, _arg_1));
                    break;
                case IMPackageType.SAME_CITY_FRIEND:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SAME_CITY_FRIEND, _arg_1));
                    break;
                case IMPackageType.ADD_CUSTOM_FRIENDS:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_CUSTOM_FRIENDS, _arg_1));
                    break;
                case IMPackageType.ONE_ON_ONE_TALK:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ONE_ON_ONE_TALK, _arg_1));
                    break;
            };
            if (_local_3)
            {
                dispatchEvent(_local_3);
            };
        }

        private function createChurchEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            var _local_3:CrazyTankSocketEvent;
            switch (_local_2)
            {
                case ChurchPackageType.MOVE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.MOVE, _arg_1);
                    break;
                case ChurchPackageType.HYMENEAL:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.HYMENEAL, _arg_1);
                    break;
                case ChurchPackageType.CONTINUATION:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTINUATION, _arg_1);
                    break;
                case ChurchPackageType.INVITE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.INVITE, _arg_1);
                    break;
                case ChurchPackageType.USEFIRECRACKERS:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.USEFIRECRACKERS, _arg_1);
                    break;
                case ChurchPackageType.HYMENEAL_STOP:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.HYMENEAL_STOP, _arg_1);
                    break;
                case ChurchPackageType.GUNSALUTE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUNSALUTE, _arg_1);
                    break;
                case ChurchPackageType.MARRYROOMSENDGIFT:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYROOMSENDGIFT, _arg_1);
                    break;
            };
            if (_local_3)
            {
                dispatchEvent(_local_3);
            };
        }

        private function createDailyQuestEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readInt();
            var _local_3:CrazyTankSocketEvent;
            switch (_local_2)
            {
                case DailyQuestPackageType.UPDATE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILY_QUEST_UPDATE, _arg_1);
                    break;
                case DailyQuestPackageType.REWARD:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILY_QUEST_REWARD, _arg_1);
                    break;
                case DailyQuestPackageType.ONE_KEY:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILY_QUEST_ONE_KEY, _arg_1);
                    break;
                case DailyQuestPackageType.RANDOM_PVE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.RANDOM_PVE, _arg_1);
                    break;
                case DailyQuestPackageType.RANDOM_SCENE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.RANDOM_SCENE, _arg_1);
                    break;
            };
            if (_local_3)
            {
                dispatchEvent(_local_3);
            };
        }

        private function createHotSpringEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            var _local_3:CrazyTankSocketEvent;
            switch (_local_2)
            {
                case HotSpringPackageType.TARGET_POINT:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT, _arg_1);
                    break;
                case HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_RENEWAL_FEE, _arg_1));
                    break;
                case HotSpringPackageType.HOTSPRING_ROOM_INVITE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_INVITE, _arg_1);
                    break;
                case HotSpringPackageType.HOTSPRING_ROOM_TIME_UPDATE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_TIME_UPDATE, _arg_1);
                    break;
                case HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_CONTINUE, _arg_1);
                    break;
            };
            if (_local_3)
            {
                dispatchEvent(_local_3);
            };
        }

        private function createConsortiaEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readUnsignedByte();
            var _local_3:CrazyTankSocketEvent;
            switch (_local_2)
            {
                case ConsortiaPackageType.CONSORTIA_TRYIN:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_CREATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CREATE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_DISBAND:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DISBAND, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_RENEGADE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RENEGADE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_TRYIN_PASS:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN_PASS, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_TRYIN_DEL:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN_DEL, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_RICHES_OFFER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_APPLY_STATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_DUTY_DELETE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DUTY_DELETE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_DUTY_UPDATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DUTY_UPDATE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_INVITE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_INVITE_PASS:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE_PASS, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_INVITE_DELETE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE_DELETE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DESCRIPTION_UPDATE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_PLACARD_UPDATE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BANCHAT_UPDATE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_USER_REMARK_UPDATE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_USER_GRADE_UPDATE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CHAIRMAN_CHAHGE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_CHAT:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CHAT, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_LEVEL_UP:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_LEVEL_UP, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_HALL_UP:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_HALL_UP, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_SHOP_UP:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_SHOP_UP, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_SKILL_UP:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_SKILL_UP, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_TASK_RELEASE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL, _arg_1));
                    return;
                case ConsortiaPackageType.POLL_CANDIDATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.POLL_CANDIDATE, _arg_1));
                    return;
                case ConsortiaPackageType.SKILL_SOCKET:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SKILL_SOCKET, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTION_MAIL:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTION_MAIL, _arg_1));
                    return;
                case ConsortiaPackageType.BUY_BADGE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_BADGE, _arg_1));
                    return;
                case ConsortiaPackageType.PUBLISH_TASK:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PUBLISH_TASK, _arg_1));
                    return;
                case ConsortiaPackageType.ENTER_CONSORTION:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTER_CONSORTION, _arg_1));
                    return;
                case ConsortiaPackageType.EXIT_CONSORTION:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EXIT_CONSORTION, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIONSENCE_MOVEPLAYER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIONSENCE_MOVEPLAYER, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIONSENCE_ADDPLAYER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIONSENCE_ADDPLAYER, _arg_1));
                    return;
                case ConsortiaPackageType.ENTER_TRNSPORT:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTER_TRNSPORT, _arg_1));
                    return;
                case ConsortiaPackageType.UPDATE_MEMBER_INFO:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_MEMBER_INFO, _arg_1));
                    return;
                case ConsortiaPackageType.GEGIN_CONVOY:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GEGIN_CONVOY, _arg_1));
                    return;
                case ConsortiaPackageType.UPDATE_CAR_INFO:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_CAR_INFO, _arg_1));
                    return;
                case ConsortiaPackageType.BUY_CAR:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_CAR, _arg_1));
                    return;
                case ConsortiaPackageType.INVITE_CONVOY:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INVITE_CONVOY, _arg_1));
                    return;
                case ConsortiaPackageType.CONVOY_INVITE_ANSWER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONVOY_INVITE_ANSWER, _arg_1));
                    return;
                case ConsortiaPackageType.CANCLE_CONVOY_INVITE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CANCLE_CONVOY_INVITE, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTIA_UPDATE_QUEST:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_UPDATE_QUEST, _arg_1));
                    return;
                case ConsortiaPackageType.REQUEST_CONSORTIA_QUEST:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REQUEST_CONSORTIA_QUEST, _arg_1));
                    return;
                case ConsortiaPackageType.CAR_RECEIVE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CAR_RECEIVE, _arg_1));
                    return;
                case ConsortiaPackageType.HIJACK_CAR:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HIJACK_CAR, _arg_1));
                    return;
                case ConsortiaPackageType.HIJACK_ANSWER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HIJACK_ANSWER, _arg_1));
                    return;
                case ConsortiaPackageType.HIJACK_INFO_MESSAGE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HIJACK_INFO_MESSAGE, _arg_1));
                    return;
                case ConsortiaPackageType.SYNC_CONSORTION_RICH:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYNC_CONSORTION_RICH, _arg_1));
                    return;
                case ConsortiaPackageType.SHOP_REFRESH_GOOD:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOP_REFRESH_GOOD, _arg_1));
                    return;
                case ConsortiaPackageType.CONSORTION_STATUS:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTION_STATUS, _arg_1));
                    return;
                case ConsortiaPackageType.UPDATE_EXPERIENCE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_EXPERIENCE, _arg_1));
                    return;
                case ConsortiaMonsterPackageTypes.ADD_MONSTER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTION_ADDMONSTER, _arg_1));
                    return;
                case ConsortiaMonsterPackageTypes.REMOVE_ALL_MONSTER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTION_REMOVEALLMONSTER, _arg_1));
                    return;
                case ConsortiaMonsterPackageTypes.MONSTER_STATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTION_MONSTER_STATE, _arg_1));
                    return;
                case ConsortiaMonsterPackageTypes.FIGHT_MONSTER:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_MONSTER, _arg_1));
                    return;
                case ConsortiaMonsterPackageTypes.ACTIVE_STATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTIVE_STATE, _arg_1));
                    return;
                case ConsortiaMonsterPackageTypes.MONSTER_RANK:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MONSTER_RANK_INFO, _arg_1));
                    return;
                case ConsortiaMonsterPackageTypes.SELF_MONSTER_INFO:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SELF_MONSTER_INFO, _arg_1));
                    return;
            };
        }

        private function createGameRoomEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readUnsignedByte();
            var _local_3:CrazyTankSocketEvent;
            switch (_local_2)
            {
                case GameRoomPackageType.GAME_ROOM_CREATE:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_CREATE, _arg_1));
                    return;
                case GameRoomPackageType.GAME_ROOM_LOGIN:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_LOGIN, _arg_1));
                    return;
                case GameRoomPackageType.GAME_ROOM_SETUP_CHANGE:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, _arg_1));
                    return;
                case GameRoomPackageType.GAME_ROOM_KICK:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_KICK, _arg_1));
                    return;
                case GameRoomPackageType.GAME_ROOM_ADDPLAYER:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_ENTER, _arg_1));
                    return;
                case GameRoomPackageType.GAME_TEAM:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TEAM, _arg_1));
                    return;
                case GameRoomPackageType.GAME_ROOM_UPDATE_PLACE:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_UPDATE_PLACE, _arg_1));
                    return;
                case GameRoomPackageType.GAME_PICKUP_CANCEL:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_AWIT_CANCEL, _arg_1));
                    return;
                case GameRoomPackageType.GAME_PICKUP_STYLE:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GMAE_STYLE_RECV, _arg_1));
                    return;
                case GameRoomPackageType.GAME_PICKUP_WAIT:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WAIT_RECV, _arg_1));
                    return;
                case GameRoomPackageType.ROOM_PASS:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ROOMLIST_PASS, _arg_1));
                    return;
                case GameRoomPackageType.GAME_PLAYER_STATE_CHANGE:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_STATE_CHANGE, _arg_1));
                    return;
                case GameRoomPackageType.ROOMLIST_UPDATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE, _arg_1));
                    return;
                case GameRoomPackageType.GAME_ROOM_REMOVEPLAYER:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_EXIT, _arg_1));
                    return;
                case GameRoomPackageType.GAME_ROOM_FULL:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_FULL));
                    return;
            };
        }

        private function createGameEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readUnsignedByte();
            var _local_3:CrazyTankSocketEvent;
            switch (_local_2)
            {
                case CrazyTankPackageType.GEM_GLOW:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.GEM_GLOW, _arg_1);
                    break;
                case CrazyTankPackageType.SEND_PICTURE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BUFF, _arg_1);
                    break;
                case CrazyTankPackageType.GAME_MISSION_PREPARE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_PREPARE, _arg_1);
                    break;
                case CrazyTankPackageType.UPDATE_BOARD_STATE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BOARD_STATE, _arg_1);
                    break;
                case CrazyTankPackageType.ADD_MAP_THING:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THING, _arg_1);
                    break;
                case CrazyTankPackageType.BARRIER_INFO:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.BARRIER_INFO, _arg_1);
                    break;
                case CrazyTankPackageType.GAME_CREATE:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_CREATE, _arg_1));
                    break;
                case CrazyTankPackageType.START_GAME:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_START, _arg_1));
                    break;
                case CrazyTankPackageType.WANNA_LEADER:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WANNA_LEADER, _arg_1);
                    break;
                case CrazyTankPackageType.GAME_LOAD:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_LOAD, _arg_1));
                    break;
                case CrazyTankPackageType.GAME_MISSION_INFO:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_INFO, _arg_1));
                    break;
                case CrazyTankPackageType.GAME_OVER:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_OVER, _arg_1));
                    break;
                case CrazyTankPackageType.MISSION_OVE:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.MISSION_OVE, _arg_1));
                    break;
                case CrazyTankPackageType.GAME_ALL_MISSION_OVER:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER, _arg_1));
                    break;
                case CrazyTankPackageType.DIRECTION:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.DIRECTION_CHANGED, _arg_1);
                    break;
                case CrazyTankPackageType.GUN_ROTATION:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_GUN_ANGLE, _arg_1);
                    break;
                case CrazyTankPackageType.FIRE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT, _arg_1);
                    break;
                case CrazyTankPackageType.READYTOFIRE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ALL_SHOOT, _arg_1);
                    break;
                case CrazyTankPackageType.SYNC_LIFETIME:
                    QueueManager.setLifeTime(_arg_1.readInt());
                    break;
                case CrazyTankPackageType.MOVESTART:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_START_MOVE, _arg_1);
                    break;
                case CrazyTankPackageType.MOVESTOP:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STOP_MOVE, _arg_1);
                    break;
                case CrazyTankPackageType.TURN:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_CHANGE, _arg_1);
                    break;
                case CrazyTankPackageType.HEALTH:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BLOOD, _arg_1);
                    break;
                case CrazyTankPackageType.FROST:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FROST, _arg_1);
                    break;
                case CrazyTankPackageType.NONOLE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_NONOLE, _arg_1);
                    break;
                case CrazyTankPackageType.CHANGE_STATE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_STATE, _arg_1);
                    break;
                case CrazyTankPackageType.PLAYER_PROPERTY:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROPERTY, _arg_1);
                    break;
                case CrazyTankPackageType.INVINCIBLY:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_INVINCIBLY, _arg_1);
                    break;
                case CrazyTankPackageType.VANE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_VANE, _arg_1);
                    break;
                case CrazyTankPackageType.HIDE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_HIDE, _arg_1);
                    break;
                case CrazyTankPackageType.CARRY:
                    break;
                case CrazyTankPackageType.BECKON:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BECKON, _arg_1);
                    break;
                case CrazyTankPackageType.FIGHTPROP:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FIGHT_PROP, _arg_1);
                    break;
                case CrazyTankPackageType.STUNT:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STUNT, _arg_1);
                    break;
                case CrazyTankPackageType.PROP:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROP, _arg_1);
                    break;
                case CrazyTankPackageType.DANDER:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_DANDER, _arg_1);
                    break;
                case CrazyTankPackageType.REDUCE_DANDER:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.REDUCE_DANDER, _arg_1);
                    break;
                case CrazyTankPackageType.LOAD:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD, _arg_1);
                    break;
                case CrazyTankPackageType.ADDATTACK:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDATTACK, _arg_1);
                    break;
                case CrazyTankPackageType.ADDBALL:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDBAL, _arg_1);
                    break;
                case CrazyTankPackageType.SHOOTSTRAIGHT:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOOTSTRAIGHT, _arg_1);
                    break;
                case CrazyTankPackageType.SUICIDE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.SUICIDE, _arg_1);
                    break;
                case CrazyTankPackageType.FIRE_TAG:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT_TAG, _arg_1);
                    break;
                case CrazyTankPackageType.CHANGE_BALL:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_BALL, _arg_1);
                    break;
                case CrazyTankPackageType.PICK:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PICK_BOX, _arg_1);
                    break;
                case CrazyTankPackageType.BLAST:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOMB_DIE, _arg_1);
                    break;
                case CrazyTankPackageType.BEAT:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BEAT, _arg_1);
                    break;
                case CrazyTankPackageType.DISAPPEAR:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOX_DISAPPEAR, _arg_1);
                    break;
                case CrazyTankPackageType.TAKE_CARD:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_OUT, _arg_1);
                    break;
                case CrazyTankPackageType.ADD_LIVING:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_LIVING, _arg_1);
                    break;
                case CrazyTankPackageType.PLAY_MOVIE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_MOVIE, _arg_1);
                    break;
                case CrazyTankPackageType.PLAY_SOUND:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_SOUND, _arg_1);
                    break;
                case CrazyTankPackageType.LOAD_RESOURCE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD_RESOURCE, _arg_1);
                    break;
                case CrazyTankPackageType.ADD_MAP_THINGS:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THINGS, _arg_1);
                    break;
                case CrazyTankPackageType.LIVING_BEAT:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BEAT, _arg_1);
                    break;
                case CrazyTankPackageType.LIVING_FALLING:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_FALLING, _arg_1);
                    break;
                case CrazyTankPackageType.LIVING_JUMP:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_JUMP, _arg_1);
                    break;
                case CrazyTankPackageType.LIVING_MOVETO:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_MOVETO, _arg_1);
                    break;
                case CrazyTankPackageType.LIVING_SAY:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SAY, _arg_1);
                    break;
                case CrazyTankPackageType.LIVING_RANGEATTACKING:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_RANGEATTACKING, _arg_1);
                    break;
                case CrazyTankPackageType.SHOW_CARDS:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_CARDS, _arg_1);
                    break;
                case CrazyTankPackageType.FOCUS_ON_OBJECT:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.FOCUS_ON_OBJECT, _arg_1);
                    break;
                case CrazyTankPackageType.GAME_MISSION_TRY_AGAIN:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN, _arg_1);
                    break;
                case CrazyTankPackageType.PLAY_INFO_IN_GAME:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_INFO_IN_GAME, _arg_1);
                    QueueManager.setLifeTime(_arg_1.extend2);
                    break;
                case CrazyTankPackageType.GAME_ROOM_INFO:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_INFO, _arg_1);
                    break;
                case CrazyTankPackageType.ADD_TIP_LAYER:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_TIP_LAYER, _arg_1);
                    break;
                case CrazyTankPackageType.PLAY_ASIDE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_ASIDE, _arg_1);
                    break;
                case CrazyTankPackageType.FORBID_DRAG:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.FORBID_DRAG, _arg_1);
                    break;
                case CrazyTankPackageType.TOP_LAYER:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.TOP_LAYER, _arg_1);
                    break;
                case CrazyTankPackageType.CONTROL_BGM:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTROL_BGM, _arg_1);
                    break;
                case CrazyTankPackageType.USE_DEPUTY_WEAPON:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_DEPUTY_WEAPON, _arg_1);
                    break;
                case CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_LIB_INFO_CHANGE, _arg_1);
                    break;
                case CrazyTankPackageType.POPUP_QUESTION_FRAME:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.POPUP_QUESTION_FRAME, _arg_1);
                    break;
                case CrazyTankPackageType.PASS_STORY:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_PASS_STORY_BTN, _arg_1);
                    break;
                case CrazyTankPackageType.LIVING_BOLTMOVE:
                    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BOLTMOVE, _arg_1));
                    break;
                case CrazyTankPackageType.CHANGE_TARGET:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_TARGET, _arg_1);
                    break;
                case CrazyTankPackageType.LIVING_SHOW_BLOOD:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SHOW_BLOOD, _arg_1);
                    break;
                case CrazyTankPackageType.LIVING_SHOW_NPC:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SHOW_NPC, _arg_1);
                    break;
                case CrazyTankPackageType.TEMP_STYLE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.TEMP_STYLE, _arg_1);
                    break;
                case CrazyTankPackageType.ACTION_MAPPING:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTION_MAPPING, _arg_1);
                    break;
                case CrazyTankPackageType.FIGHT_ACHIEVEMENT:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT, _arg_1);
                    break;
                case CrazyTankPackageType.APPLYSKILL:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.APPLYSKILL, _arg_1);
                    break;
                case CrazyTankPackageType.REMOVESKILL:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.REMOVESKILL, _arg_1);
                    break;
                case CrazyTankPackageType.MAXFORCE_CHANGED:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGEMAXFORCE, _arg_1);
                    break;
                case CrazyTankPackageType.WIND_PIC:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WINDPIC, _arg_1);
                    break;
                case CrazyTankPackageType.SYSMESSAGE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAMESYSMESSAGE, _arg_1);
                    break;
                case CrazyTankPackageType.LIVING_CHAGEANGLE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_CHAGEANGLE, _arg_1);
                    break;
                case CrazyTankPackageType.PET_SKILL:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_PET_SKILL, _arg_1);
                    break;
                case CrazyTankPackageType.PET_BUFF:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BUFF, _arg_1);
                    break;
                case CrazyTankPackageType.PET_BEAT:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BEAT, _arg_1);
                    break;
                case CrazyTankPackageType.PET_SKILL_CD:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_SKILL_CD, _arg_1);
                    break;
                case CrazyTankPackageType.WISHOFDD:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WISHOFDD, _arg_1);
                    break;
                case CrazyTankPackageType.BOSS_PLAYER_THING:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOSS_PLAYER_OBJECT, _arg_1);
                    break;
                case CrazyTankPackageType.FIGHT_KIT_SKILL:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_BOX_SKILL, _arg_1);
                    break;
                case CrazyTankPackageType.MISSION_ENERGY:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.MISSION_ENERGY, _arg_1);
                    break;
                case CrazyTankPackageType.PET_REDUCE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_REDUCE, _arg_1);
                    break;
                case CrazyTankPackageType.PLAYER_END_FIRE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_END_FIRE, _arg_1);
                    break;
            };
            if (_local_3)
            {
                QueueManager.addQueue(_local_3);
            };
        }

        private function handlePetPkg(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readUnsignedByte();
            switch (_local_2)
            {
                case PetPackageType.UPDATE_PET:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PET, _arg_1));
                    return;
                case PetPackageType.UPDATE_PET_SPACE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PET_SPACE, _arg_1));
                    return;
                case PetPackageType.PET_BLESS:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BLESS, _arg_1));
                    return;
            };
        }

        private function createWorldBossEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            var _local_3:CrazyTankSocketEvent;
            switch (_local_2)
            {
                case WorldBossPackageType.OPEN:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_INIT, _arg_1);
                    break;
                case WorldBossPackageType.OVER:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_OVER, _arg_1);
                    break;
                case WorldBossPackageType.CANENTER:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ENTER, _arg_1);
                    break;
                case WorldBossPackageType.ENTER:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ROOM, _arg_1);
                    break;
                case WorldBossPackageType.MOVE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_MOVE, _arg_1);
                    break;
                case WorldBossPackageType.WORLDBOSS_EXIT:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_EXIT, _arg_1);
                    break;
                case WorldBossPackageType.WORLDBOSS_PLAYERSTAUTSUPDATE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PLAYERSTAUTSUPDATE, _arg_1);
                    break;
                case WorldBossPackageType.WORLDBOSS_BLOOD_UPDATE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_BLOOD_UPDATE, _arg_1);
                    break;
                case WorldBossPackageType.WORLDBOSS_FIGHTOVER:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_FIGHTOVER, _arg_1);
                    break;
                case WorldBossPackageType.WORLDBOSS_ROOM_CLOSE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ROOMCLOSE, _arg_1);
                    break;
                case WorldBossPackageType.WORLDBOSS_PLAYER_REVIVE:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PLAYERREVIVE, _arg_1);
                    break;
                case WorldBossPackageType.WORLDBOSS_RANKING:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_RANKING, _arg_1);
                    break;
                case WorldBossPackageType.WORLDBOSS_BUYBUFF:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BUFF_LEVEL, _arg_1);
                    break;
                case WorldBossPackageType.WORLDBOSS_PRIVATE_INFO:
                    _local_3 = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PRIVATE_INFO, _arg_1);
                    break;
            };
            if (_local_3)
            {
                dispatchEvent(_local_3);
            };
        }

        private function createWalkSceneEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            switch (_local_2)
            {
                case WalkSencePackageType.ENTER_SENCE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WALKSCENE_PLAYER_ENTER, _arg_1));
                    return;
                case WalkSencePackageType.NEW_PLAYER_INFO:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WALKSCENE_PLAYER_INFO, _arg_1));
                    return;
                case WalkSencePackageType.PLAYER_MOVE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WALKSCENE_PLAYER_MOVE, _arg_1));
                    return;
                case WalkSencePackageType.PLAYER_EXIT:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WALKSCENE_PLAYER_EXIT, _arg_1));
                    return;
                case WalkSencePackageType.OBJECT_CLICK:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WALKSCENE_OBJECT_CLICK, _arg_1));
                    return;
                case WalkSencePackageType.SAVE_POINTS:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WALKSCENE_SAVE_POINTS, _arg_1));
                    return;
                case WalkSencePackageType.ADD_ROBOT:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WALKSCENE_ADD_ROBOT, _arg_1));
                    return;
                case WalkSencePackageType.REMOVE_CD:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WALKSCENE_REMOVE_CD, _arg_1));
                    return;
                case WalkSencePackageType.UPDATE_DUNGEONMODE_INFO:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SINGLEDUNGEON_MODE_UPDATE, _arg_1));
                    return;
            };
        }

        private function beadReturnEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readUnsignedByte();
            switch (_local_2)
            {
                case BeadPackageType.BEAD_STATE:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BEAD_RLIGHT_STATE, _arg_1));
                    return;
                case BeadPackageType.BEAD_DEVOUR:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BEAD_DEVOUR_PREVIEW, _arg_1));
                    return;
            };
        }

        private function totemFunEvent(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readUnsignedByte();
            switch (_local_2)
            {
                case TotemPackageType.TOTEM:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TOTEM, _arg_1));
                    return;
                case TotemPackageType.HONOR_UP_COUNT:
                    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HONOR_UP_COUNT, _arg_1));
                    return;
            };
        }


    }
}//package ddt.manager

