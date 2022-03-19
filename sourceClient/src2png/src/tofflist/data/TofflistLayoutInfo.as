// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.data.TofflistLayoutInfo

package tofflist.data
{
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import __AS3__.vec.*;

    public class TofflistLayoutInfo 
    {

        public var TitleHLinePoint:Vector.<Point>;
        public var TitleTextPoint:Vector.<Point>;
        public var TitleTextString:Array;

        public function TofflistLayoutInfo()
        {
            this.TitleHLinePoint = new Vector.<Point>();
            this.TitleTextPoint = new Vector.<Point>();
        }

        public function set titleHLinePt(_arg_1:String):void
        {
            this.TitleHLinePoint = this.parseValue(_arg_1);
        }

        public function set titleTextPt(_arg_1:String):void
        {
            this.TitleTextPoint = this.parseValue(_arg_1);
        }

        private function parseValue(_arg_1:String):Vector.<Point>
        {
            var _local_4:String;
            var _local_5:Point;
            var _local_2:Vector.<Point> = new Vector.<Point>();
            var _local_3:Array = _arg_1.split("|");
            for each (_local_4 in _local_3)
            {
                _local_5 = new Point(_local_4.split(",")[0], _local_4.split(",")[1]);
                _local_2.push(_local_5);
            };
            return (_local_2);
        }


    }
}//package tofflist.data

