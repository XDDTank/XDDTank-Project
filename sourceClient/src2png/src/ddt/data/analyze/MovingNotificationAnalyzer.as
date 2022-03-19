// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.MovingNotificationAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;

    public class MovingNotificationAnalyzer extends DataAnalyzer 
    {

        public var list:Array = [];

        public function MovingNotificationAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            this.list = String(_arg_1).split("\r\n");
            var _local_2:int;
            while (_local_2 < this.list.length)
            {
                this.list[_local_2] = this.list[_local_2].replace("\\r", "\r");
                this.list[_local_2] = this.list[_local_2].replace("\\n", "\n");
                _local_2++;
            };
            onAnalyzeComplete();
        }


    }
}//package ddt.data.analyze

