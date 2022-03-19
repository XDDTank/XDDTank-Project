// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityDetailButton

package activity.view
{
    import com.pickgliss.ui.controls.BaseButton;
    import com.greensock.TweenMax;
    import com.pickgliss.utils.DisplayUtils;

    public class ActivityDetailButton extends BaseButton 
    {

        private var _state:int = 0;
        private var _tweenMax:TweenMax;


        public function set state(_arg_1:int):void
        {
            if (this._state == _arg_1)
            {
                return;
            };
            this._state = _arg_1;
            if (backgound)
            {
                DisplayUtils.setFrame(backgound, _arg_1);
                TweenMax.killChildTweensOf(this);
                backgound.filters = null;
                if (this._state == 1)
                {
                    backgound.x = 0;
                    this._tweenMax = TweenMax.to(backgound, 0.3, {
                        "x":6,
                        "repeat":-1,
                        "yoyo":true
                    });
                }
                else
                {
                    backgound.x = 6;
                    this._tweenMax = TweenMax.to(backgound, 0.3, {
                        "x":0,
                        "repeat":-1,
                        "yoyo":true
                    });
                };
            };
        }

        override public function dispose():void
        {
            TweenMax.killChildTweensOf(this);
            this._tweenMax = null;
            super.dispose();
        }

        public function get state():int
        {
            return (this._state);
        }

        override public function setFrame(_arg_1:int):void
        {
        }


    }
}//package activity.view

