﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossResurrectView

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.TextButton;
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SharedManager;
    import worldboss.WorldBossManager;
    import com.pickgliss.events.FrameEvent;
    import worldboss.event.WorldBossRoomEvent;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import ddt.manager.LeavePageManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossResurrectView extends Sprite implements Disposeable 
    {

        public static const FIGHT:int = 2;

        private var _bg:Bitmap;
        private var _resurrectBtn:TextButton;
        private var _reFightBtn:TextButton;
        private var _timeCD:MovieClip;
        private var _txtProp:Bitmap;
        private var _totalCount:int;
        private var timer:Timer;
        private var alert:WorldBossConfirmFrame;

        public function WorldBossResurrectView(_arg_1:int)
        {
            this._totalCount = _arg_1;
            this.init();
            this.addEvent();
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("worldBossRoom.resurrectBg");
            this._bg.x = -18;
            this._bg.y = -8;
            addChild(this._bg);
            this._txtProp = ComponentFactory.Instance.creatBitmap("worldBossRoom.resurrectImage");
            addChild(this._txtProp);
            this._resurrectBtn = ComponentFactory.Instance.creat("worldbossRoom.resurrect.btn");
            this._resurrectBtn.text = LanguageMgr.GetTranslation("ddt.worldbossRoom.resurrectBtnTxt");
            addChild(this._resurrectBtn);
            this._reFightBtn = ComponentFactory.Instance.creat("worldbossRoom.reFight.btn");
            this._reFightBtn.text = LanguageMgr.GetTranslation("ddt.worldbossRoom.reFightBtnTxt");
            addChild(this._reFightBtn);
            this._timeCD = ComponentFactory.Instance.creat("asset.worldboosRoom.timeCD");
            addChild(this._timeCD);
            this.timer = new Timer(1000, (this._totalCount + 1));
            this.timer.addEventListener(TimerEvent.TIMER, this.__startCount);
            this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
            this.timer.start();
        }

        private function addEvent():void
        {
            this._resurrectBtn.addEventListener(MouseEvent.CLICK, this.__resurrect);
            this._reFightBtn.addEventListener(MouseEvent.CLICK, this.__reFight);
        }

        private function __resurrect(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (SharedManager.Instance.isResurrect)
            {
                this.promptlyRevive();
            }
            else
            {
                this.alert = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuff.WorldBossConfirmFrame");
                this.alert.showFrame(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("worldboss.revive.propMoney", WorldBossManager.Instance.bossInfo.reviveMoney), null, this.seveIsResurrect);
                this.alert.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            };
        }

        private function __reFight(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (SharedManager.Instance.isReFight)
            {
                this.promptlyFight();
            }
            else
            {
                this.alert = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuff.WorldBossConfirmFrame");
                this.alert.showFrame(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("worldboss.reFight.propMoney", WorldBossManager.Instance.bossInfo.reFightMoney), null, this.seveIsReFight);
                this.alert.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse2);
            };
        }

        private function __revierSuccess(_arg_1:WorldBossRoomEvent):void
        {
            WorldBossManager.Instance.dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.STARTFIGHT));
            WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.REVIER_SUCCESS, this.__revierSuccess);
        }

        public function __startCount(_arg_1:TimerEvent):void
        {
            if (this._totalCount < 0)
            {
                this.__timerComplete();
                return;
            };
            var _local_2:String = ((((this.setFormat(int((this._totalCount / 3600))) + ":") + this.setFormat(int(((this._totalCount / 60) % 60)))) + ":") + this.setFormat(int((this._totalCount % 60))));
            (this._timeCD["timeHour2"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(0)));
            (this._timeCD["timeHour"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(1)));
            (this._timeCD["timeMint2"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(3)));
            (this._timeCD["timeMint"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(4)));
            (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(6)));
            (this._timeCD["timeSecond"] as MovieClip).gotoAndStop(("num_" + _local_2.charAt(7)));
            this._totalCount--;
        }

        private function removeEvent():void
        {
            this._resurrectBtn.removeEventListener(MouseEvent.CLICK, this.__resurrect);
            this._reFightBtn.removeEventListener(MouseEvent.CLICK, this.__reFight);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this.alert.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.promptlyRevive();
                    this.alert.dispose();
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.alert.dispose();
                    return;
            };
        }

        private function __onAlertResponse2(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this.alert.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse2);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.promptlyFight();
                    this.alert.dispose();
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.alert.dispose();
                    return;
            };
        }

        private function seveIsResurrect():void
        {
            SharedManager.Instance.isResurrect = true;
            SharedManager.Instance.save();
        }

        private function seveIsReFight():void
        {
            SharedManager.Instance.isReFight = true;
            SharedManager.Instance.save();
        }

        private function promptlyRevive():void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (PlayerManager.Instance.Self.totalMoney >= WorldBossManager.Instance.bossInfo.reviveMoney)
            {
                SocketManager.Instance.out.sendWorldBossRequestRevive();
            }
            else
            {
                LeavePageManager.showFillFrame();
            };
        }

        private function promptlyFight():void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (PlayerManager.Instance.Self.totalMoney >= WorldBossManager.Instance.bossInfo.reviveMoney)
            {
                WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.REVIER_SUCCESS, this.__revierSuccess);
                SocketManager.Instance.out.sendWorldBossRequestRevive(FIGHT);
            }
            else
            {
                LeavePageManager.showFillFrame();
            };
        }

        private function setFormat(_arg_1:int):String
        {
            var _local_2:String = _arg_1.toString();
            if (_arg_1 < 10)
            {
                _local_2 = ("0" + _local_2);
            };
            return (_local_2);
        }

        private function __timerComplete(_arg_1:TimerEvent=null):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function dispose():void
        {
            this.removeEvent();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER, this.__startCount);
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
            if (this.alert)
            {
                this.alert.dispose();
            };
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                this.parent.removeChild(this);
            };
            this._bg = null;
            this._txtProp = null;
            this._resurrectBtn = null;
            this._reFightBtn = null;
            this._timeCD = null;
        }


    }
}//package worldboss.view

