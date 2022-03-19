// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.display.BitmapObject

package ddt.display
{
    import flash.display.BitmapData;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.manager.BitmapManager;

    public class BitmapObject extends BitmapData implements Disposeable 
    {

        public var linkName:String = "BitmapObject";
        public var linkCount:int = 0;
        public var manager:BitmapManager;

        public function BitmapObject(_arg_1:int, _arg_2:int, _arg_3:Boolean=true, _arg_4:uint=0xFFFFFFFF)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        override public function dispose():void
        {
            this.linkCount--;
        }

        public function destory():void
        {
            this.manager = null;
            super.dispose();
        }


    }
}//package ddt.display

