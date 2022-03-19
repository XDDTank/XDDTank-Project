// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.TipColorBlock

package ddt.view.tips
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;

    public class TipColorBlock extends Sprite 
    {

        private var sp:Sprite;
        private var colorBoard:Bitmap;

        public function TipColorBlock(_arg_1:uint)
        {
            addChild(ComponentFactory.Instance.creat("asset.core.tip.color"));
            this.colorBoard = ComponentFactory.Instance.creat("asset.core.tip.ColorPiece");
            addChild(this.colorBoard);
            this.sp = new Sprite();
            this.sp.graphics.clear();
            this.sp.graphics.beginFill(_arg_1, 1);
            this.sp.graphics.drawRect(0, 0, 14, 14);
            this.sp.graphics.endFill();
            this.sp.x = (this.colorBoard.x + 1);
            this.sp.y = (this.colorBoard.y + 1);
            addChild(this.sp);
        }

        public function move(_arg_1:Number, _arg_2:Number):void
        {
            this.x = _arg_1;
            this.y = _arg_2;
        }

        public function dispose():void
        {
            if (parent)
            {
                removeChild(this.sp);
                removeChild(this.colorBoard);
                this.sp = null;
                this.colorBoard = null;
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

