// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.TimeTip

package ddt.view.bossbox
{
    import com.pickgliss.ui.core.TransformableComponent;
    import flash.display.Sprite;
    import com.pickgliss.utils.ObjectUtils;

    public class TimeTip extends TransformableComponent 
    {

        private var _closeBox:Sprite;
        private var _delayText:Sprite;


        public function setView(_arg_1:Sprite, _arg_2:Sprite):void
        {
            this._closeBox = _arg_1;
            this._delayText = _arg_2;
            addChild(this._closeBox);
        }

        public function get closeBox():Sprite
        {
            return (this._closeBox);
        }

        public function get delayText():Sprite
        {
            return (this._delayText);
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._closeBox)
            {
                ObjectUtils.disposeObject(this._closeBox);
            };
            this._closeBox = null;
            if (this._delayText)
            {
                ObjectUtils.disposeObject(this._delayText);
            };
            this._delayText = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.bossbox

