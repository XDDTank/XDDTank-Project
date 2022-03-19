// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.control.MouseStateAccieve

package game.view.control
{
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.display.Bitmap;
    import game.model.LocalPlayer;
    import ddt.data.PathInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.events.GameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.ChatManager;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SoundManager;
    import ddt.manager.CusCursorManager;
    import com.pickgliss.utils.ObjectUtils;

    public class MouseStateAccieve extends ControlState 
    {

        public static const TIME:int = 15;
        public static const SHOW_TIME:int = 5;
        public static var MAX_LENGTH:int = 1450;

        private var _sprite:Sprite;
        private var _Origin:Point;
        private var _drag:Boolean;
        private var _currentPower:Bitmap;
        private var _point:Point;
        private var _currentTime:int;
        private var _force:int = 0;
        private var _slideChatView:Boolean = false;

        public function MouseStateAccieve(_arg_1:LocalPlayer)
        {
            super(_arg_1);
        }

        override protected function configUI():void
        {
            this._sprite = new Sprite();
            this._sprite.alpha = 0;
            this._sprite.graphics.beginFill(3276);
            this._sprite.graphics.drawRect(0, 0, PathInfo.GAME_WIDTH, PathInfo.GAME_HEIGHT);
            this._sprite.graphics.endFill();
            addChild(this._sprite);
            mouseEnabled = false;
            mouseChildren = false;
            this._currentPower = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.currentPowerPoint.png");
            this._currentPower.visible = false;
            addChild(this._currentPower);
            super.configUI();
        }

        override protected function addEvent():void
        {
            _self.addEventListener(GameEvent.MOUSE_MODEL_DOWN, this.__startDrag);
            _self.addEventListener(GameEvent.MOUSE_MODEL_OUT, this.__mouseOutPlayer);
            addEventListener(MouseEvent.MOUSE_UP, this.__mouseUp);
            addEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
        }

        private function __startDrag(_arg_1:GameEvent):void
        {
            if (((!(this._slideChatView)) && (ChatManager.Instance.view.currentType)))
            {
                ChatManager.Instance.view.currentType = false;
                this._slideChatView = true;
            };
            this._point = new Point(mouseX, mouseY);
            this._drag = true;
            this._force = 0;
            _self.force = this._force;
            mouseEnabled = true;
            this._sprite.mouseEnabled = true;
            this._sprite.mouseChildren = true;
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__timerSeconds);
            this._currentTime = 0;
        }

        private function __timerSeconds(_arg_1:TimeEvents):void
        {
            if ((TIME - this._currentTime) == SHOW_TIME)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.mouseState.timeless", SHOW_TIME));
            }
            else
            {
                if (TIME == this._currentTime)
                {
                    this.__mouseUp(null);
                };
            };
            this._currentTime++;
        }

        private function __mouseOutPlayer(_arg_1:GameEvent):void
        {
            this._sprite.graphics.clear();
            this._sprite.graphics.beginFill(3276);
            this._sprite.graphics.drawRect(0, 0, PathInfo.GAME_WIDTH, PathInfo.GAME_HEIGHT);
            this._sprite.graphics.endFill();
        }

        private function __mouseUp(_arg_1:MouseEvent):void
        {
            if (((this._slideChatView) && (!(ChatManager.Instance.view.currentType))))
            {
                ChatManager.Instance.view.currentType = true;
                this._slideChatView = false;
            };
            this._drag = false;
            this._currentPower.visible = false;
            _self.dispatchEvent(new GameEvent(GameEvent.MOUSE_MODEL_UP));
            _self.sendShootAction(this._force);
            mouseEnabled = false;
            this._sprite.mouseEnabled = false;
            this._sprite.mouseChildren = false;
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__timerSeconds);
        }

        private function __mouseMove(_arg_1:MouseEvent):void
        {
            var _local_2:Number;
            var _local_3:int;
            if (this._drag)
            {
                SoundManager.instance.play("006");
                _local_2 = Math.atan2((this._point.y - CusCursorManager.instance.currentY), Math.abs((CusCursorManager.instance.currentX - this._point.x)));
                _local_3 = int(Math.round(((_local_2 * 180) / Math.PI)));
                if ((((_self.direction == -1) && ((CusCursorManager.instance.currentX - this._point.x) > 0)) || ((_self.direction == 1) && ((CusCursorManager.instance.currentX - this._point.x) < 0))))
                {
                    _local_3 = (180 - _local_3);
                };
                if (((_self.direction == -1) && (!(_self.isLockAngle))))
                {
                    _self.gunAngle = (_local_3 + (_self.playerAngle * _self.direction));
                }
                else
                {
                    if (((_self.direction == 1) && (!(_self.isLockAngle))))
                    {
                        _self.gunAngle = ((_local_3 + (_self.playerAngle * _self.direction)) - 1);
                    };
                };
                this.accountPower();
            };
        }

        private function accountPower():Boolean
        {
            var _local_1:Point = new Point(CusCursorManager.instance.currentX, CusCursorManager.instance.currentY);
            var _local_2:Number = (Point.distance(this._point, _local_1) * 5);
            this._force = ((_local_2 / MAX_LENGTH) * 2000);
            this._force = ((this._force > 2000) ? 2000 : this._force);
            _self.force = this._force;
            return (!((0 > _local_2) || (_local_2 > MAX_LENGTH)));
        }

        override protected function removeEvent():void
        {
            _self.removeEventListener(GameEvent.MOUSE_MODEL_DOWN, this.__startDrag);
            _self.removeEventListener(GameEvent.MOUSE_MODEL_OUT, this.__mouseOutPlayer);
            removeEventListener(MouseEvent.MOUSE_UP, this.__mouseUp);
            removeEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__timerSeconds);
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeObject(this._currentPower);
            this._currentPower = null;
            this._point = null;
            ObjectUtils.disposeObject(this._sprite);
            this._sprite = null;
        }


    }
}//package game.view.control

