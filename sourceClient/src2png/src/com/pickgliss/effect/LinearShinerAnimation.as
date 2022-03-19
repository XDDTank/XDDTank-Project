// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.effect.LinearShinerAnimation

package com.pickgliss.effect
{
    import com.greensock.TweenMax;
    import flash.display.DisplayObjectContainer;
    import com.greensock.easing.Sine;

    public class LinearShinerAnimation extends AlphaShinerAnimation 
    {

        public function LinearShinerAnimation(_arg_1:int)
        {
            super(_arg_1);
        }

        override public function play():void
        {
            if (TweenMax.isTweening(_maskShape))
            {
                return;
            };
            DisplayObjectContainer(target).addChildAt(_shineAnimationContainer, 0);
            if (_isLoop)
            {
                TweenMax.to(_maskShape, _shineMoveSpeed, {
                    "startAt":{"alpha":0},
                    "alpha":1,
                    "yoyo":true,
                    "repeat":-1,
                    "ease":Sine.easeOut
                });
            }
            else
            {
                TweenMax.to(_maskShape, _shineMoveSpeed, {
                    "startAt":{"alpha":0},
                    "alpha":1,
                    "ease":Sine.easeOut
                });
            };
        }


    }
}//package com.pickgliss.effect

