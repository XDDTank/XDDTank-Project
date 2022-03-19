// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//fightRobot.FightRobotFrame

package fightRobot
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.HelpFrame;
    import road7th.comm.PackageIn;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.TimeManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.AlertManager;
    import flash.events.MouseEvent;
    import ddt.manager.MessageTipManager;
    import ddt.manager.ServerConfigManager;
    import room.RoomManager;
    import ddt.manager.GameInSocketOut;
    import roomList.pvpRoomList.RoomListBGView;
    import room.model.RoomInfo;
    import game.GameManager;
    import ddt.manager.StateManager;
    import __AS3__.vec.*;

    public class FightRobotFrame extends Frame implements Disposeable 
    {

        private var _titleBmp:Bitmap;
        private var _beginBtn:BaseButton;
        private var _beginBtnBg:Scale9CornerImage;
        private var _leftView:FightRobotLeftView;
        private var _rightView:FightRobotRightView;
        private var _teamateInfo:Vector.<FightRobotTeamateView>;
        private var _messageList:Vector.<FightRobotMessage>;
        private var _lastFightDate:Date;
        private var _remainFightCount:int;
        private var _hasClearCD:Boolean;
        private var _helpFrame:HelpFrame;
        private var _waiting:Boolean;

        public function FightRobotFrame()
        {
            escEnable = true;
        }

        private function __frameOpen(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:int;
            var _local_5:uint;
            var _local_6:FightRobotTeamateView;
            var _local_7:String;
            var _local_8:String;
            var _local_9:String;
            var _local_10:int;
            var _local_11:Boolean;
            this.__onClose();
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:Boolean = _local_2.readBoolean();
            if (_local_3)
            {
                this._remainFightCount = _local_2.readInt();
                this._lastFightDate = _local_2.readDate();
                this._hasClearCD = _local_2.readBoolean();
                _local_4 = _local_2.readInt();
                this._teamateInfo = new Vector.<FightRobotTeamateView>();
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    _local_6 = new FightRobotTeamateView();
                    _local_7 = _local_2.readUTF();
                    _local_8 = _local_2.readUTF();
                    _local_9 = _local_2.readUTF();
                    _local_10 = _local_2.readInt();
                    _local_11 = _local_2.readBoolean();
                    _local_6.setStyle(_local_7, _local_8, _local_9, _local_10, _local_11);
                    _local_6.isVIP = _local_2.readBoolean();
                    _local_6.nickName = _local_2.readUTF();
                    _local_6.fightPower = _local_2.readInt();
                    this._teamateInfo.push(_local_6);
                    _local_5++;
                };
                this.initView();
                this.initEvent();
            }
            else
            {
                this.dispose();
            };
        }

        private function __getHistoryMessage(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:FightRobotMessage;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            var _local_4:uint;
            while (_local_4 < _local_3)
            {
                _local_5 = new FightRobotMessage();
                _local_5.messageID = _local_2.readInt();
                _local_5.challengerID = _local_2.readInt();
                _local_5.challengerName = _local_2.readUTF();
                _local_5.defenderName = _local_2.readUTF();
                _local_5.fightTime = _local_2.readDate();
                _local_5.result = _local_2.readByte();
                if (this._messageList.length >= 10)
                {
                    this.deleteLastMessage();
                };
                this._messageList.push(_local_5);
                this._messageList.sort(this.sortMessage);
                _local_4++;
            };
            if (this._rightView)
            {
                this._rightView.addMessage(this._messageList);
            };
        }

        private function __clearCD(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:Boolean = _local_2.readBoolean();
            this._hasClearCD = _local_3;
            if (_local_3)
            {
                if (this._rightView)
                {
                    this._rightView.setLastFightTime(TimeManager.Instance.Now(), _local_3);
                };
            };
        }

        private function deleteLastMessage():void
        {
            var _local_2:FightRobotMessage;
            var _local_1:FightRobotMessage = this._messageList[0];
            for each (_local_2 in this._messageList)
            {
                if (_local_1.fightTime.time > _local_2.fightTime.time)
                {
                    _local_1 = _local_2;
                };
            };
            this._messageList.splice(this._messageList.indexOf(_local_1), 1)[0].dispose();
        }

        private function sortMessage(_arg_1:FightRobotMessage, _arg_2:FightRobotMessage):int
        {
            if (_arg_1.fightTime.time < _arg_2.fightTime.time)
            {
                return (1);
            };
            return (-1);
        }

        private function initView():void
        {
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.fightrobot.title");
            this._beginBtnBg = ComponentFactory.Instance.creatComponentByStylename("fightrobot.beginBtn.bg");
            this._beginBtn = ComponentFactory.Instance.creatComponentByStylename("fightrobot.beginBtn");
            this._beginBtn.tipData = LanguageMgr.GetTranslation("ddt.fightrobot.beginFightBtn.tips.txt");
            this._leftView = new FightRobotLeftView();
            PositionUtils.setPos(this._leftView, "fightrobot.leftView.pos");
            this._rightView = new FightRobotRightView();
            PositionUtils.setPos(this._rightView, "fightrobot.rightView.pos");
            this._leftView.teamateList = this._teamateInfo;
            this._rightView.addMessage(this._messageList);
            if (this._remainFightCount == 0)
            {
                this._hasClearCD = true;
            };
            this._rightView.setLastFightTime(this._lastFightDate, this._hasClearCD);
            this._rightView.setRemainFightCount(this._remainFightCount);
            addToContent(this._titleBmp);
            addToContent(this._beginBtnBg);
            addToContent(this._beginBtn);
            addToContent(this._leftView);
            addToContent(this._rightView);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.dispose();
            };
            if (_arg_1.responseCode == FrameEvent.HELP_CLICK)
            {
                this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("helpFrame");
                this._helpFrame.setView(ComponentFactory.Instance.creat("fightrobot.HelpFrame.txt"));
                this._helpFrame.addEventListener(FrameEvent.RESPONSE, this.__helpResponseHandler);
                this._helpFrame.show();
            };
        }

        private function __helpResponseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._helpFrame.removeEventListener(FrameEvent.RESPONSE, this.__helpResponseHandler);
            ObjectUtils.disposeObject(this._helpFrame);
            this._helpFrame = null;
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FIGHT_ROBOT);
        }

        private function __onUIComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.FIGHT_ROBOT)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
                addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
                this._messageList = new Vector.<FightRobotMessage>();
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTROBOT_OPEN_FRAME, this.__frameOpen);
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTROBOT_HISTORY_MESSAGE, this.__getHistoryMessage);
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTROBOT_CLEAR_CD, this.__clearCD);
                SocketManager.Instance.out.sendOpenFightRobotView();
            };
        }

        private function __onUIProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function __onClose(_arg_1:Event=null):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            if (_arg_1)
            {
                this.dispose();
            };
        }

        private function __beginFightRobot(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            SoundManager.instance.play("008");
            if (this._waiting)
            {
                return;
            };
            this._waiting = true;
            if (PlayerManager.Instance.checkExpedition())
            {
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                _local_2.moveEnable = false;
                _local_2.addEventListener(FrameEvent.RESPONSE, this.__expeditionFightRobotConfirmResponse);
            }
            else
            {
                this.doFightRobot();
            };
        }

        private function __expeditionFightRobotConfirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__expeditionFightRobotConfirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                this.doFightRobot();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function doFightRobot():void
        {
            if (this._remainFightCount == 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightrobot.fightCountNotEnough.txt"));
                return;
            };
            if ((((this._lastFightDate.time + (ServerConfigManager.instance.getShadowNpcCd() * 1000)) > TimeManager.Instance.Now().time) && (!(this._hasClearCD))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightrobot.notCoolDown.txt"));
                return;
            };
            RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
            RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
            GameInSocketOut.sendCreateRoom(RoomListBGView.PREWORD[int((Math.random() * RoomListBGView.PREWORD.length))], RoomInfo.FIGHT_ROBOT, 3);
        }

        private function __gameStart(_arg_1:CrazyTankSocketEvent):void
        {
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
            GameInSocketOut.sendGameRoomSetUp(0, RoomInfo.FIGHT_ROBOT, false, "", "", 3, 1, 0, false, RoomManager.Instance.current.ID);
        }

        private function __onSetupChanged(_arg_1:CrazyTankSocketEvent):void
        {
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
            this._waiting = false;
            SocketManager.Instance.out.sendFightRobot();
        }

        private function initEvent():void
        {
            this._beginBtn.addEventListener(MouseEvent.CLICK, this.__beginFightRobot);
            GameManager.Instance.addEventListener(GameManager.START_LOAD, this.__startLoading, false, 1);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHTROBOT_OPEN_FRAME, this.__frameOpen);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHTROBOT_HISTORY_MESSAGE, this.__getHistoryMessage);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHTROBOT_CLEAR_CD, this.__clearCD);
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
            GameManager.Instance.removeEventListener(GameManager.START_LOAD, this.__startLoading);
            if (this._beginBtn)
            {
                this._beginBtn.removeEventListener(MouseEvent.CLICK, this.__beginFightRobot);
            };
            if (this._helpFrame)
            {
                this._helpFrame.removeEventListener(FrameEvent.RESPONSE, this.__helpResponseHandler);
            };
        }

        private function __startLoading(_arg_1:Event):void
        {
            _arg_1.stopImmediatePropagation();
            StateManager.getInGame_Step_6 = true;
            if (GameManager.Instance.Current == null)
            {
                return;
            };
            GameManager.Instance.gotoRoomLoading();
            StateManager.getInGame_Step_7 = true;
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._titleBmp);
            this._titleBmp = null;
            ObjectUtils.disposeObject(this._beginBtn);
            this._beginBtn = null;
            ObjectUtils.disposeObject(this._beginBtnBg);
            this._beginBtnBg = null;
            ObjectUtils.disposeObject(this._leftView);
            this._leftView = null;
            ObjectUtils.disposeObject(this._rightView);
            this._rightView = null;
            ObjectUtils.disposeObject(this._helpFrame);
            this._helpFrame = null;
            this._teamateInfo = null;
            this._lastFightDate = null;
            this._messageList = null;
            super.dispose();
        }


    }
}//package fightRobot

