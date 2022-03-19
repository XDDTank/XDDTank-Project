// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.arrow.ArrowBg

package game.view.arrow
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;

    public class ArrowBg extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        public var arrowSub:ArrowSub;
        private var _ruling:Bitmap;

        public function ArrowBg()
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.game.angle.back");
            addChild(this._bg);
            this.arrowSub = (ComponentFactory.Instance.creatCustomObject("asset.game.arrowSub") as ArrowSub);
            addChild(this.arrowSub);
            this._ruling = ComponentFactory.Instance.creatBitmap("asset.game.angle.dail");
            addChild(this._ruling);
        }

        public function dispose():void
        {
            removeChild(this._bg);
            this._bg.bitmapData.dispose();
            this._bg = null;
            this.arrowSub.dispose();
            this.arrowSub = null;
            removeChild(this._ruling);
            this._ruling.bitmapData.dispose();
            this._ruling = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.arrow

