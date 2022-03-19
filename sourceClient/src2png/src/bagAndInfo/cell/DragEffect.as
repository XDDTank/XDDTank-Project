// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.cell.DragEffect

package bagAndInfo.cell
{
    import ddt.interfaces.IDragable;
    import ddt.interfaces.IAcceptDrag;

    public class DragEffect 
    {

        public static const NONE:String = "none";
        public static const MOVE:String = "move";
        public static const LINK:String = "link";
        public static const SPLIT:String = "split";

        public var source:IDragable;
        public var target:IAcceptDrag;
        public var action:String;
        public var data:*;

        public function DragEffect(_arg_1:IDragable, _arg_2:*, _arg_3:String="none", _arg_4:IAcceptDrag=null)
        {
            this.source = _arg_1;
            this.target = _arg_4;
            this.action = _arg_3;
            this.data = _arg_2;
        }

        public function get hasAccpeted():Boolean
        {
            return (!(this.target == null));
        }


    }
}//package bagAndInfo.cell

