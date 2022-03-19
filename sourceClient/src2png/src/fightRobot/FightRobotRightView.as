// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//fightRobot.FightRobotRightView

package fightRobot
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ServerConfigManager;
    import flash.events.MouseEvent;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.SharedManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.Vector;
    import com.pickgliss.utils.StringUtils;

    public class FightRobotRightView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _leftFightCountBmp:Bitmap;
        private var _leftCountTxt:MovieClip;
        private var _coolDownTxt:MovieClip;
        private var _coolDownBtn:BaseButton;
        private var _messageVBox:VBox;
        private var _coolDownTime:Number;
        private var _coolDownBmp:Bitmap;
        private var _coolDownAlert:BaseAlerFrame;

        public function FightRobotRightView()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.fightrobot.right.bg");
            this._leftFightCountBmp = ComponentFactory.Instance.creatBitmap("asset.fightrobot.leftFightCount.bmp");
            this._leftCountTxt = ComponentFactory.Instance.creat("asset.ddtcorei.leftCount");
            this._coolDownTxt = ComponentFactory.Instance.creat("asset.corei.coolDown");
            this._coolDownBtn = ComponentFactory.Instance.creatComponentByStylename("fightrobot.coolDownBtn");
            this._coolDownBmp = ComponentFactory.Instance.creatBitmap("asset.fightrobot.coolDownTime");
            this._messageVBox = ComponentFactory.Instance.creatComponentByStylename("fightrobot.messageVbox");
            PositionUtils.setPos(this._leftCountTxt, "fightrobot.leftCountTxt.pos");
            PositionUtils.setPos(this._coolDownTxt, "fightrobot.coolDownTxt.pos");
            this._coolDownBtn.tipData = LanguageMgr.GetTranslation("ddt.fightrobot.coolDownBtn.tips.txt", ServerConfigManager.instance.getShadowNpcClearCdPrice());
            this._coolDownBtn.enable = false;
            addChild(this._bg);
            addChild(this._leftFightCountBmp);
            addChild(this._leftCountTxt);
            addChild(this._coolDownTxt);
            addChild(this._coolDownBtn);
            addChild(this._coolDownBmp);
            addChild(this._messageVBox);
        }

        private function initEvent():void
        {
            this._coolDownBtn.addEventListener(MouseEvent.CLICK, this.__coolDown);
        }

        private function removeEvent():void
        {
            this._coolDownBtn.removeEventListener(MouseEvent.CLICK, this.__coolDown);
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__coolDownTimeHandler);
        }

        private function __coolDown(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if ((!(SharedManager.Instance.coolDownFightRobot)))
            {
                this._coolDownAlert = (ComponentFactory.Instance.creatComponentByStylename("fightRobot.coolDownConfirm") as FightRobotCoolDownConfirmFrame);
                this._coolDownAlert.addEventListener(FrameEvent.RESPONSE, this.__sendCoolDown);
                LayerManager.Instance.addToLayer(this._coolDownAlert, LayerManager.STAGE_DYANMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            }
            else
            {
                if (this._coolDownTime <= TimeManager.Instance.Now().time)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightrobot.coolDown.timeUp"));
                    return;
                };
                if (PlayerManager.Instance.Self.totalMoney < ServerConfigManager.instance.getShadowNpcClearCdPrice())
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.stipple"));
                    return;
                };
                SocketManager.Instance.out.sendFightRobotCoolDown();
            };
        }

        private function __sendCoolDown(_arg_1:FrameEvent):void
        {
            this._coolDownAlert.removeEventListener(FrameEvent.RESPONSE, this.__sendCoolDown);
            this._coolDownAlert = null;
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (this._coolDownTime <= TimeManager.Instance.Now().time)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightrobot.coolDown.timeUp"));
                    }
                    else
                    {
                        if (PlayerManager.Instance.Self.totalMoney < ServerConfigManager.instance.getShadowNpcClearCdPrice())
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.stipple"));
                        }
                        else
                        {
                            SocketManager.Instance.out.sendFightRobotCoolDown();
                        };
                    };
            };
        }

        public function addMessage(_arg_1:Vector.<FightRobotMessage>):void
        {
            var _local_2:FightRobotMessage;
            ObjectUtils.removeChildAllChildren(this._messageVBox);
            for each (_local_2 in _arg_1)
            {
                _local_2.buildText();
                this._messageVBox.addChild(_local_2);
            };
        }

        public function setLastFightTime(_arg_1:Date, _arg_2:Boolean):void
        {
            this._coolDownTime = (_arg_1.time + (ServerConfigManager.instance.getShadowNpcCd() * 1000));
            if (((this._coolDownTime > TimeManager.Instance.Now().time) && (!(_arg_2))))
            {
                this._coolDownBtn.enable = true;
                this.__coolDownTimeHandler();
                TimeManager.addEventListener(TimeEvents.SECONDS, this.__coolDownTimeHandler);
            }
            else
            {
                this._coolDownBtn.enable = false;
                this.resetCoolDownTime();
            };
        }

        public function setRemainFightCount(_arg_1:int):void
        {
            if (((_arg_1 > 9) || (_arg_1 < 0)))
            {
                this._leftCountTxt.num.gotoAndStop("num_0");
                return;
            };
            this._leftCountTxt.num.gotoAndStop(("num_" + _arg_1));
        }

        private function __coolDownTimeHandler(_arg_1:TimeEvents=null):void
        {
            var _local_2:Number;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:String;
            var _local_7:String;
            var _local_8:String;
            if (this._coolDownTime > TimeManager.Instance.Now().time)
            {
                _local_2 = (this._coolDownTime - TimeManager.Instance.Now().time);
                _local_3 = TimeManager.Instance.getHour(_local_2);
                _local_4 = TimeManager.Instance.getMinute(_local_2);
                _local_5 = TimeManager.Instance.getSecond(_local_2);
                _local_6 = StringUtils.padLeft(String(int(_local_3)), "0", 2);
                this._coolDownTxt.timeHour2.gotoAndStop(("num_" + _local_6.substr(0, 1)));
                this._coolDownTxt.timeHour.gotoAndStop(("num_" + _local_6.substr(1, 1)));
                _local_7 = StringUtils.padLeft(String(int(_local_4)), "0", 2);
                this._coolDownTxt.timeMinutes2.gotoAndStop(("num_" + _local_7.substr(0, 1)));
                this._coolDownTxt.timeMinutes.gotoAndStop(("num_" + _local_7.substr(1, 1)));
                _local_8 = StringUtils.padLeft(String(int(_local_5)), "0", 2);
                this._coolDownTxt.timeSecond2.gotoAndStop(("num_" + _local_8.substr(0, 1)));
                this._coolDownTxt.timeSecond.gotoAndStop(("num_" + _local_8.substr(1, 1)));
            }
            else
            {
                this.resetCoolDownTime();
            };
        }

        private function resetCoolDownTime():void
        {
            this._coolDownTxt.timeHour2.gotoAndStop(1);
            this._coolDownTxt.timeHour.gotoAndStop(1);
            this._coolDownTxt.timeMinutes2.gotoAndStop(1);
            this._coolDownTxt.timeMinutes.gotoAndStop(1);
            this._coolDownTxt.timeSecond2.gotoAndStop(1);
            this._coolDownTxt.timeSecond.gotoAndStop(1);
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__coolDownTimeHandler);
            this._coolDownBtn.enable = false;
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._leftFightCountBmp);
            this._leftFightCountBmp = null;
            ObjectUtils.disposeObject(this._coolDownTxt);
            this._coolDownTxt = null;
            ObjectUtils.disposeObject(this._leftCountTxt);
            this._leftCountTxt = null;
            ObjectUtils.disposeObject(this._coolDownBtn);
            this._coolDownBtn = null;
            ObjectUtils.disposeObject(this._coolDownBmp);
            this._coolDownBmp = null;
            ObjectUtils.disposeObject(this._messageVBox);
            this._messageVBox = null;
            this._coolDownAlert = null;
        }


    }
}//package fightRobot

