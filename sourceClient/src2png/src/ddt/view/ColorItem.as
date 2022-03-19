// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.ColorItem

package ddt.view
{
    import com.pickgliss.ui.controls.SelectedButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;

    public class ColorItem extends SelectedButton 
    {

        private var _color:uint;
        private var _over:Bitmap;


        public function setup(_arg_1:uint):void
        {
            this._color = _arg_1;
            this.init();
            this.initEvent();
        }

        override protected function init():void
        {
            super.init();
            graphics.beginFill(this._color, 0);
            graphics.drawRect(0, 0, 16, 16);
            graphics.endFill();
            this._over = ComponentFactory.Instance.creatBitmap("asset.ddtshop.ColorItemOver");
            this._over.x = -1;
            this._over.y = 4;
            this._over.visible = false;
            addChild(this._over);
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        private function removeEvents():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            this._over.visible = true;
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            this._over.visible = false;
        }

        public function getColor():uint
        {
            return (this._color);
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvents();
            if (this._over.parent)
            {
                this._over.parent.removeChild(this._over);
            };
        }


    }
}//package ddt.view

