// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//fightRobot.FightRobotMessage

package fightRobot
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import room.RoomManager;
    import ddt.events.CrazyTankSocketEvent;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.GameInSocketOut;
    import roomList.pvpRoomList.RoomListBGView;
    import room.model.RoomInfo;
    import ddt.manager.TimeManager;
    import com.pickgliss.utils.DisplayUtils;

    public class FightRobotMessage extends Sprite implements Disposeable 
    {

        private var _messageTxt:FilterFrameText;
        private var _fightBackBtn:TextButton;
        private var _messageID:int;
        private var _challengerID:int;
        private var _challengerName:String;
        private var _defenderName:String;
        private var _fightTime:Date;
        private var _result:int;
        private var _waiting:Boolean;

        public function FightRobotMessage()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._messageTxt = ComponentFactory.Instance.creatComponentByStylename("fightrobot.message.text");
            this._fightBackBtn = ComponentFactory.Instance.creatComponentByStylename("fightrobot.fightBackBtn");
            this._fightBackBtn.text = LanguageMgr.GetTranslation("ddt.fightrobot.message.fightBackBtn.txt");
            this._fightBackBtn.visible = false;
            addChild(this._messageTxt);
            addChild(this._fightBackBtn);
        }

        private function initEvent():void
        {
            this._fightBackBtn.addEventListener(MouseEvent.CLICK, this.__fightBack);
        }

        private function removeEvent():void
        {
            this._fightBackBtn.addEventListener(MouseEvent.CLICK, this.__fightBack);
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
        }

        private function __fightBack(_arg_1:MouseEvent):void
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
                this.createFight();
            };
        }

        private function __expeditionFightRobotConfirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__expeditionFightRobotConfirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                this.createFight();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function createFight():void
        {
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
            SocketManager.Instance.out.sendRevengeRobot(this._messageID);
        }

        public function buildText():void
        {
            var _local_1:String = TimeManager.Instance.formatTimeToString2((TimeManager.Instance.Now().time - this._fightTime.time));
            if (this._challengerID == PlayerManager.Instance.Self.ID)
            {
                if (this._result == 0)
                {
                    this._messageTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightrobot.message.lose.txt", _local_1, DisplayUtils.subStringByLength(this._messageTxt, this._defenderName, 100));
                }
                else
                {
                    if (((this._result == 1) || (this._result == 2)))
                    {
                        this._messageTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightrobot.message.win.txt", _local_1, DisplayUtils.subStringByLength(this._messageTxt, this._defenderName, 100));
                    };
                };
            }
            else
            {
                if (this._result == 0)
                {
                    this._messageTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightrobot.message.toBeWin.txt", _local_1, DisplayUtils.subStringByLength(this._messageTxt, this._challengerName, 100));
                }
                else
                {
                    if (this._result == 1)
                    {
                        this._messageTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightrobot.message.toBeLose.txt", _local_1, DisplayUtils.subStringByLength(this._messageTxt, this._challengerName, 100));
                        this._fightBackBtn.visible = true;
                    }
                    else
                    {
                        if (this._result == 2)
                        {
                            this._messageTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightrobot.message.toBeLose.txt", _local_1, DisplayUtils.subStringByLength(this._messageTxt, this._challengerName, 100));
                        };
                    };
                };
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._messageTxt);
            this._messageTxt = null;
            ObjectUtils.disposeObject(this._fightBackBtn);
            this._fightBackBtn = null;
        }

        public function get messageID():int
        {
            return (this._messageID);
        }

        public function set messageID(_arg_1:int):void
        {
            this._messageID = _arg_1;
        }

        public function get challengerID():int
        {
            return (this._challengerID);
        }

        public function set challengerID(_arg_1:int):void
        {
            this._challengerID = _arg_1;
        }

        public function get challengerName():String
        {
            return (this._challengerName);
        }

        public function set challengerName(_arg_1:String):void
        {
            this._challengerName = _arg_1;
        }

        public function get defenderName():String
        {
            return (this._defenderName);
        }

        public function set defenderName(_arg_1:String):void
        {
            this._defenderName = _arg_1;
        }

        public function get fightTime():Date
        {
            return (this._fightTime);
        }

        public function set fightTime(_arg_1:Date):void
        {
            this._fightTime = _arg_1;
        }

        public function get result():int
        {
            return (this._result);
        }

        public function set result(_arg_1:int):void
        {
            this._result = _arg_1;
        }


    }
}//package fightRobot

