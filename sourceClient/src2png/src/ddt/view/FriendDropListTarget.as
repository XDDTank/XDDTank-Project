// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.FriendDropListTarget

package ddt.view
{
    import com.pickgliss.ui.controls.SimpleDropListTarget;

    public class FriendDropListTarget extends SimpleDropListTarget 
    {


        override public function setValue(_arg_1:*):void
        {
            if (_arg_1)
            {
                text = _arg_1.NickName;
            };
        }


    }
}//package ddt.view

