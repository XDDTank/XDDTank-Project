// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.enthrall.EnthrallView

package ddt.view.enthrall
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import ddt.view.tips.OneLineTip;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import ddt.manager.EnthrallManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.TimeManager;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;

    public class EnthrallView extends Component 
    {

        public static const HALL_VIEW_STATE:uint = 0;
        public static const ROOMLIST_VIEW_STATE:uint = 1;
        public static const GAME_VIEW_STATE:uint = 2;

        private var _enthrall:ScaleFrameImage;
        private var _enthrallBall:ScaleFrameImage;
        private var _info:OneLineTip;
        private var _approveBtn:SimpleBitmapButton;
        private var _manager:EnthrallManager;


        public function set manager(_arg_1:EnthrallManager):void
        {
            this._manager = _arg_1;
            this.initUI();
        }

        private function initUI():void
        {
            this._enthrall = ComponentFactory.Instance.creat("core.view.enthrall.InfoNormal");
            this._enthrall.setFrame(1);
            addChild(this._enthrall);
            this._approveBtn = ComponentFactory.Instance.creat("core.view.enthrall.ValidateBtn");
            addChild(this._approveBtn);
            this._enthrallBall = ComponentFactory.Instance.creat("core.view.enthrall.InfoBall");
            this._info = new OneLineTip();
            this._info.x = 25;
            this._info.y = 35;
            this._info.tipData = LanguageMgr.GetTranslation("ddt.enthtall.tips");
            this._info.visible = false;
            addChild(this._info);
            this.addEvent();
        }

        private function addEvent():void
        {
            TimeManager.addEventListener(TimeManager.CHANGE, this.__changeHandler);
            this._enthrall.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            this._enthrall.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
            this._enthrallBall.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            this._enthrallBall.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
            this._approveBtn.addEventListener(MouseEvent.CLICK, this.popFrame);
        }

        private function popFrame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._manager.showCIDCheckerFrame();
        }

        public function update():void
        {
            this.upGameTimeStatus();
        }

        private function __changeHandler(_arg_1:Event):void
        {
            if (((this.parent == null) || (this.visible == false)))
            {
                return;
            };
            this.upGameTimeStatus();
        }

        private function __mouseOverHandler(_arg_1:MouseEvent):void
        {
            this.upGameTimeStatus();
            this._info.visible = true;
        }

        private function upGameTimeStatus():void
        {
            var _local_1:Number = TimeManager.Instance.enthrallTime;
            this.setViewState(_local_1);
        }

        private function getTimeTxt(_arg_1:Number):String
        {
            var _local_2:Number = Math.floor((_arg_1 / 60));
            var _local_3:Number = Math.floor((_arg_1 % 60));
            return (((_local_3 < 10) ? ((_local_2 + ":0") + _local_3) : ((_local_2 + ":") + _local_3)) + " / 5:00");
        }

        private function __mouseOutHandler(_arg_1:MouseEvent):void
        {
            this.setViewState(TimeManager.Instance.enthrallTime);
            this._info.visible = false;
        }

        private function setViewState(_arg_1:Number):void
        {
            var _local_2:Number = Math.floor(_arg_1);
            if (_local_2 < 180)
            {
                this._enthrall.setFrame(1);
                this._enthrallBall.setFrame(1);
            }
            else
            {
                if (_local_2 < 300)
                {
                    this._enthrall.setFrame(2);
                    this._enthrallBall.setFrame(2);
                }
                else
                {
                    if (_local_2 > 300)
                    {
                        this._enthrall.setFrame(3);
                        this._enthrallBall.setFrame(3);
                    };
                };
            };
        }

        public function show(_arg_1:EnthrallView):void
        {
            this.setViewState(TimeManager.Instance.enthrallTime);
        }

        public function changeBtn(_arg_1:Boolean):void
        {
            this._approveBtn.visible = _arg_1;
        }

        public function changeToGameState(_arg_1:Boolean):void
        {
            this._enthrallBall.visible = _arg_1;
            this._enthrall.visible = (!(_arg_1));
            this._approveBtn.visible = (!(_arg_1));
        }

        private function removeEvent():void
        {
            TimeManager.removeEventListener(TimeManager.CHANGE, this.__changeHandler);
            this._enthrall.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            this._enthrall.removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
            this._enthrallBall.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            this._enthrallBall.removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
            this._approveBtn.removeEventListener(MouseEvent.CLICK, this.popFrame);
        }

        override public function dispose():void
        {
        }

        public function get enthrall():ScaleFrameImage
        {
            return (this._enthrall);
        }


    }
}//package ddt.view.enthrall

