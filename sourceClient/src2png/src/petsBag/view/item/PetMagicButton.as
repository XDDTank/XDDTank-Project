// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetMagicButton

package petsBag.view.item
{
    import com.pickgliss.ui.controls.BaseButton;

    public class PetMagicButton extends BaseButton 
    {


        override public function set enable(_arg_1:Boolean):void
        {
            if (_enable == _arg_1)
            {
                return;
            };
            _enable = _arg_1;
            if (_enable)
            {
                setFrame(1);
            }
            else
            {
                setFrame(4);
            };
        }


    }
}//package petsBag.view.item

