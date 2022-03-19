// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.SimpleDataAlert

package ddt.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;

    public class SimpleDataAlert extends BaseAlerFrame 
    {

        public var alertData:*;


        override public function dispose():void
        {
            super.dispose();
            this.alertData = null;
        }


    }
}//package ddt.view

