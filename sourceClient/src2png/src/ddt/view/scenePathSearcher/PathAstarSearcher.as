// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.scenePathSearcher.PathAstarSearcher

package ddt.view.scenePathSearcher
{
    import flash.geom.Point;

    public class PathAstarSearcher implements PathIPathSearcher 
    {

        private var open_list:Array;
        private var close_list:Array;
        private var path_arr:Array;
        private var setOut_point:PathAstarPoint;
        private var aim_point:PathAstarPoint;
        private var current_point:PathAstarPoint;
        private var step_len:int;
        private var hittest:PathIHitTester;
        private var record_start_point:PathAstarPoint;

        public function PathAstarSearcher(_arg_1:int)
        {
            this.step_len = _arg_1;
        }

        public function search(_arg_1:Point, _arg_2:Point, _arg_3:PathIHitTester):Array
        {
            this.aim_point = new PathAstarPoint(_arg_2.x, _arg_2.y);
            this.record_start_point = new PathAstarPoint(_arg_1.x, _arg_1.y);
            var _local_4:int;
            var _local_5:int;
            if (_arg_2.x > _arg_1.x)
            {
                _local_4 = (_arg_1.x - (this.step_len - (Math.abs((_arg_2.x - _arg_1.x)) % this.step_len)));
            }
            else
            {
                _local_4 = (_arg_1.x + (this.step_len - (Math.abs((_arg_2.x - _arg_1.x)) % this.step_len)));
            };
            if (_arg_2.y > _arg_1.y)
            {
                _local_5 = (_arg_1.y - (this.step_len - (Math.abs((_arg_2.y - _arg_1.y)) % this.step_len)));
            }
            else
            {
                _local_5 = (_arg_1.y + (this.step_len - (Math.abs((_arg_2.y - _arg_1.y)) % this.step_len)));
            };
            this.setOut_point = new PathAstarPoint(_local_4, _local_5);
            this.current_point = this.setOut_point;
            this.hittest = _arg_3;
            this.init();
            this.findPath();
            return (this.path_arr);
        }

        private function init():void
        {
            this.open_list = new Array();
            this.close_list = new Array();
            this.path_arr = new Array();
        }

        private function findPath():void
        {
            var _local_2:Array;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:int;
            this.open_list.push(this.setOut_point);
            var _local_1:Boolean = true;
            while (((this.open_list.length > 0) && (_local_1)))
            {
                this.current_point = this.open_list.shift();
                if (((this.current_point.x == this.aim_point.x) && (this.current_point.y == this.aim_point.y)))
                {
                    _local_1 = false;
                    this.aim_point = _local_2[_local_6];
                    this.aim_point.source_point = this.current_point;
                    break;
                };
                _local_2 = new Array();
                _local_2 = this.createNode(this.current_point);
                _local_3 = 0;
                _local_4 = 0;
                _local_5 = 0;
                _local_6 = 0;
                while (_local_6 < _local_2.length)
                {
                    if (((_local_2[_local_6].x == this.aim_point.x) && (_local_2[_local_6].y == this.aim_point.y)))
                    {
                        _local_1 = false;
                        this.aim_point = _local_2[_local_6];
                        this.aim_point.source_point = this.current_point;
                        break;
                    };
                    if (((this.existInArray(this.open_list, _local_2[_local_6]) == -1) && (this.existInArray(this.close_list, _local_2[_local_6]) == -1)))
                    {
                        if ((!(this.hittest.isHit(_local_2[_local_6]))))
                        {
                            _local_2[_local_6].source_point = this.current_point;
                            _local_3 = this.getEvaluateG(_local_2[_local_6]);
                            _local_5 = this.getEvaluateH(_local_2[_local_6]);
                            this.setEvaluate(_local_2[_local_6], _local_3, _local_5);
                            this.open_list.push(_local_2[_local_6]);
                        };
                    }
                    else
                    {
                        if (this.existInArray(this.open_list, _local_2[_local_6]) != -1)
                        {
                            _local_3 = this.getEvaluateG(_local_2[_local_6]);
                            _local_5 = this.getEvaluateH(_local_2[_local_6]);
                            _local_4 = (_local_3 + _local_5);
                            if (_local_4 < _local_2[_local_6].f)
                            {
                                _local_2[_local_6].source_point = this.current_point;
                                this.setEvaluate(_local_2[_local_6], _local_3, _local_5);
                            };
                        }
                        else
                        {
                            _local_3 = this.getEvaluateG(_local_2[_local_6]);
                            _local_5 = this.getEvaluateH(_local_2[_local_6]);
                            _local_4 = (_local_3 + _local_5);
                            if (_local_4 < _local_2[_local_6].f)
                            {
                                _local_2[_local_6].source_point = this.current_point;
                                this.setEvaluate(_local_2[_local_6], _local_3, _local_5);
                                this.open_list.push(_local_2[_local_6]);
                                this.close_list.splice(this.existInArray(this.close_list, _local_2[_local_6]), 1);
                            };
                        };
                    };
                    _local_6++;
                };
                this.close_list.push(this.current_point);
                this.open_list.sortOn("f", Array.NUMERIC);
                if (this.open_list.length > 30)
                {
                    this.open_list = this.open_list.slice(0, 30);
                };
            };
            this.createPath();
        }

        private function createPath():void
        {
            var _local_1:PathAstarPoint = new PathAstarPoint();
            _local_1 = this.aim_point;
            while (_local_1 != this.setOut_point)
            {
                this.path_arr.unshift(_local_1);
                if (_local_1.source_point != null)
                {
                    _local_1 = _local_1.source_point;
                }
                else
                {
                    this.path_arr = new Array();
                    this.path_arr.push(this.record_start_point, this.record_start_point);
                    return;
                };
            };
            this.path_arr.splice(0, 0, this.record_start_point);
        }

        private function setEvaluate(_arg_1:PathAstarPoint, _arg_2:Number, _arg_3:Number):void
        {
            _arg_1.g = _arg_2;
            _arg_1.h = _arg_3;
            _arg_1.f = (_arg_1.g + _arg_1.h);
        }

        private function getEvaluateG(_arg_1:PathAstarPoint):int
        {
            var _local_2:int;
            if (((this.current_point.x == _arg_1.x) || (this.current_point.y == _arg_1.y)))
            {
                _local_2 = 10;
            }
            else
            {
                _local_2 = 14;
            };
            return (_local_2 + this.current_point.g);
        }

        private function getEvaluateH(_arg_1:PathAstarPoint):int
        {
            return ((Math.abs((this.aim_point.x - _arg_1.x)) * 10) + (Math.abs((this.aim_point.y - _arg_1.y)) * 10));
        }

        private function createNode(_arg_1:PathAstarPoint):Array
        {
            var _local_2:Array = new Array();
            _local_2.push(new PathAstarPoint(_arg_1.x, (_arg_1.y - this.step_len)));
            _local_2.push(new PathAstarPoint((_arg_1.x - this.step_len), _arg_1.y));
            _local_2.push(new PathAstarPoint((_arg_1.x + this.step_len), _arg_1.y));
            _local_2.push(new PathAstarPoint(_arg_1.x, (_arg_1.y + this.step_len)));
            _local_2.push(new PathAstarPoint((_arg_1.x - this.step_len), (_arg_1.y - this.step_len)));
            _local_2.push(new PathAstarPoint((_arg_1.x + this.step_len), (_arg_1.y - this.step_len)));
            _local_2.push(new PathAstarPoint((_arg_1.x - this.step_len), (_arg_1.y + this.step_len)));
            _local_2.push(new PathAstarPoint((_arg_1.x + this.step_len), (_arg_1.y + this.step_len)));
            return (_local_2);
        }

        private function existInArray(_arg_1:Array, _arg_2:PathAstarPoint):int
        {
            var _local_3:int = -1;
            var _local_4:int;
            while (_local_4 < _arg_1.length)
            {
                if (((_arg_1[_local_4].x == _arg_2.x) && (_arg_1[_local_4].y == _arg_2.y)))
                {
                    _local_3 = _local_4;
                    break;
                };
                _local_4++;
            };
            return (_local_3);
        }


    }
}//package ddt.view.scenePathSearcher

