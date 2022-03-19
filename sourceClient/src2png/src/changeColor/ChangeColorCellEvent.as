// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//changeColor.ChangeColorCellEvent

package changeColor
{
    import flash.events.Event;
    import bagAndInfo.cell.BagCell;

    public class ChangeColorCellEvent extends Event 
    {

        public static const CLICK:String = "changeColorCellClickEvent";
        public static const SETCOLOR:String = "setColor";

        private var _data:BagCell;

        public function ChangeColorCellEvent(_arg_1:String, _arg_2:BagCell, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this._data = _arg_2;
        }

        public function get data():BagCell
        {
            return (this._data);
        }


    }
}//package changeColor

