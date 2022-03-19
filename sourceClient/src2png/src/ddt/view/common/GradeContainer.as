// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.GradeContainer

package ddt.view.common
{
    import flash.display.Sprite;
    import flash.utils.Timer;
    import flash.display.MovieClip;
    import flash.events.TimerEvent;
    import com.pickgliss.utils.ClassUtils;

    public class GradeContainer extends Sprite 
    {

        private var _timer:Timer;
        private var _grade:MovieClip;
        private var _topLayer:Boolean;

        public function GradeContainer(_arg_1:Boolean=false)
        {
            this._topLayer = _arg_1;
            this.init();
        }

        private function init():void
        {
            this._timer = new Timer(6000, 1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
        }

        private function __timerComplete(_arg_1:TimerEvent):void
        {
            this.clearGrade();
        }

        public function clearGrade():void
        {
            if (this._grade != null)
            {
                if (this._grade.parent)
                {
                    this._grade.stop();
                    this._grade["lv_mc"]["lv_mc_init"]["video"].clear();
                    this._grade.parent.removeChild(this._grade);
                };
                this._grade = null;
            };
            if (this._timer)
            {
                this._timer.stop();
            };
        }

        public function setGrade(_arg_1:MovieClip):void
        {
            this.clearGrade();
            this._grade = _arg_1;
            if (this._grade != null)
            {
                this._timer.reset();
                this._timer.start();
                addChild(this._grade);
            };
        }

        public function playerGrade():void
        {
            var _local_1:Class = (ClassUtils.uiSourceDomain.getDefinition("asset.core.playerLevelUpFaileAsset") as Class);
            var _local_2:MovieClip = (new (_local_1)() as MovieClip);
            this.setGrade(_local_2);
        }

        public function dispose():void
        {
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
            this._timer = null;
            this.clearGrade();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.common

