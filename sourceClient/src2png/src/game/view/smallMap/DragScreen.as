// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.smallMap.DragScreen

package game.view.smallMap
{
    import flash.display.Sprite;
    import flash.display.Graphics;

    public class DragScreen extends Sprite 
    {

        private var _w:int = 60;
        private var _h:int = 60;

        public function DragScreen(_arg_1:int, _arg_2:int)
        {
            this._w = ((_arg_1 < 1) ? 1 : _arg_1);
            this._h = ((_arg_2 < 1) ? 1 : _arg_2);
            buttonMode = true;
            this.drawBackground();
        }

        override public function set y(_arg_1:Number):void
        {
            super.y = _arg_1;
        }

        private function drawBackground():void
        {
            var _local_1:Graphics = graphics;
            _local_1.clear();
            _local_1.lineStyle(1, 0x999999);
            _local_1.beginFill(0xFFFFFF, 0.4);
            _local_1.drawRect(0, 0, this._w, this._h);
            _local_1.endFill();
        }

        override public function set width(_arg_1:Number):void
        {
            if (this._w != _arg_1)
            {
                this._w = ((_arg_1 < 1) ? 1 : _arg_1);
                this.drawBackground();
            };
        }

        override public function set height(_arg_1:Number):void
        {
            if (this._h != _arg_1)
            {
                this._h = ((_arg_1 < 1) ? 1 : _arg_1);
                this.drawBackground();
            };
        }

        public function dispose():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.smallMap

