// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.utils.AutoDisappear

package road7th.utils
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import flash.utils.getTimer;
    import com.pickgliss.utils.ObjectUtils;

    public class AutoDisappear extends Sprite implements Disposeable 
    {

        private var _life:Number;
        private var _age:Number;
        private var _last:Number;

        public function AutoDisappear(_arg_1:DisplayObject, _arg_2:Number=-1)
        {
            if (((_arg_2 == -1) && (_arg_1 is MovieClip)))
            {
                this._life = (MovieClip(_arg_1).totalFrames * 40);
            }
            else
            {
                this._life = (_arg_2 * 1000);
            };
            this._age = 0;
            addChild(_arg_1);
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
        }

        private function __addToStage(_arg_1:Event):void
        {
            this._last = getTimer();
            addEventListener(Event.ENTER_FRAME, this.__enterFrame);
        }

        private function __enterFrame(_arg_1:Event):void
        {
            if (parent)
            {
                this._age = (this._age + (getTimer() - this._last));
                this._last = getTimer();
                if (this._age > this._life)
                {
                    parent.removeChild(this);
                    removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
                    this.dispatchEvent(new Event(Event.COMPLETE));
                };
            };
        }

        public function dispose():void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package road7th.utils

