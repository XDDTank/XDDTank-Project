// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.PetBaseFrame

package petsBag.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentFactory;

    public class PetBaseFrame extends Frame 
    {

        protected var _helpTextStyle:String;
        protected var _helpTextPos:*;

        public function PetBaseFrame()
        {
            this._helpTextPos = "petsBag.view.baseView.helpPos";
        }

        protected function __helpClick(_arg_1:MouseEvent):void
        {
            onResponse(FrameEvent.HELP_CLICK);
        }

        public function showHelp():void
        {
            var _local_1:PetHelpFrame = ComponentFactory.Instance.creat("petsBag.frame.HelpFrame");
            if (this._helpTextStyle)
            {
                _local_1.setView(ComponentFactory.Instance.creat(this._helpTextStyle), this._helpTextPos);
            };
            _local_1.show();
        }

        override public function dispose():void
        {
            super.dispose();
        }

        public function get helpTextStyle():String
        {
            return (this._helpTextStyle);
        }

        public function set helpTextStyle(_arg_1:String):void
        {
            this._helpTextStyle = _arg_1;
        }

        public function get helpTextPos():*
        {
            return (this._helpTextPos);
        }

        public function set helpTextPos(_arg_1:*):void
        {
            this._helpTextPos = _arg_1;
        }


    }
}//package petsBag.view

