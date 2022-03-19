// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.PetBlessAddNumView

package ddt.view.bossbox
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import com.greensock.TweenLite;
    import com.pickgliss.utils.ObjectUtils;

    public class PetBlessAddNumView extends Sprite implements Disposeable 
    {

        private var _numMC:MovieClip;
        private var _currentNum:Number;
        private var _orginNum:int;
        private var _dstNum:int;
        private var _diff:Number;
        private var _frame:int;

        public function PetBlessAddNumView()
        {
            this._numMC = ComponentFactory.Instance.creat("asset.bagAndInfo.petBless.rightNumber");
            addChild(this._numMC);
        }

        protected function __onEnterFrame(_arg_1:Event):void
        {
            this._currentNum = (this._currentNum + this._diff);
            if (((this._currentNum - this._dstNum) * this._diff) >= 0)
            {
                this._currentNum = this._dstNum;
                removeEventListener(Event.ENTER_FRAME, this.__onEnterFrame);
                dispatchEvent(new Event(Event.COMPLETE));
            };
            this.setNum(this._numMC, this._currentNum);
        }

        private function setNum(_arg_1:MovieClip, _arg_2:int):void
        {
            var _local_3:int = int((_arg_2 / 100));
            var _local_4:int = int(((_arg_2 % 100) / 10));
            var _local_5:int = (_arg_2 % 10);
            _arg_1.num_1.gotoAndStop((_local_3 + 1));
            _arg_1.num_1.visible = (_local_3 > 0);
            _arg_1.num_2.gotoAndStop((_local_4 + 1));
            _arg_1.num_2.visible = (_local_4 > 0);
            _arg_1.num_3.gotoAndStop((_local_5 + 1));
        }

        public function TweenTo(origin:int, dst:int, frame:Number):void
        {
            this._orginNum = (this._currentNum = origin);
            this._dstNum = dst;
            this._frame = frame;
            this._diff = ((this._dstNum - this._orginNum) / this._frame);
            this._currentNum = origin;
            this.setNum(this._numMC, this._orginNum);
            alpha = 0;
            TweenLite.to(this, 0.2, {
                "alpha":1,
                "onComplete":function ():void
                {
                    addEventListener(Event.ENTER_FRAME, __onEnterFrame);
                }
            });
        }

        public function get currentNum():Number
        {
            return (this._currentNum);
        }

        public function dispose():void
        {
            removeEventListener(Event.ENTER_FRAME, this.__onEnterFrame);
            ObjectUtils.disposeObject(this._numMC);
            this._numMC = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.bossbox

