// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.controller.ChurchRoomController

package church.controller
{
    import ddt.states.BaseStateView;
    import church.model.ChurchRoomModel;
    import church.view.weddingRoom.WeddingRoomView;
    import flash.utils.Timer;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import platformapi.tencent.DiamondManager;
    import ddt.states.StateType;
    import ddt.manager.ChurchManager;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SocketManager;
    import ddt.view.MainToolBar;
    import ddt.manager.PlayerManager;
    import ddt.manager.TimeManager;
    import flash.events.TimerEvent;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.view.chat.ChatData;
    import ddt.view.chat.ChatInputView;
    import ddt.manager.ChatManager;
    import ddt.events.CrazyTankSocketEvent;
    import church.events.WeddingRoomEvent;
    import road7th.comm.PackageIn;
    import ddt.data.player.PlayerInfo;
    import church.vo.PlayerVO;
    import flash.geom.Point;
    import ddt.manager.StateManager;
    import ddt.data.ChurchRoomInfo;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.LeavePageManager;
    import church.view.weddingRoom.WeddingRoomSwitchMovie;
    import flash.events.Event;

    public class ChurchRoomController extends BaseStateView 
    {

        private var _sceneModel:ChurchRoomModel;
        private var _view:WeddingRoomView;
        private var timer:Timer;
        private var _baseAlerFrame:BaseAlerFrame;


        private function get WEDDING_FEE():int
        {
            if (DiamondManager.instance.isInTencent)
            {
                return (60);
            };
            return (50);
        }

        override public function prepare():void
        {
            super.prepare();
        }

        override public function getBackType():String
        {
            return (StateType.DDTCHURCH_ROOM_LIST);
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            ChurchManager.instance.removeLoadingEvent();
            CacheSysManager.lock(CacheConsts.ALERT_IN_MARRY);
            super.enter(_arg_1, _arg_2);
            LayerManager.Instance.clearnGameDynamic();
            LayerManager.Instance.clearnStageDynamic();
            SocketManager.Instance.out.sendCurrentState(0);
            MainToolBar.Instance.hide();
            this.init();
            this.addEvent();
        }

        private function init():void
        {
            this._sceneModel = new ChurchRoomModel();
            this._view = new WeddingRoomView(this, this._sceneModel);
            this._view.show();
            this.resetTimer();
        }

        public function resetTimer():void
        {
            var _local_1:Date;
            var _local_2:Number;
            var _local_3:Number;
            if (ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
            {
                _local_1 = ChurchManager.instance.currentRoom.creactTime;
                _local_2 = (TimeManager.Instance.TotalDaysToNow(_local_1) * 24);
                _local_3 = ((ChurchManager.instance.currentRoom.valideTimes - _local_2) * 60);
                if (_local_3 > 10)
                {
                    this.stopTimer();
                    this.timer = new Timer((((_local_3 - 10) * 60) * 1000), 1);
                    this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                    this.timer.start();
                };
            };
        }

        private function __timerComplete(_arg_1:TimerEvent):void
        {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.timerComplete"));
            var _local_2:ChatData = new ChatData();
            _local_2.channel = ChatInputView.SYS_NOTICE;
            _local_2.msg = LanguageMgr.GetTranslation("church.churchScene.SceneControler.timerComplete.msg");
            ChatManager.Instance.chat(_local_2);
            this.stopTimer();
        }

        private function stopTimer():void
        {
            if (this.timer)
            {
                this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                this.timer = null;
            };
        }

        private function addEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM, this.__addPlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM, this.__removePlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MOVE, this.__movePlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HYMENEAL, this.__startWedding);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTINUATION, this.__continuation);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HYMENEAL_STOP, this.__stopWedding);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USEFIRECRACKERS, this.__onUseFire);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GUNSALUTE, this.__onUseSalute);
            ChurchManager.instance.currentRoom.addEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE, this.__updateWeddingStatus);
            ChurchManager.instance.currentRoom.addEventListener(WeddingRoomEvent.ROOM_VALIDETIME_CHANGE, this.__updateValidTime);
            ChurchManager.instance.addEventListener(WeddingRoomEvent.SCENE_CHANGE, this.__sceneChange);
        }

        private function removeEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM, this.__addPlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM, this.__removePlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MOVE, this.__movePlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HYMENEAL, this.__startWedding);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTINUATION, this.__continuation);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HYMENEAL_STOP, this.__stopWedding);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USEFIRECRACKERS, this.__onUseFire);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GUNSALUTE, this.__onUseSalute);
            ChurchManager.instance.currentRoom.removeEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE, this.__updateWeddingStatus);
            ChurchManager.instance.currentRoom.removeEventListener(WeddingRoomEvent.ROOM_VALIDETIME_CHANGE, this.__updateValidTime);
            ChurchManager.instance.removeEventListener(WeddingRoomEvent.SCENE_CHANGE, this.__sceneChange);
        }

        private function __continuation(_arg_1:CrazyTankSocketEvent):void
        {
            if (ChurchManager.instance.currentRoom)
            {
                ChurchManager.instance.currentRoom.valideTimes = _arg_1.pkg.readInt();
            };
        }

        private function __updateValidTime(_arg_1:WeddingRoomEvent):void
        {
            this.resetTimer();
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            this.dispose();
            ChurchManager.instance.currentRoom = null;
            ChurchManager.instance.currentScene = false;
            SocketManager.Instance.out.sendExitRoom();
            super.leaving(_arg_1);
        }

        override public function getType():String
        {
            return (StateType.CHURCH_ROOM);
        }

        public function __addPlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:PlayerInfo = new PlayerInfo();
            _local_3.beginChanges();
            _local_3.Grade = _local_2.readInt();
            _local_3.Hide = _local_2.readInt();
            _local_3.Repute = _local_2.readInt();
            _local_3.ID = _local_2.readInt();
            _local_3.NickName = _local_2.readUTF();
            _local_3.VIPtype = _local_2.readByte();
            _local_3.VIPLevel = _local_2.readInt();
            _local_3.Sex = _local_2.readBoolean();
            _local_3.Style = _local_2.readUTF();
            _local_3.Colors = _local_2.readUTF();
            _local_3.Skin = _local_2.readUTF();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            _local_3.FightPower = _local_2.readInt();
            _local_3.WinCount = _local_2.readInt();
            _local_3.TotalCount = _local_2.readInt();
            _local_3.Offer = _local_2.readInt();
            _local_3.isOld = _local_2.readBoolean();
            _local_3.commitChanges();
            var _local_6:PlayerVO = new PlayerVO();
            _local_6.playerInfo = _local_3;
            _local_6.playerPos = new Point(_local_4, _local_5);
            if (_local_3.ID == PlayerManager.Instance.Self.ID)
            {
                return;
            };
            this._sceneModel.addPlayer(_local_6);
        }

        public function __removePlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.clientId;
            if (_local_2 == PlayerManager.Instance.Self.ID)
            {
                StateManager.setState(StateType.MAIN);
            }
            else
            {
                if (ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
                {
                    return;
                };
                this._sceneModel.removePlayer(_local_2);
            };
        }

        public function __movePlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_9:Point;
            var _local_2:int = _arg_1.pkg.clientId;
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:int = _arg_1.pkg.readInt();
            var _local_5:String = _arg_1.pkg.readUTF();
            if (ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
            {
                return;
            };
            if (_local_2 == PlayerManager.Instance.Self.ID)
            {
                return;
            };
            var _local_6:Array = _local_5.split(",");
            var _local_7:Array = [];
            var _local_8:uint;
            while (_local_8 < _local_6.length)
            {
                _local_9 = new Point(_local_6[_local_8], _local_6[(_local_8 + 1)]);
                _local_7.push(_local_9);
                _local_8 = (_local_8 + 2);
            };
            this._view.movePlayer(_local_2, _local_7);
        }

        private function __updateWeddingStatus(_arg_1:WeddingRoomEvent):void
        {
            if ((!(ChurchManager.instance.currentScene)))
            {
                this._view.switchWeddingView();
            };
        }

        public function playWeddingMovie():void
        {
            this._view.playerWeddingMovie();
        }

        public function startWedding():void
        {
            var _local_1:Date;
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:PlayerVO;
            if (((ChurchManager.instance.isAdmin(PlayerManager.Instance.Self)) && (!(ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING))))
            {
                _local_1 = ChurchManager.instance.currentRoom.creactTime;
                _local_2 = (TimeManager.Instance.TotalDaysToNow(_local_1) * 24);
                _local_3 = ((ChurchManager.instance.currentRoom.valideTimes - _local_2) * 60);
                if (_local_3 < 10)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.valid"));
                    return;
                };
                _local_4 = this._sceneModel.getPlayerFromID(PlayerManager.Instance.Self.SpouseID);
                if ((!(_local_4)))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.spouse"));
                    return;
                };
                if (ChurchManager.instance.currentRoom.isStarted)
                {
                    if (PlayerManager.Instance.Self.bagLocked)
                    {
                        BaglockedManager.Instance.show();
                        return;
                    };
                    this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.isStarted", this.WEDDING_FEE), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                    this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE, this.__frameEvent);
                    return;
                };
                SocketManager.Instance.out.sendStartWedding();
            };
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            var _local_2:PlayerVO;
            if (this._baseAlerFrame)
            {
                this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
                this._baseAlerFrame.dispose();
                this._baseAlerFrame = null;
            };
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    if (PlayerManager.Instance.Self.totalMoney < this.WEDDING_FEE)
                    {
                        LeavePageManager.showFillFrame();
                        return;
                    };
                    _local_2 = this._sceneModel.getPlayerFromID(PlayerManager.Instance.Self.SpouseID);
                    if ((!(_local_2)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.spouse"));
                        return;
                    };
                    SocketManager.Instance.out.sendStartWedding();
                    return;
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.CANCEL_CLICK:
                    return;
            };
        }

        private function __startWedding(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            if (_local_3)
            {
                ChurchManager.instance.currentRoom.isStarted = true;
                ChurchManager.instance.currentRoom.status = ChurchRoomInfo.WEDDING_ING;
            };
        }

        private function __stopWedding(_arg_1:CrazyTankSocketEvent):void
        {
            ChurchManager.instance.currentRoom.status = ChurchRoomInfo.WEDDING_NONE;
        }

        public function modifyDiscription(_arg_1:String, _arg_2:Boolean, _arg_3:String, _arg_4:String):void
        {
            SocketManager.Instance.out.sendModifyChurchDiscription(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public function useFire(_arg_1:int, _arg_2:int):void
        {
            this._view.useFire(_arg_1, _arg_2);
        }

        private function __onUseFire(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int = _arg_1.pkg.readInt();
            this.useFire(_local_2, _local_3);
        }

        private function __onUseSalute(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            this.setSaulte(_local_2);
        }

        public function setSaulte(_arg_1:int):void
        {
            this._view.setSaulte(_arg_1);
        }

        private function __sceneChange(_arg_1:WeddingRoomEvent):void
        {
            this.readyEnterScene();
        }

        public function readyEnterScene():void
        {
            LayerManager.Instance.clearnGameDynamic();
            LayerManager.Instance.clearnStageDynamic();
            var _local_1:WeddingRoomSwitchMovie = new WeddingRoomSwitchMovie(true, 0.06);
            addChild(_local_1);
            _local_1.playMovie();
            _local_1.addEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE, this.__readyEnterOk);
        }

        private function __readyEnterOk(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE, this.__readyEnterOk);
            this.enterScene();
        }

        public function enterScene():void
        {
            var _local_1:Point;
            this._sceneModel.reset();
            if ((!(ChurchManager.instance.currentScene)))
            {
                _local_1 = new Point(0x0202, 637);
            };
            this._view.setMap(_local_1);
            var _local_2:int = ((ChurchManager.instance.currentScene) ? 2 : 1);
            SocketManager.Instance.out.sendSceneChange(_local_2);
        }

        public function giftSubmit(_arg_1:uint):void
        {
            SocketManager.Instance.out.sendChurchLargess(_arg_1);
        }

        public function roomContinuation(_arg_1:int):void
        {
            SocketManager.Instance.out.sendChurchContinuation(_arg_1);
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.stopTimer();
            if (this._sceneModel)
            {
                this._sceneModel.dispose();
            };
            this._sceneModel = null;
            if (this._view)
            {
                if (this._view.parent)
                {
                    this._view.parent.removeChild(this._view);
                };
                this._view.dispose();
            };
            this._view = null;
            CacheSysManager.unlock(CacheConsts.ALERT_IN_MARRY);
            CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_MARRY);
        }


    }
}//package church.controller

