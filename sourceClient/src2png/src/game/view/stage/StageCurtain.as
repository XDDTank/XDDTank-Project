// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.stage.StageCurtain

package game.view.stage
{
    import flash.display.Sprite;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.Event;

    public class StageCurtain extends Sprite 
    {

        private var _playTime:uint;
        private var _duration:uint;
        private var _life:uint;

        public function StageCurtain()
        {
            this.initView();
        }

        private function initView():void
        {
            visible = false;
            graphics.clear();
            graphics.beginFill(0);
            graphics.drawRect(0, 0, 2000, 2000);
        }

        public function fadeIn(_arg_1:uint=25):void
        {
            StageReferance.stage.addChild(this);
            visible = true;
            alpha = 0;
            this._duration = _arg_1;
            this._life = 0;
            addEventListener(Event.ENTER_FRAME, this.__updateFadeIn);
        }

        public function fadeOut(_arg_1:uint=25):void
        {
            StageReferance.stage.addChild(this);
            visible = true;
            alpha = 1;
            this._duration = _arg_1;
            this._life = 0;
            addEventListener(Event.ENTER_FRAME, this.__updateFadeOut);
        }

        private function __updateFadeIn(_arg_1:Event):void
        {
            if (this._life == this._duration)
            {
                dispatchEvent(new Event("fadein"));
                removeEventListener(Event.ENTER_FRAME, this.__updateFadeIn);
                alpha = 1;
                this.end();
            };
            var _local_2:Number = (this._life / this._duration);
            alpha = _local_2;
            this._life++;
        }

        private function __updateFadeOut(_arg_1:Event):void
        {
            if (this._life == this._duration)
            {
                dispatchEvent(new Event("fadeout"));
                removeEventListener(Event.ENTER_FRAME, this.__updateFadeOut);
                alpha = 0;
                this.end();
            };
            var _local_2:Number = (this._life / this._duration);
            alpha = (1 - _local_2);
            this._life++;
        }

        private function end():void
        {
            this.parent.removeChild(this);
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function play(_arg_1:uint=25):void
        {
            StageReferance.stage.addChild(this);
            visible = true;
            alpha = 0;
            this._duration = _arg_1;
            this._life = 0;
            addEventListener(Event.ENTER_FRAME, this.__updatePlay);
        }

        private function __updatePlay(_arg_1:Event):void
        {
            if (this._life == this._duration)
            {
                removeEventListener(Event.ENTER_FRAME, this.__updatePlay);
                alpha = 0;
                this.end();
            };
            var _local_2:Number = (this._life / this._duration);
            if (_local_2 < 0.2)
            {
                alpha = (_local_2 / 0.2);
            }
            else
            {
                alpha = (1 - (_local_2 / 0.8));
            };
            this._life++;
        }


    }
}//package game.view.stage

