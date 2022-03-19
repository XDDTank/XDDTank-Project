// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//invite.view.NavButton

package invite.view
{
    import com.pickgliss.ui.controls.BaseButton;

    public class NavButton extends BaseButton 
    {

        private var _selected:Boolean = false;

        public function NavButton()
        {
            mouseChildren = false;
        }

        override protected function addEvent():void
        {
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._selected != _arg_1)
            {
                this._selected = _arg_1;
                if (this._selected)
                {
                    setFrame(2);
                }
                else
                {
                    setFrame(1);
                };
            };
        }


    }
}//package invite.view

