// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.FightAchievBar

package game.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import flash.utils.getTimer;
    import __AS3__.vec.*;

    public class FightAchievBar extends Sprite implements Disposeable 
    {

        private var _animates:Vector.<AchieveAnimation> = new Vector.<AchieveAnimation>();
        private var _displays:Vector.<AchieveAnimation> = new Vector.<AchieveAnimation>();
        private var _started:Boolean = false;


        public function dispose():void
        {
            removeEventListener(Event.ENTER_FRAME, this.__onFrame);
        }

        public function addAnimate(_arg_1:AchieveAnimation):void
        {
            this._animates.push(_arg_1);
            if (_arg_1.interval <= 0)
            {
                this.playAnimate(_arg_1);
            };
            if ((!(this._started)))
            {
                addEventListener(Event.ENTER_FRAME, this.__onFrame);
                this._started = true;
            };
        }

        private function playAnimate(_arg_1:AchieveAnimation):void
        {
            var _local_2:AchieveAnimation;
            _arg_1.play();
            addChild(_arg_1);
            _arg_1.addEventListener(Event.COMPLETE, this.__animateComplete);
            this._displays.unshift(_arg_1);
            if (this._displays.length > 4)
            {
                _local_2 = this._displays.pop();
                this.removeAnimate(_local_2);
                ObjectUtils.disposeObject(_local_2);
            };
            this.drawLayer();
        }

        private function __animateComplete(_arg_1:Event):void
        {
            var _local_2:AchieveAnimation = (_arg_1.currentTarget as AchieveAnimation);
            _local_2.removeEventListener(Event.COMPLETE, this.__animateComplete);
            this.removeAnimate(_local_2);
            ObjectUtils.disposeObject(_local_2);
        }

        private function __onFrame(_arg_1:Event):void
        {
            var _local_3:AchieveAnimation;
            var _local_2:int = getTimer();
            for each (_local_3 in this._animates)
            {
                if (((!(_local_3.show)) && (_local_3.delay >= _local_2)))
                {
                    this.playAnimate(_local_3);
                };
            };
        }

        public function removeAnimate(_arg_1:AchieveAnimation):void
        {
            var _local_2:int = this._animates.indexOf(_arg_1);
            if (_local_2 >= 0)
            {
                this._animates.splice(_local_2, 1);
            };
            if (_arg_1.show)
            {
                _local_2 = this._displays.indexOf(_arg_1);
                if (_local_2 >= 0)
                {
                    this._displays.splice(_local_2, 1);
                };
            };
            if (this._animates.length <= 0)
            {
                removeEventListener(Event.ENTER_FRAME, this.__onFrame);
                this._started = false;
            };
        }

        public function rePlayAnimate(_arg_1:AchieveAnimation):void
        {
        }

        public function getAnimate(_arg_1:int):AchieveAnimation
        {
            var _local_2:AchieveAnimation;
            for each (_local_2 in this._animates)
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        private function drawLayer():void
        {
            var _local_1:int = this._displays.length;
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                if (_local_2 == 0)
                {
                    this._displays[_local_2].y = -(this._displays[_local_2].height);
                }
                else
                {
                    this._displays[_local_2].y = ((this._displays[(_local_2 - 1)].y - this._displays[_local_2].height) - 4);
                };
                _local_2++;
            };
        }


    }
}//package game.view

