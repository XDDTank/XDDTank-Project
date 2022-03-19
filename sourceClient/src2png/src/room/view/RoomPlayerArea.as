// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.RoomPlayerArea

package room.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.ShowTipManager;
    import flash.display.DisplayObject;

    public class RoomPlayerArea extends Sprite implements Disposeable, ITipedDisplay 
    {

        protected var _tipData:Object;
        protected var _tipDirection:String;
        protected var _tipGapH:int;
        protected var _tipGapV:int;
        protected var _tipStyle:String;

        public function RoomPlayerArea()
        {
            this.addTip();
        }

        private function addTip():void
        {
            this.tipDirctions = "2,7";
            this.tipGapV = 0;
            this.tipStyle = "ddtroom.RoomPlayerItemIip";
            ShowTipManager.Instance.addTip(this);
        }

        public function get tipDirctions():String
        {
            return (this._tipDirection);
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDirection = _arg_1;
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipGapH(_arg_1:int):void
        {
            this._tipGapH = _arg_1;
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function set tipGapV(_arg_1:int):void
        {
            this._tipGapV = _arg_1;
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = _arg_1;
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view

