// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.math.XLine

package road7th.math
{
    import flash.geom.Point;

    public class XLine 
    {

        protected var list:Array;
        protected var fix:Boolean = true;
        protected var fixValue:Number = 1;

        public function XLine(... _args)
        {
            this.line = _args;
        }

        public static function ToString(_arg_1:Array):String
        {
            var _local_3:Point;
            var _local_2:String = "";
            try
            {
                for each (_local_3 in _arg_1)
                {
                    _local_2 = (_local_2 + (((_local_3.x + ":") + _local_3.y) + ","));
                };
            }
            catch(e:Error)
            {
            };
            return (_local_2);
        }

        public static function parse(_arg_1:String):Array
        {
            var _local_3:Array;
            var _local_4:Array;
            var _local_5:int;
            var _local_2:Array = new Array();
            try
            {
                _local_3 = _arg_1.match(/([-]?\d+[\.]?\d*)/g);
                _local_4 = new Array();
                _local_5 = 0;
                while (_local_5 < _local_3.length)
                {
                    _local_2.push(new Point(Number(_local_3[_local_5]), Number(_local_3[(_local_5 + 1)])));
                    _local_5 = (_local_5 + 2);
                };
            }
            catch(e:Error)
            {
            };
            return (_local_2);
        }


        public function set line(_arg_1:Array):void
        {
            this.list = _arg_1;
            if (((this.list == null) || (this.list.length == 0)))
            {
                this.fix = true;
                this.fixValue = 1;
            }
            else
            {
                if (this.list.length == 1)
                {
                    this.fix = true;
                    this.fixValue = this.list[0].y;
                }
                else
                {
                    if (((this.list.length == 2) && (this.list[0].y == this.list[1].y)))
                    {
                        this.fix = true;
                        this.fixValue = this.list[0].y;
                    }
                    else
                    {
                        this.fix = false;
                    };
                };
            };
        }

        public function get line():Array
        {
            return (this.list);
        }

        public function interpolate(_arg_1:Number):Number
        {
            var _local_2:Point;
            var _local_3:Point;
            var _local_4:int;
            if ((!(this.fix)))
            {
                _local_4 = 1;
                while (_local_4 < this.list.length)
                {
                    _local_3 = this.list[_local_4];
                    _local_2 = this.list[(_local_4 - 1)];
                    if (_local_3.x > _arg_1) break;
                    _local_4++;
                };
                return (interpolatePointByX(_local_2, _local_3, _arg_1));
            };
            return (this.fixValue);
        }


    }
}//package road7th.math

