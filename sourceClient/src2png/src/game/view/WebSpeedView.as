﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.WebSpeedView

package game.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import room.model.WebSpeedInfo;
    import game.GameManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.utils.getTimer;
    import ddt.events.WebSpeedEvent;
    import flash.events.Event;
    import ddt.manager.LanguageMgr;

    public class WebSpeedView extends Sprite 
    {

        private var _bg:ScaleFrameImage;
        private var _info:WebSpeedInfo = GameManager.Instance.Current.selfGamePlayer.webSpeedInfo;
        private var _startTime:Number;
        private var _count:uint = 1500;

        public function WebSpeedView()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.game.webSpdIcon");
            addChild(this._bg);
            this._bg.setFrame(1);
            this._startTime = getTimer();
            this.__stateChanged(null);
        }

        public function dispose():void
        {
            this._info.removeEventListener(WebSpeedEvent.STATE_CHANE, this.__stateChanged);
            removeEventListener(Event.ENTER_FRAME, this.__frame);
            this._info = null;
            this._bg.dispose();
            this._bg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function initEvent():void
        {
            this._info.addEventListener(WebSpeedEvent.STATE_CHANE, this.__stateChanged);
            addEventListener(Event.ENTER_FRAME, this.__frame);
        }

        private function __stateChanged(_arg_1:WebSpeedEvent):void
        {
            this._bg.setFrame(this._info.stateId);
            var _local_2:Object = new Object();
            _local_2["stateTxt"] = this._info.state;
            _local_2["delayTxt"] = (LanguageMgr.GetTranslation("tank.game.WebSpeedView.delay") + this._info.delay.toString());
            _local_2["fpsTxt"] = (LanguageMgr.GetTranslation("tank.game.WebSpeedView.frame") + this._info.fps.toString());
            _local_2["explain1"] = LanguageMgr.GetTranslation("tank.game.WebSpeedView.explain1");
            _local_2["explain2"] = LanguageMgr.GetTranslation("tank.game.WebSpeedView.explain2");
            this._bg.tipData = _local_2;
        }

        private function __frame(_arg_1:Event):void
        {
            var _local_2:Number = (getTimer() - this._startTime);
            this._count++;
            this._startTime = getTimer();
            if (this._count < 1500)
            {
                return;
            };
            this._info.fps = int((1000 / _local_2));
            this._count = 0;
        }


    }
}//package game.view

