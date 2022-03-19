// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.changeSex.ChangeSexAlertFrame

package bagAndInfo.changeSex
{
    import com.pickgliss.ui.controls.alert.SimpleAlert;

    public class ChangeSexAlertFrame extends SimpleAlert 
    {

        private var _bagType:int;
        private var _place:int;


        public function get bagType():int
        {
            return (this._bagType);
        }

        public function set bagType(_arg_1:int):void
        {
            this._bagType = _arg_1;
        }

        public function get place():int
        {
            return (this._place);
        }

        public function set place(_arg_1:int):void
        {
            this._place = _arg_1;
        }


    }
}//package bagAndInfo.changeSex

