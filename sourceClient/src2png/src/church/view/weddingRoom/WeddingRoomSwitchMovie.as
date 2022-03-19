// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoom.WeddingRoomSwitchMovie

package church.view.weddingRoom
{
    import flash.display.Sprite;
    import flash.events.Event;

    public class WeddingRoomSwitchMovie extends Sprite 
    {

        public static const SWITCH_COMPLETE:String = "switch complete";

        private const SHOW:String = "mask show";
        private const HIDE:String = "mask hide";

        private var _currentStatus:String;
        private var _sprite:Sprite;
        private var _autoClear:Boolean;
        private var _speed:Number;

        public function WeddingRoomSwitchMovie(_arg_1:Boolean, _arg_2:Number=0.02)
        {
            this._autoClear = _arg_1;
            this._speed = _arg_2;
            this.init();
        }

        private function init():void
        {
            this._sprite = new Sprite();
            this._sprite.graphics.beginFill(0);
            this._sprite.graphics.drawRect(-1000, -1000, 3000, 2600);
            this._sprite.graphics.endFill();
            this._sprite.alpha = 0;
            addChild(this._sprite);
            this._currentStatus = this.SHOW;
        }

        public function playMovie():void
        {
            addEventListener(Event.ENTER_FRAME, this.__enterFrame);
        }

        private function __enterFrame(_arg_1:Event):void
        {
            if (this._currentStatus == this.SHOW)
            {
                this._sprite.alpha = (this._sprite.alpha + this._speed);
                if (this._sprite.alpha >= 1)
                {
                    this._currentStatus = this.HIDE;
                    dispatchEvent(new Event(WeddingRoomSwitchMovie.SWITCH_COMPLETE));
                };
            }
            else
            {
                if (this._currentStatus == this.HIDE)
                {
                    this._sprite.alpha = (this._sprite.alpha - this._speed);
                    if (this._sprite.alpha <= 0)
                    {
                        this._currentStatus = this.SHOW;
                        removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
                        if (this._autoClear)
                        {
                            this.dispose();
                        };
                    };
                };
            };
        }

        public function dispose():void
        {
            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            if (((this._sprite) && (this._sprite.parent)))
            {
                this._sprite.parent.removeChild(this._sprite);
            };
            this._sprite = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package church.view.weddingRoom

