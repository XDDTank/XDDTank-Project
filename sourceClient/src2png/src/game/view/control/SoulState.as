// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.control.SoulState

package game.view.control
{
    import game.view.prop.SoulPropBar;
    import game.view.prop.CustomPropBar;
    import com.greensock.TweenMax;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import flash.display.MovieClip;
    import ddt.view.chat.ChatFacePanel;
    import flash.geom.Point;
    import game.model.LocalPlayer;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import im.IMController;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.ChatManager;
    import ddt.manager.SoundManager;
    import org.aswing.KeyboardManager;
    import flash.ui.Keyboard;
    import ddt.manager.StateManager;
    import org.aswing.KeyStroke;
    import flash.text.TextField;
    import game.view.GameViewBase;
    import flash.display.DisplayObjectContainer;
    import com.greensock.TweenLite;
    import com.pickgliss.utils.ObjectUtils;

    public class SoulState extends ControlState 
    {

        private var _psychicBar:PsychicBar;
        private var _propBar:SoulPropBar;
        private var _customPropBar:CustomPropBar;
        private var _tweenMax:TweenMax;
        private var _msgShape:DisplayObject;
        private var _fastChatBtn:SimpleBitmapButton;
        private var _faceBtn:SimpleBitmapButton;
        private var _fastMovie:MovieClip;
        private var _facePanel:ChatFacePanel;
        private var _facePanelPos:Point;
        private var _isREleaseFours:Boolean;

        public function SoulState(_arg_1:LocalPlayer)
        {
            super(_arg_1);
            mouseEnabled = false;
        }

        override protected function configUI():void
        {
            _background = ComponentFactory.Instance.creatBitmap("asset.game.SoulState.Back");
            addChild(_background);
            this._tweenMax = TweenMax.to(_background, 0.7, {
                "repeat":-1,
                "yoyo":true,
                "glowFilter":{
                    "color":3305215,
                    "alpha":0.8,
                    "blurX":8,
                    "blurY":8,
                    "strength":2
                }
            });
            this._psychicBar = ComponentFactory.Instance.creatCustomObject("PsychicBar", [_self]);
            addChild(this._psychicBar);
            this._customPropBar = ComponentFactory.Instance.creatCustomObject("SoulCustomPropBar", [_self, FightControlBar.SOUL]);
            addChild(this._customPropBar);
            this._propBar = ComponentFactory.Instance.creatCustomObject("SoulPropBar", [_self]);
            addChild(this._propBar);
            this._faceBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.faceButton");
            this.setTip(this._faceBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.face"));
            addChild(this._faceBtn);
            this._facePanel = ComponentFactory.Instance.creatCustomObject("chat.FacePanel", [true]);
            this._facePanelPos = ComponentFactory.Instance.creatCustomObject("asset.soulState.facePanelPos");
            this._fastChatBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.chatButton");
            this.setTip(this._fastChatBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.chat"));
            addChild(this._fastChatBtn);
            this._fastMovie = (ClassUtils.CreatInstance("asset.game.prop.chatMoive") as MovieClip);
            PositionUtils.setPos(this._fastMovie, "asset.game.chatmoviePos");
            this._fastChatBtn.addChild(this._fastMovie);
            if (((IMController.Instance.hasUnreadMessage()) && (!(IMController.Instance.cancelflashState))))
            {
                this._fastMovie.gotoAndPlay(1);
            }
            else
            {
                this._fastMovie.gotoAndStop(this._fastMovie.totalFrames);
            };
            PositionUtils.setPos(this._faceBtn, "asset.soulState.facebtnPos");
            PositionUtils.setPos(this._fastChatBtn, "asset.soulState.fastbtnPos");
            super.configUI();
        }

        private function setTip(_arg_1:BaseButton, _arg_2:String):void
        {
            _arg_1.tipStyle = "ddt.view.tips.OneLineTip";
            _arg_1.tipDirctions = "0";
            _arg_1.tipGapV = 5;
            _arg_1.tipData = _arg_2;
        }

        override protected function addEvent():void
        {
            StageReferance.stage.addEventListener(Event.ENTER_FRAME, this.__onFrame);
            this._fastChatBtn.addEventListener(MouseEvent.CLICK, this.__fastChat);
            this._fastChatBtn.addEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            this._fastChatBtn.addEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            this._faceBtn.addEventListener(MouseEvent.CLICK, this.__face);
            this._facePanel.addEventListener(Event.SELECT, this.__onFaceSelect);
            IMController.Instance.addEventListener(IMController.HAS_NEW_MESSAGE, this.__hasNewHandler);
            IMController.Instance.addEventListener(IMController.NO_MESSAGE, this.__noMessageHandler);
        }

        protected function __noMessageHandler(_arg_1:Event):void
        {
            this._fastMovie.gotoAndStop(this._fastMovie.totalFrames);
        }

        protected function __hasNewHandler(_arg_1:Event):void
        {
            this._fastMovie.gotoAndPlay(1);
        }

        protected function __onFaceSelect(_arg_1:Event):void
        {
            ChatManager.Instance.sendFace(this._facePanel.selected);
            this._facePanel.setVisible = false;
            StageReferance.stage.focus = null;
        }

        protected function __face(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._facePanel.x = localToGlobal(new Point(this._facePanelPos.x, this._facePanelPos.y)).x;
            this._facePanel.y = localToGlobal(new Point(this._facePanelPos.x, this._facePanelPos.y)).y;
            this._facePanel.setVisible = true;
        }

        protected function __outHandler(_arg_1:MouseEvent):void
        {
            IMController.Instance.hideMessageBox();
        }

        protected function __overHandler(_arg_1:MouseEvent):void
        {
            if (KeyboardManager.isDown(Keyboard.SPACE))
            {
                return;
            };
            IMController.Instance.showMessageBox(this._fastChatBtn);
        }

        protected function __fastChat(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            ChatManager.Instance.switchVisible();
        }

        private function __onFrame(_arg_1:Event):void
        {
            if ((!(StateManager.isInFight)))
            {
                this.dispose();
            };
            if (((!(StageReferance.stage.focus is TextField)) && (KeyboardManager.isDown(KeyStroke.VK_SPACE.getCode()))))
            {
                _self.setCenter(_self.pos.x, _self.pos.y, true);
                (StateManager.current as GameViewBase).map.lockFocusAt(new Point(_self.pos.x, _self.pos.y));
                this._isREleaseFours = false;
            }
            else
            {
                if ((!(this._isREleaseFours)))
                {
                    (StateManager.current as GameViewBase).map.releaseFocus();
                    this._isREleaseFours = true;
                };
            };
        }

        override protected function removeEvent():void
        {
            StageReferance.stage.removeEventListener(Event.ENTER_FRAME, this.__onFrame);
            if (this._fastChatBtn)
            {
                this._fastChatBtn.removeEventListener(MouseEvent.CLICK, this.__fastChat);
                this._fastChatBtn.removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
                this._fastChatBtn.removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            };
            if (this._faceBtn)
            {
                this._faceBtn.removeEventListener(MouseEvent.CLICK, this.__face);
            };
            if (this._facePanel)
            {
                this._facePanel.removeEventListener(Event.SELECT, this.__onFaceSelect);
            };
            IMController.Instance.removeEventListener(IMController.HAS_NEW_MESSAGE, this.__hasNewHandler);
            IMController.Instance.removeEventListener(IMController.NO_MESSAGE, this.__noMessageHandler);
        }

        override public function enter(_arg_1:DisplayObjectContainer):void
        {
            this._psychicBar.enter();
            this._customPropBar.enter();
            this._propBar.enter();
            if (this._tweenMax)
            {
                this._tweenMax.play();
            };
            super.enter(_arg_1);
        }

        override public function leaving(_arg_1:Function=null):void
        {
            if (this._tweenMax)
            {
                this._tweenMax.pause();
            };
            super.leaving(_arg_1);
        }

        override public function tweenIn():void
        {
            if (_container)
            {
                _container.addChild(this);
            };
            y = 600;
            TweenLite.to(this, 0.3, {
                "y":503,
                "onComplete":this.enterComplete
            });
        }

        override protected function enterComplete():void
        {
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._fastChatBtn);
            this._fastChatBtn = null;
            ObjectUtils.disposeObject(this._faceBtn);
            this._faceBtn = null;
            ObjectUtils.disposeObject(this._fastMovie);
            this._fastMovie = null;
            ObjectUtils.disposeObject(this._facePanel);
            this._facePanel = null;
            ObjectUtils.disposeObject(this._psychicBar);
            this._psychicBar = null;
            ObjectUtils.disposeObject(this._customPropBar);
            this._customPropBar = null;
            ObjectUtils.disposeObject(this._propBar);
            this._propBar = null;
            if (this._msgShape)
            {
                TweenLite.killTweensOf(this._msgShape);
            };
            ObjectUtils.disposeObject(this._msgShape);
            this._msgShape = null;
            if (this._tweenMax)
            {
                this._tweenMax.kill();
            };
            this._tweenMax = null;
            super.dispose();
        }


    }
}//package game.view.control

