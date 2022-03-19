// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.ShowEffect

package game.view.effects
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import flash.display.MovieClip;

    public class ShowEffect extends Sprite implements Disposeable 
    {

        public static var GUARD:String = "guard";

        private var _type:String;
        private var _pic:DisplayObject;
        private var tmp:int = 0;
        private var add:Boolean = true;

        public function ShowEffect(_arg_1:String)
        {
            this._type = _arg_1;
            this.init();
        }

        private function init():void
        {
            this.initPicture();
            addChild(this._pic);
            addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
        }

        private function enterFrameHandler(_arg_1:Event):void
        {
            if (this._pic.alpha > 0.95)
            {
                this.tmp++;
                if (this.tmp == 20)
                {
                    this.add = false;
                    this._pic.alpha = 0.9;
                };
            };
            if (this._pic.alpha < 1)
            {
                if (this.add)
                {
                    this._pic.y = (this._pic.y - 8);
                    this._pic.alpha = (this._pic.alpha + 0.22);
                }
                else
                {
                    this._pic.y = (this._pic.y - 6);
                    this._pic.alpha = (this._pic.alpha - 0.1);
                };
            };
            if (this._pic.alpha < 0.05)
            {
                this.dispose();
            };
        }

        private function initPicture():void
        {
            switch (this._type)
            {
                case GUARD:
                    this._pic = (ComponentFactory.Instance.creatBitmap("asset.game.guardAsset") as Bitmap);
                    return;
                default:
                    this._pic = new MovieClip();
            };
        }

        public function dispose():void
        {
            removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            if (parent)
            {
                parent.removeChild(this);
            };
            this._pic = null;
        }


    }
}//package game.view.effects

