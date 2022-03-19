// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.experience.ExpTweenManager

package game.view.experience
{
    import com.greensock.TimelineMax;
    import __AS3__.vec.Vector;
    import com.greensock.core.TweenCore;
    import __AS3__.vec.*;

    public class ExpTweenManager 
    {

        private static var _instance:ExpTweenManager;

        public var isPlaying:Boolean;
        private var _timeline:TimelineMax;
        private var _tweens:Vector.<TweenCore>;

        public function ExpTweenManager()
        {
            this.init();
        }

        public static function get Instance():ExpTweenManager
        {
            if ((!(_instance)))
            {
                _instance = new (ExpTweenManager)();
            };
            return (_instance);
        }


        private function init():void
        {
            this._timeline = new TimelineMax();
            this._timeline.autoRemoveChildren = true;
            this._timeline.stop();
            this._tweens = new Vector.<TweenCore>();
        }

        public function appendTween(_arg_1:TweenCore, _arg_2:Number=0, _arg_3:Object=null):void
        {
            this._tweens.push(_arg_1);
            this._timeline.append(_arg_1, _arg_2);
            if (_arg_3 != null)
            {
                if (((!(_arg_3.onStart == null)) && (!(_arg_3.onStartParams == null))))
                {
                    _arg_1.vars.onStart = _arg_3.onStart;
                    _arg_1.vars.onStartParams = _arg_3.onStartParams;
                }
                else
                {
                    if (_arg_3.onStart != null)
                    {
                        _arg_1.vars.onStart = _arg_3.onStart;
                    };
                };
                if (((!(_arg_3.onComplete == null)) && (!(_arg_3.onCompleteParams == null))))
                {
                    _arg_1.vars.onComplete = _arg_3.onComplete;
                    _arg_1.vars.onCompleteParams = _arg_3.onCompleteParams;
                }
                else
                {
                    if (_arg_3.onComplete != null)
                    {
                        _arg_1.vars.onComplete = _arg_3.onComplete;
                    };
                };
            };
        }

        public function startTweens():void
        {
            this._timeline.play();
        }

        public function completeTweens():void
        {
            this._timeline.timeScale = 100;
        }

        public function speedRecover():void
        {
            this._timeline.timeScale = 1;
        }

        public function deleteTweens():void
        {
            var _local_1:TweenCore;
            this._timeline.stop();
            while (this._tweens.length > 0)
            {
                _local_1 = this._tweens.shift();
                _local_1.kill();
                _local_1 = null;
            };
            this._tweens = new Vector.<TweenCore>();
            this._timeline.kill();
            this._timeline.clear();
            this._timeline.totalProgress = 0;
            this._timeline = new TimelineMax();
        }


    }
}//package game.view.experience

