// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.gametrainer.view.QuestionOverView

package game.gametrainer.view
{
    import com.pickgliss.ui.controls.Frame;
    import game.gametrainer.TrainerEvent;
    import ddt.manager.SoundManager;
    import org.aswing.KeyboardManager;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;

    public class QuestionOverView extends Frame 
    {

        public function QuestionOverView()
        {
            this.initView();
        }

        private function initView():void
        {
            this.moveEnable = false;
            this.dispatchEvent(new TrainerEvent(TrainerEvent.CLOSE_FRAME));
        }

        public function set gotoAndStopTip(_arg_1:int):void
        {
        }

        private function __okFunction():void
        {
            SoundManager.instance.play("008");
            this.dispatchEvent(new TrainerEvent(TrainerEvent.CLOSE_FRAME));
        }

        protected function __onKeyDownd(_arg_1:KeyboardEvent):void
        {
            KeyboardManager.getInstance().reset();
            if (_arg_1.keyCode != Keyboard.ESCAPE)
            {
                return;
            };
            _arg_1.stopImmediatePropagation();
            this.dispatchEvent(new TrainerEvent(TrainerEvent.CLOSE_FRAME));
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package game.gametrainer.view

