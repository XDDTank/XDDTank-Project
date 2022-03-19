// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetBlessBar

package petsBag.view.item
{
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import com.greensock.TweenLite;
    import com.pickgliss.utils.ObjectUtils;

    public class PetBlessBar extends PetBaseBar 
    {

        private var _blessShine:MovieClip;

        public function PetBlessBar()
        {
            tipStyle = "petsBag.view.tip.PetBlessTip";
            tipDirctions = "0";
        }

        override public function set value(_arg_1:Number):void
        {
            super.value = _arg_1;
        }

        public function shine():void
        {
            if ((!(this._blessShine)))
            {
                this._blessShine = ComponentFactory.Instance.creat("asset.petsBag.petAdvanceFrame.blessShine");
                this._blessShine.y = (_maxBar.y + (_maxBar.height / 2));
                this._blessShine.addEventListener(Event.COMPLETE, this.__onComplete);
            };
            addChildAt(this._blessShine, (numChildren - 2));
            this._blessShine.gotoAndPlay(1);
            TweenLite.killTweensOf(this._blessShine);
            if (value == 0)
            {
                this.__onComplete(null);
                this._blessShine.x = _maxBar.x;
            }
            else
            {
                this._blessShine.x = ((_maxBar.x + _maxMask.width) - (_maxBar.width / 100));
                TweenLite.to(this._blessShine, 0.5, {"x":(_maxBar.x + _maxMask.width)});
            };
        }

        protected function __onComplete(_arg_1:Event):void
        {
            this._blessShine.stop();
            if (this._blessShine.parent)
            {
                this._blessShine.parent.removeChild(this._blessShine);
            };
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._blessShine)
            {
                this._blessShine.removeEventListener(Event.COMPLETE, this.__onComplete);
            };
            ObjectUtils.disposeObject(this._blessShine);
            this._blessShine = null;
        }


    }
}//package petsBag.view.item

