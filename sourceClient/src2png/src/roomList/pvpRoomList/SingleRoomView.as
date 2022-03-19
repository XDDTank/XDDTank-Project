// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pvpRoomList.SingleRoomView

package roomList.pvpRoomList
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.MutipleImage;
    import room.model.RoomInfo;
    import room.view.singleView.SingleRightPropView;
    import flash.display.Bitmap;
    import room.view.smallMapInfoPanel.MatchRoomSmallMapInfoPanel;
    import room.view.singleView.SinglePlayerItem;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.utils.Timer;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ClassUtils;
    import ddt.manager.BossBoxManager;
    import ddt.manager.GameInSocketOut;
    import ddt.events.RoomEvent;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import game.GameManager;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.manager.ChatManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.MainToolBar;
    import ddt.manager.SocketManager;
    import roomList.LookupEnumerate;
    import room.RoomManager;
    import ddt.manager.TaskManager;
    import ddt.events.TaskEvent;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class SingleRoomView extends Frame 
    {

        protected static const HURRY_UP_TIME:int = 30;
        protected static const KICK_TIME:int = 60;
        protected static const KICK_TIMEII:int = 300;
        protected static const KICK_TIMEIII:int = 1200;
        private static const MATCH_NPC_ENABLE:Boolean = false;
        private static const MATCH_NPC:int = 40;
        private static const BOTH_MODE_ALERT_TIME:int = 60;

        private var _bg1:MutipleImage;
        protected var _info:RoomInfo;
        protected var _roomPropView:SingleRightPropView;
        private var _beginTip:Bitmap;
        private var _smallMapInfoPanel:MatchRoomSmallMapInfoPanel;
        private var _playerItem:SinglePlayerItem;
        private var _btnBg:Bitmap;
        protected var _startBtn:MovieClip;
        protected var _cancelBtn:SimpleBitmapButton;
        private var _timeTxt:FilterFrameText;
        private var _timer:Timer;
        private var _matchingPic:Bitmap;


        public function initII(_arg_1:RoomInfo):void
        {
            titleText = LanguageMgr.GetTranslation("tank.roomlist.RoomList.singleRoomTitle");
            this._info = _arg_1;
            this.initView();
            this.initEvents();
        }

        protected function initView():void
        {
            this._bg1 = ComponentFactory.Instance.creat("asset.ddtroomList.RoomList.SingleRoomView.bg");
            addToContent(this._bg1);
            this._playerItem = ComponentFactory.Instance.creatCustomObject("asset.ddtRoomlist.singleView.playerItem");
            this._playerItem.info = this._info.findPlayerByPlace(0);
            addToContent(this._playerItem);
            this._roomPropView = ComponentFactory.Instance.creatCustomObject("asset.ddtRoomlist.singleView.roomPropView");
            addToContent(this._roomPropView);
            this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("asset.ddtRoomlist.singlePVP.smallMapInfoPanel");
            this._smallMapInfoPanel.info = this._info;
            this._smallMapInfoPanel.canSelected = false;
            addToContent(this._smallMapInfoPanel);
            this._btnBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.StartbtnBg");
            PositionUtils.setPos(this._btnBg, "asset.ddtroomlist.singleRoom.btnBGPos");
            addToContent(this._btnBg);
            this._startBtn = (ClassUtils.CreatInstance("asset.ddtroom.startMovie") as MovieClip);
            this._startBtn.buttonMode = true;
            addToContent(this._startBtn);
            PositionUtils.setPos(this._startBtn, "asset.ddtroomlist.singleRoom.startMoviePos");
            this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.SingleRoomView.startBtn");
            this._cancelBtn.visible = false;
            addToContent(this._cancelBtn);
            this._beginTip = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.singleRoom.beginTip");
            addToContent(this._beginTip);
            this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.SingleRoomView.timeTxt");
            addToContent(this._timeTxt);
            this._timer = new Timer(1000);
            this._matchingPic = ComponentFactory.Instance.creatBitmap("asset.ddtroom.bigMapInfo.matchingTxt");
            PositionUtils.setPos(this._matchingPic, "asset.ddtroomlist.singleRoom.matchingTxtPos");
            this._matchingPic.visible = false;
            addToContent(this._matchingPic);
            if (BossBoxManager.instance.isShowGradeBox)
            {
                BossBoxManager.instance.isShowGradeBox = false;
                BossBoxManager.instance.showGradeBox();
            };
        }

        protected function initEvents():void
        {
            if (this.checkCanStartGame())
            {
                GameInSocketOut.sendGameStart();
            };
            this._info.addEventListener(RoomEvent.STARTED_CHANGED, this.__startHandler);
            this._info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__updateState);
            this._info.addEventListener(RoomEvent.ALLOW_CROSS_CHANGE, this.__crossZoneChangeHandler);
            addEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
            addEventListener(FrameEvent.RESPONSE, this.__response);
            GameManager.Instance.addEventListener(GameManager.START_LOAD, this.__startLoading);
            this._timer.addEventListener(TimerEvent.TIMER, this.__timer);
            this._startBtn.addEventListener(MouseEvent.CLICK, this.__startClick);
            this._cancelBtn.addEventListener(MouseEvent.CLICK, this.__cancelClick);
        }

        private function updateButtons():void
        {
            this._beginTip.visible = (this._startBtn.visible = (!(this._info.started)));
            this._timeTxt.visible = (this._matchingPic.visible = (this._cancelBtn.visible = this._info.started));
            if (this._info.started)
            {
                this._startBtn.removeEventListener(MouseEvent.CLICK, this.__startClick);
            }
            else
            {
                this._startBtn.addEventListener(MouseEvent.CLICK, this.__startClick);
            };
        }

        private function __crossZoneClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            GameInSocketOut.sendGameRoomSetUp(this._info.mapId, this._info.type, false, this._info.roomPass, this._info.roomName, 3, 0, 0, (!(this._info.isCrossZone)), 0);
        }

        private function __crossZoneChangeHandler(_arg_1:RoomEvent):void
        {
            if (this._info.isCrossZone)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView.cross.kuaqu"));
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView.cross.benqu"));
            };
        }

        protected function __startClick(_arg_1:MouseEvent):void
        {
            if (NewHandContainer.Instance.hasArrow(ArrowType.START_GAME))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.START_GAME);
            };
            SoundManager.instance.play("008");
            if (this.checkCanStartGame())
            {
                GameInSocketOut.sendGameStart();
                this._info.started = true;
            };
        }

        protected function __startLoading(_arg_1:Event):void
        {
            ChatManager.Instance.input.faceEnabled = false;
            LayerManager.Instance.clearnGameDynamic();
            GameManager.Instance.gotoRoomLoading();
        }

        private function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this.closeFrame();
        }

        private function __loadWeakGuild(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
        }

        protected function removeEvents():void
        {
            this._info.started = false;
            this._timer.removeEventListener(TimerEvent.TIMER, this.__timer);
            this._info.removeEventListener(RoomEvent.STARTED_CHANGED, this.__startHandler);
            this._info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__updateState);
            this._info.removeEventListener(RoomEvent.ALLOW_CROSS_CHANGE, this.__crossZoneChangeHandler);
            removeEventListener(Event.ADDED_TO_STAGE, this.__loadWeakGuild);
            removeEventListener(FrameEvent.RESPONSE, this.__response);
            GameManager.Instance.removeEventListener(GameManager.START_LOAD, this.__startLoading);
            this._startBtn.removeEventListener(MouseEvent.CLICK, this.__startClick);
            this._cancelBtn.removeEventListener(MouseEvent.CLICK, this.__cancelClick);
        }

        protected function __cancelClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            GameInSocketOut.sendCancelWait();
            MainToolBar.Instance.enableAll();
            this._info.started = false;
        }

        private function __timer(_arg_1:TimerEvent):void
        {
            var _local_2:uint = (9 - (this._timer.currentCount % 10));
            this._timeTxt.text = ("0" + _local_2);
            if (this._timer.currentCount == 20)
            {
                if (((!(this._info.selfRoomPlayer.isHost)) && (!(this._info.selfRoomPlayer.isViewer))))
                {
                    dispatchEvent(new RoomEvent(RoomEvent.TWEENTY_SEC));
                };
            };
        }

        private function closeFrame():void
        {
            SoundManager.instance.stop("007");
            this.dispose();
            GameInSocketOut.sendGamePlayerExit();
            SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.ROOM_LIST);
            GameManager.Instance.reset();
            RoomManager.Instance.reset();
            MainToolBar.Instance.enableAll();
            TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.ROOMLIST_REFLASH));
        }

        protected function checkCanStartGame():Boolean
        {
            var _local_1:Boolean = true;
            if (PlayerManager.Instance.Self.Bag.getItemAt(14) == null)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                _local_1 = false;
            };
            return (_local_1);
        }

        protected function __startHandler(_arg_1:RoomEvent):void
        {
            this.updateButtons();
            if (this._info.started)
            {
                MainToolBar.Instance.setRoomStartState();
                SoundManager.instance.stop("007");
                if ((!(this._timer.running)))
                {
                    this._timeTxt.text = "09";
                    this._timer.start();
                };
            }
            else
            {
                this._timer.stop();
                this._timer.reset();
                if (((this._info.gameMode == RoomInfo.BOTH_MODE) && (this._info.selfRoomPlayer.isHost)))
                {
                    SocketManager.Instance.out.sendGameStyle(RoomInfo.GUILD_MODE);
                };
                if (this._info.selfRoomPlayer.isHost)
                {
                    MainToolBar.Instance.enableAll();
                }
                else
                {
                    if (this._info.selfRoomPlayer.isReady)
                    {
                        MainToolBar.Instance.setRoomStartState();
                    }
                    else
                    {
                        MainToolBar.Instance.enableAll();
                    };
                };
            };
        }

        protected function __updateState(_arg_1:RoomEvent):void
        {
            this.updateButtons();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            NewHandContainer.Instance.clearArrowByID(ArrowType.CREAT_ROOM);
        }

        override public function dispose():void
        {
            this.removeEvents();
            NewHandContainer.Instance.clearArrowByID(ArrowType.GET_ZXC_ITEM);
            if (NewHandContainer.Instance.hasArrow(ArrowType.START_GAME))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.START_GAME);
            };
            ObjectUtils.disposeObject(this._bg1);
            this._bg1 = null;
            ObjectUtils.disposeObject(this._roomPropView);
            this._roomPropView = null;
            ObjectUtils.disposeObject(this._beginTip);
            this._beginTip = null;
            ObjectUtils.disposeObject(this._smallMapInfoPanel);
            this._smallMapInfoPanel = null;
            ObjectUtils.disposeObject(this._playerItem);
            this._playerItem = null;
            ObjectUtils.disposeObject(this._btnBg);
            this._btnBg = null;
            ObjectUtils.disposeObject(this._startBtn);
            this._startBtn = null;
            ObjectUtils.disposeObject(this._cancelBtn);
            this._cancelBtn = null;
            ObjectUtils.disposeObject(this._timeTxt);
            this._timeTxt = null;
            ObjectUtils.disposeObject(this._matchingPic);
            this._matchingPic = null;
            this._info = null;
            this._timer.stop();
            this._timer = null;
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package roomList.pvpRoomList

