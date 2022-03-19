// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//org.aswing.util.ASWingVector

package org.aswing.util
{
    public class ASWingVector implements List 
    {

        public static const CASEINSENSITIVE:int = 1;
        public static const DESCENDING:int = 2;
        public static const UNIQUESORT:int = 4;
        public static const RETURNINDEXEDARRAY:int = 8;
        public static const NUMERIC:int = 16;

        protected var _elements:Array;

        public function ASWingVector()
        {
            this._elements = new Array();
        }

        public function each(_arg_1:Function):void
        {
            var _local_2:int;
            while (_local_2 < this._elements.length)
            {
                (_arg_1(this._elements[_local_2]));
                _local_2++;
            };
        }

        public function eachWithout(_arg_1:Object, _arg_2:Function):void
        {
            var _local_3:int;
            while (_local_3 < this._elements.length)
            {
                if (this._elements[_local_3] != _arg_1)
                {
                    (_arg_2(this._elements[_local_3]));
                };
                _local_3++;
            };
        }

        public function get(_arg_1:int):*
        {
            return (this._elements[_arg_1]);
        }

        public function elementAt(_arg_1:int):*
        {
            return (this.get(_arg_1));
        }

        public function append(_arg_1:*, _arg_2:int=-1):void
        {
            if (_arg_2 == -1)
            {
                this._elements.push(_arg_1);
            }
            else
            {
                this._elements.splice(_arg_2, 0, _arg_1);
            };
        }

        public function appendAll(_arg_1:Array, _arg_2:int=-1):void
        {
            var _local_3:Array;
            if (((_arg_1 == null) || (_arg_1.length <= 0)))
            {
                return;
            };
            if (((_arg_2 == -1) || (_arg_2 == this._elements.length)))
            {
                this._elements = this._elements.concat(_arg_1);
            }
            else
            {
                if (_arg_2 == 0)
                {
                    this._elements = _arg_1.concat(this._elements);
                }
                else
                {
                    _local_3 = this._elements.splice(_arg_2);
                    this._elements = this._elements.concat(_arg_1);
                    this._elements = this._elements.concat(_local_3);
                };
            };
        }

        public function replaceAt(_arg_1:int, _arg_2:*):*
        {
            var _local_3:Object;
            if (((_arg_1 < 0) || (_arg_1 >= this.size())))
            {
                return (null);
            };
            _local_3 = this._elements[_arg_1];
            this._elements[_arg_1] = _arg_2;
            return (_local_3);
        }

        public function removeAt(_arg_1:int):*
        {
            var _local_2:Object;
            if (((_arg_1 < 0) || (_arg_1 >= this.size())))
            {
                return (null);
            };
            _local_2 = this._elements[_arg_1];
            this._elements.splice(_arg_1, 1);
            return (_local_2);
        }

        public function remove(_arg_1:*):*
        {
            var _local_2:int = this.indexOf(_arg_1);
            if (_local_2 >= 0)
            {
                return (this.removeAt(_local_2));
            };
            return (null);
        }

        public function removeRange(_arg_1:int, _arg_2:int):Array
        {
            _arg_1 = Math.max(0, _arg_1);
            _arg_2 = Math.min(_arg_2, (this._elements.length - 1));
            if (_arg_1 > _arg_2)
            {
                return ([]);
            };
            return (this._elements.splice(_arg_1, ((_arg_2 - _arg_1) + 1)));
        }

        public function indexOf(_arg_1:*):int
        {
            var _local_2:int;
            while (_local_2 < this._elements.length)
            {
                if (this._elements[_local_2] === _arg_1)
                {
                    return (_local_2);
                };
                _local_2++;
            };
            return (-1);
        }

        public function appendList(_arg_1:List, _arg_2:int=-1):void
        {
            this.appendAll(_arg_1.toArray(), _arg_2);
        }

        public function pop():*
        {
            if (this.size() > 0)
            {
                return (this._elements.pop());
            };
            return (null);
        }

        public function shift():*
        {
            if (this.size() > 0)
            {
                return (this._elements.shift());
            };
            return (undefined);
        }

        public function lastIndexOf(_arg_1:*):int
        {
            var _local_2:int = (this._elements.length - 1);
            while (_local_2 >= 0)
            {
                if (this._elements[_local_2] === _arg_1)
                {
                    return (_local_2);
                };
                _local_2--;
            };
            return (-1);
        }

        public function contains(_arg_1:*):Boolean
        {
            return (this.indexOf(_arg_1) >= 0);
        }

        public function first():*
        {
            return (this._elements[0]);
        }

        public function last():*
        {
            return (this._elements[(this._elements.length - 1)]);
        }

        public function size():int
        {
            return (this._elements.length);
        }

        public function setElementAt(_arg_1:int, _arg_2:*):void
        {
            this.replaceAt(_arg_1, _arg_2);
        }

        public function getSize():int
        {
            return (this.size());
        }

        public function clear():void
        {
            if ((!(this.isEmpty())))
            {
                this._elements.splice(0);
                this._elements = new Array();
            };
        }

        public function clone():ASWingVector
        {
            var _local_1:ASWingVector = new ASWingVector();
            var _local_2:int;
            while (_local_2 < this._elements.length)
            {
                _local_1.append(this._elements[_local_2]);
                _local_2++;
            };
            return (_local_1);
        }

        public function isEmpty():Boolean
        {
            if (this._elements.length > 0)
            {
                return (false);
            };
            return (true);
        }

        public function toArray():Array
        {
            return (this._elements.concat());
        }

        public function subArray(_arg_1:int, _arg_2:int):Array
        {
            return (this._elements.slice(_arg_1, Math.min((_arg_1 + _arg_2), this.size())));
        }

        public function sort(_arg_1:Object, _arg_2:int):Array
        {
            return (this._elements.sort(_arg_1, _arg_2));
        }

        public function sortOn(_arg_1:Object, _arg_2:int):Array
        {
            return (this._elements.sortOn(_arg_1, _arg_2));
        }

        public function toString():String
        {
            return ("Vector : " + this._elements.toString());
        }


    }
}//package org.aswing.util

