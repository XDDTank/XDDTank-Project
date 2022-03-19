// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.info.GlowPropButton

package bagAndInfo.info
{
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;

    public class GlowPropButton extends PropButton 
    {

        private var _showOverGraphics:Boolean = true;

        public function GlowPropButton()
        {
            this.addEvent();
            _tipStyle = "core.ChatacterPropTxtTips";
        }

        public function get showOverGraphics():Boolean
        {
            return (this._showOverGraphics);
        }

        public function set showOverGraphics(_arg_1:Boolean):void
        {
            this._showOverGraphics = _arg_1;
        }

        override protected function addChildren():void
        {
            if ((!(_back)))
            {
                _back = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.background_propbutton");
                addChild(_back);
            };
        }

        private function addEvent():void
        {
            addEventListener(MouseEvent.ROLL_OVER, this.__onMouseRollover);
            addEventListener(MouseEvent.ROLL_OUT, this.__onMouseRollout);
        }

        private function __onMouseRollover(_arg_1:MouseEvent):void
        {
        }

        private function __onMouseRollout(_arg_1:MouseEvent):void
        {
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.ROLL_OVER, this.__onMouseRollover);
            removeEventListener(MouseEvent.ROLL_OUT, this.__onMouseRollout);
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
        }


    }
}//package bagAndInfo.info

