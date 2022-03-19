// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.churchFire.ChurchFireEffectPlayer

package church.view.churchFire
{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import com.pickgliss.utils.ClassUtils;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import flash.events.TimerEvent;

    public class ChurchFireEffectPlayer extends Sprite 
    {

        public static const FIER_TIMER:int = 3500;

        private var _fireTemplateID:int;
        private var _fireMovie:MovieClip;
        private var _playerFramesCount:int = 0;
        private var _playerTimer:Timer;
        public var owerID:int;

        public function ChurchFireEffectPlayer(_arg_1:int)
        {
            this._fireTemplateID = _arg_1;
            this.addFire();
            super();
        }

        private function addFire():void
        {
            var _local_1:String = "";
            switch (this._fireTemplateID)
            {
                case 21002:
                    _local_1 = "tank.church.fireAcect.FireItemAccect02";
                    break;
                case 21006:
                    _local_1 = "tank.church.fireAcect.FireItemAccect06";
                    break;
            };
            if ((((!(_local_1)) || (_local_1 == "")) || (_local_1.length <= 0)))
            {
                return;
            };
            var _local_2:Class = (ClassUtils.uiSourceDomain.getDefinition(_local_1) as Class);
            if (_local_2)
            {
                this._fireMovie = (new (_local_2)() as MovieClip);
                if (this._fireMovie)
                {
                    addChild(this._fireMovie);
                };
            };
        }

        public function firePlayer(_arg_1:Boolean=true):void
        {
            if (_arg_1)
            {
                SoundManager.instance.play("117");
            };
            if (this._fireMovie)
            {
                this._fireMovie.gotoAndPlay(1);
                this._fireMovie.addEventListener(Event.ENTER_FRAME, this.enterFrameHander);
                this._playerFramesCount = 0;
                this._playerTimer = new Timer(FIER_TIMER, 0);
                this._playerTimer.start();
                this._playerTimer.addEventListener(TimerEvent.TIMER, this.timerHander);
            }
            else
            {
                this.removeFire();
            };
        }

        public function removeFire():void
        {
            if (this._fireMovie)
            {
                if (this._fireMovie.parent)
                {
                    this._fireMovie.parent.removeChild(this._fireMovie);
                };
                this._fireMovie.removeEventListener(Event.ENTER_FRAME, this.enterFrameHander);
                this._fireMovie = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function timerHander(_arg_1:TimerEvent):void
        {
            if (this._playerTimer)
            {
                this._playerTimer.removeEventListener(TimerEvent.TIMER, this.timerHander);
                this._playerTimer.stop();
                this._playerTimer = null;
            };
            this.removeFire();
        }

        private function enterFrameHander(_arg_1:Event):void
        {
            this._playerFramesCount++;
            if (this._playerFramesCount >= this._fireMovie.totalFrames)
            {
                this.removeFire();
            };
        }

        public function dispose():void
        {
            if (this._fireMovie)
            {
                this._fireMovie.removeEventListener(Event.ENTER_FRAME, this.enterFrameHander);
            };
            this._fireMovie = null;
            if (this._playerTimer)
            {
                this._playerTimer.removeEventListener(TimerEvent.TIMER, this.timerHander);
                this._playerTimer.stop();
            };
            this._playerTimer = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package church.view.churchFire

