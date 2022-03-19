// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.TipItemView

package roomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class TipItemView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _bgII:ScaleLeftRightImage;
        private var _value:int;
        private var _cellWidth:int;
        private var _cellheight:int;

        public function TipItemView(_arg_1:Bitmap, _arg_2:int, _arg_3:int, _arg_4:int)
        {
            this._value = _arg_2;
            this._bg = _arg_1;
            this._cellWidth = _arg_3;
            this._cellheight = _arg_4;
            super();
            this.init();
        }

        private function init():void
        {
            this.buttonMode = true;
            this._bg.x = ((this._cellWidth / 2) - (this._bg.width / 2));
            this._bgII = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.itemredbg");
            this._bgII.width = this._cellWidth;
            this._bgII.height = this._cellheight;
            this._bgII.mouseChildren = false;
            this._bgII.mouseEnabled = false;
            this._bgII.visible = false;
            addChild(this._bgII);
            addChild(this._bg);
            addEventListener(MouseEvent.MOUSE_OVER, this.__itemOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__itemOut);
        }

        protected function __itemOut(_arg_1:MouseEvent):void
        {
            this._bgII.visible = false;
        }

        protected function __itemOver(_arg_1:MouseEvent):void
        {
            this._bgII.visible = true;
        }

        public function get value():int
        {
            return (this._value);
        }

        public function dispose():void
        {
            if (this._bgII)
            {
                ObjectUtils.disposeObject(this._bgII);
                this._bgII = null;
            };
            if (((this._bg) && (this._bg.bitmapData)))
            {
                this._bg.bitmapData.dispose();
                this._bg = null;
            };
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package roomList

