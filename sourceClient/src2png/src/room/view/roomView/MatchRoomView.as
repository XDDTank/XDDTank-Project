// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.roomView.MatchRoomView

package room.view.roomView
{
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import room.view.bigMapInfoPanel.MatchRoomBigMapInfoPanel;
    import room.view.smallMapInfoPanel.MatchRoomSmallMapInfoPanel;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.SelectedButton;
    import flash.utils.Timer;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import room.model.RoomInfo;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.events.RoomEvent;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.TaskManager;
    import ddt.events.TaskEvent;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.MessageTipManager;
    import room.RoomManager;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.view.chat.ChatData;
    import ddt.manager.GameInSocketOut;
    import ddt.view.chat.ChatInputView;
    import ddt.manager.ChatManager;
    import hall.FightPowerAndFatigue;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ClassUtils;
    import room.view.RoomPlayerItem;
    import flash.geom.Point;
    import room.model.RoomPlayer;
    import ddt.manager.PlayerManager;

    public class MatchRoomView extends BaseRoomView 
    {

        private static const MATCH_NPC:int = 40;
        private static const BOTH_MODE_ALERT_TIME:int = 60;
        private static const DISABLE_RETURN:int = 20;
        private static const MATCH_NPC_ENABLE:Boolean = false;

        private var _bg:Bitmap;
        private var _itemListBg:MovieClip;
        private var _bigMapInfoPanel:MatchRoomBigMapInfoPanel;
        private var _smallMapInfoPanel:MatchRoomSmallMapInfoPanel;
        private var _playerItemContainer:SimpleTileList;
        private var _crossZoneBtn:SelectedButton;
        private var _timerII:Timer = new Timer(1000);
        private var _alert1:BaseAlerFrame;
        private var _alert2:BaseAlerFrame;
        private var _ItemArr:Array;

        public function MatchRoomView(_arg_1:RoomInfo)
        {
            super(_arg_1);
        }

        override protected function initEvents():void
        {
            super.initEvents();
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_NPC, this.__onFightNpc);
            _info.addEventListener(RoomEvent.ALLOW_CROSS_CHANGE, this.__crossZoneChangeHandler);
            this._bigMapInfoPanel.addEventListener(RoomEvent.TWEENTY_SEC, this.__onTweentySec);
            this._crossZoneBtn.addEventListener(MouseEvent.CLICK, this.__crossZoneClick);
            this._timerII.addEventListener(TimerEvent.TIMER, this.__onTimer);
            addEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
        }

        override protected function removeEvents():void
        {
            super.removeEvents();
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_NPC, this.__onFightNpc);
            _info.removeEventListener(RoomEvent.ALLOW_CROSS_CHANGE, this.__crossZoneChangeHandler);
            this._bigMapInfoPanel.removeEventListener(RoomEvent.TWEENTY_SEC, this.__onTweentySec);
            this._crossZoneBtn.removeEventListener(MouseEvent.CLICK, this.__crossZoneClick);
            this._timerII.removeEventListener(TimerEvent.TIMER, this.__onTimer);
            removeEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
            if (this._alert1)
            {
                this._alert1.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            };
            if (this._alert2)
            {
                this._alert2.removeEventListener(FrameEvent.RESPONSE, this.__onResponseII);
            };
        }

        private function __loadWeakGuild(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
            TaskManager.instance.addEventListener(TaskEvent.ROOMLIST_REFLASH, this.showStart);
            this.showStart();
        }

        private function showStart(_arg_1:TaskEvent=null):void
        {
            if ((((((SavePointManager.Instance.isInSavePoint(14)) && (!(TaskManager.instance.isNewHandTaskCompleted(10)))) || ((SavePointManager.Instance.isInSavePoint(17)) && (!(TaskManager.instance.isNewHandTaskCompleted(13))))) || ((SavePointManager.Instance.isInSavePoint(18)) && (!(TaskManager.instance.isNewHandTaskCompleted(14))))) || ((SavePointManager.Instance.isInSavePoint(55)) && (!(TaskManager.instance.isNewHandTaskCompleted(27))))))
            {
                NewHandContainer.Instance.clearArrowByID(-1);
                NewHandContainer.Instance.showArrow(ArrowType.START_GAME, -45, "trainer.startGameArrowPos", "asset.trainer.startGameTipAsset", "trainer.startGameTipPos", this);
            };
            if ((((SavePointManager.Instance.isInSavePoint(15)) || (SavePointManager.Instance.isInSavePoint(19))) || (SavePointManager.Instance.isInSavePoint(26))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.EXIT_MATCHROOM, -45, "trainer.exitMatchRoomArrowPos", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            };
        }

        private function showWait():void
        {
            if (SavePointManager.Instance.isInSavePoint(14))
            {
                NewHandContainer.Instance.clearArrowByID(-1);
                NewHandContainer.Instance.showArrow(ArrowType.WAIT_GAME, -45, "trainer.startGameArrowPos", "asset.trainer.txtWait", "trainer.startGameTipPos", this);
            };
        }

        private function userGuideAlert(_arg_1:int, _arg_2:String):void
        {
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation(_arg_2), "", "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__responseTip);
            SocketManager.Instance.out.syncWeakStep(_arg_1);
        }

        private function __responseTip(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__responseTip);
            ObjectUtils.disposeObject(_local_2);
        }

        private function __crossZoneChangeHandler(_arg_1:RoomEvent):void
        {
            this._crossZoneBtn.selected = _info.isCrossZone;
            if (_info.isCrossZone)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView.cross.kuaqu"));
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView.cross.benqu"));
            };
        }

        private function __onTweentySec(_arg_1:RoomEvent):void
        {
            if (RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
                return;
            };
            _cancelBtn.enable = true;
        }

        private function __onTimer(_arg_1:TimerEvent):void
        {
            if ((((MATCH_NPC_ENABLE) && (this._timerII.currentCount == MATCH_NPC)) && (_info.selfRoomPlayer.isHost)))
            {
                this.showMatchNpc();
            };
            if ((((_info.gameMode == RoomInfo.GUILD_MODE) && (this._timerII.currentCount == BOTH_MODE_ALERT_TIME)) && (_info.selfRoomPlayer.isHost)))
            {
                this.showBothMode();
            };
        }

        private function showMatchNpc():void
        {
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _local_1.data = LanguageMgr.GetTranslation("tank.room.PickupPanel.ChangeStyle");
            this._alert1 = AlertManager.Instance.alert("SimpleAlert", _local_1, LayerManager.ALPHA_BLOCKGOUND);
            this._alert1.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            var _local_2:ChatData;
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                GameInSocketOut.sendGameStyle(2);
                _local_2 = new ChatData();
                _local_2.channel = ChatInputView.SYS_TIP;
                _local_2.msg = LanguageMgr.GetTranslation("tank.room.UpdateGameStyle");
                ChatManager.Instance.chat(_local_2);
            };
            this._alert1.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            this._alert1.dispose();
        }

        override protected function __startHandler(_arg_1:RoomEvent):void
        {
            super.__startHandler(_arg_1);
            NewHandContainer.Instance.clearArrowByID(ArrowType.START_GAME);
            NewHandContainer.Instance.clearArrowByID(ArrowType.EXIT_MATCHROOM);
            if (_info.started)
            {
                FightPowerAndFatigue.Instance.fightPowerBtnEnable = false;
                this._timerII.start();
                this.showWait();
            }
            else
            {
                FightPowerAndFatigue.Instance.fightPowerBtnEnable = true;
                this._timerII.stop();
                this._timerII.reset();
                this.showStart();
            };
        }

        private function showBothMode():void
        {
            this._alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.room.PickupPanel.ChangeStyle"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
            this._alert2.addEventListener(FrameEvent.RESPONSE, this.__onResponseII);
        }

        private function __onResponseII(_arg_1:FrameEvent):void
        {
            var _local_2:ChatData;
            SoundManager.instance.play("008");
            this._alert2.removeEventListener(FrameEvent.RESPONSE, this.__onResponseII);
            this._alert2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                GameInSocketOut.sendGameStyle(2);
                _local_2 = new ChatData();
                _local_2.channel = ChatInputView.SYS_TIP;
                _local_2.msg = LanguageMgr.GetTranslation("tank.room.UpdateGameStyle");
                ChatManager.Instance.chat(_local_2);
            };
        }

        private function __crossZoneClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            GameInSocketOut.sendGameRoomSetUp(_info.mapId, _info.type, false, _info.roomPass, _info.roomName, 3, 0, 0, (!(_info.isCrossZone)), 0);
            this._crossZoneBtn.selected = _info.isCrossZone;
        }

        private function __onFightNpc(_arg_1:CrazyTankSocketEvent):void
        {
            this.showMatchNpc();
        }

        override protected function updateButtons():void
        {
            super.updateButtons();
            this._crossZoneBtn.enable = ((_info.selfRoomPlayer.isHost) && (!(_info.started)));
            this._smallMapInfoPanel._actionStatus = ((_info.selfRoomPlayer.isHost) && (!(_info.started)));
        }

        override protected function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.background.room.rightBg");
            PositionUtils.setPos(this._bg, "asset.ddtmatchroom.bgPos");
            addChild(this._bg);
            this._itemListBg = (ClassUtils.CreatInstance("asset.ddtroom.playerItemlist.bg") as MovieClip);
            PositionUtils.setPos(this._itemListBg, "asset.ddtroom.playerItemlist.bgPos");
            this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddtroom.matchRoomBigMapInfoPanel");
            this._bigMapInfoPanel.info = _info;
            addChild(this._bigMapInfoPanel);
            this._crossZoneBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.crossZoneButton");
            this._crossZoneBtn.selected = _info.isCrossZone;
            this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddtroom.matchRoomSmallMapInfoPanel");
            this._smallMapInfoPanel.info = _info;
            this.updateItemPos();
            super.initView();
            addChild(this._smallMapInfoPanel);
        }

        private function updateItemPos():void
        {
            this._ItemArr = [ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos1"), ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos2"), ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos3")];
        }

        override protected function initTileList():void
        {
            var _local_3:int;
            var _local_4:RoomPlayerItem;
            super.initTileList();
            this._playerItemContainer = new SimpleTileList(2);
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.matchRoom.listSpace");
            this._playerItemContainer.hSpace = _local_1.x;
            this._playerItemContainer.vSpace = _local_1.y;
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerListPos");
            this._playerItemContainer.x = (this._bg.x + _local_2.x);
            this._playerItemContainer.y = (this._bg.y + _local_2.y);
            _local_3 = 0;
            while (_local_3 < 3)
            {
                _local_4 = new RoomPlayerItem(_local_3);
                _local_4.x = this._ItemArr[_local_3].x;
                _local_4.y = this._ItemArr[_local_3].y;
                addChild(_local_4);
                _playerItems.push(_local_4);
                _local_3++;
            };
            if (isViewerRoom)
            {
                PositionUtils.setPos(_viewerItems[0], "asset.ddtmatchroom.ViewerItemPos");
                addChild(_viewerItems[0]);
            };
        }

        override protected function __addPlayer(_arg_1:RoomEvent):void
        {
            var _local_2:RoomPlayer = (_arg_1.params[0] as RoomPlayer);
            if (_local_2.isFirstIn)
            {
                SoundManager.instance.play("158");
            };
            if (_local_2.isViewer)
            {
                _viewerItems[(_local_2.place - 6)].info = _local_2;
            }
            else
            {
                _playerItems[_local_2.place].info = _local_2;
                PlayerManager.Instance.dispatchEvent(new Event(PlayerManager.UPDATE_ROOMPLAYER));
            };
            this.updateButtons();
        }

        override protected function __removePlayer(_arg_1:RoomEvent):void
        {
            var _local_2:RoomPlayer = (_arg_1.params[0] as RoomPlayer);
            if (_local_2.place >= 6)
            {
                _viewerItems[(_local_2.place - 6)].info = null;
            }
            else
            {
                _playerItems[_local_2.place].info = null;
            };
            _local_2.dispose();
            this.updateButtons();
        }

        override public function dispose():void
        {
            super.dispose();
            NewHandContainer.Instance.clearArrowByID(ArrowType.EXIT_MATCHROOM);
            TaskManager.instance.removeEventListener(TaskEvent.ROOMLIST_REFLASH, this.showStart);
            if (this._bg)
            {
                removeChild(this._bg);
            };
            this._bg = null;
            this._bigMapInfoPanel.dispose();
            this._bigMapInfoPanel = null;
            this._smallMapInfoPanel.dispose();
            this._smallMapInfoPanel = null;
            this._playerItemContainer.dispose();
            this._playerItemContainer = null;
            this._crossZoneBtn.dispose();
            this._crossZoneBtn = null;
            if (this._alert1)
            {
                this._alert1.dispose();
            };
            this._alert1 = null;
            if (this._alert2)
            {
                this._alert2.dispose();
            };
            this._alert2 = null;
        }


    }
}//package room.view.roomView

