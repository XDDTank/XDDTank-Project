// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.list.VectorListModel

package com.pickgliss.ui.controls.list
{
    import com.pickgliss.utils.IListData;
    import com.pickgliss.ui.controls.cell.INotSameHeightListCellData;

    public class VectorListModel extends BaseListModel implements IMutableListModel, IListData 
    {

        public static const CASEINSENSITIVE:int = 1;
        public static const DESCENDING:int = 2;
        public static const NUMERIC:int = 16;
        public static const RETURNINDEXEDARRAY:int = 8;
        public static const UNIQUESORT:int = 4;

        protected var _elements:Array;

        public function VectorListModel(_arg_1:Array=null)
        {
            if (_arg_1 != null)
            {
                this._elements = _arg_1.concat();
            }
            else
            {
                this._elements = new Array();
            };
        }

        public function append(_arg_1:*, _arg_2:int=-1):void
        {
            if (_arg_2 == -1)
            {
                _arg_2 = this._elements.length;
                this._elements.push(_arg_1);
            }
            else
            {
                this._elements.splice(_arg_2, 0, _arg_1);
            };
            fireIntervalAdded(this, _arg_2, _arg_2);
        }

        public function appendAll(_arg_1:Array, _arg_2:int=-1):void
        {
            var _local_3:Array;
            if (((_arg_1 == null) || (_arg_1.length <= 0)))
            {
                return;
            };
            if (_arg_2 == -1)
            {
                _arg_2 = this._elements.length;
            };
            if (_arg_2 == 0)
            {
                this._elements = _arg_1.concat(this._elements);
            }
            else
            {
                if (_arg_2 == this._elements.length)
                {
                    this._elements = this._elements.concat(_arg_1);
                }
                else
                {
                    _local_3 = this._elements.splice(_arg_2);
                    this._elements = this._elements.concat(_arg_1);
                    this._elements = this._elements.concat(_local_3);
                };
            };
            fireIntervalAdded(this, _arg_2, ((_arg_2 + _arg_1.length) - 1));
        }

        public function appendList(_arg_1:IListData, _arg_2:int=-1):void
        {
            this.appendAll(_arg_1.toArray(), _arg_2);
        }

        public function clear():void
        {
            var _local_2:Array;
            var _local_1:int = (this.size() - 1);
            if (_local_1 >= 0)
            {
                _local_2 = this.toArray();
                this._elements.splice(0);
                fireIntervalRemoved(this, 0, _local_1, _local_2);
            };
        }

        public function contains(_arg_1:*):Boolean
        {
            return (this.indexOf(_arg_1) >= 0);
        }

        public function first():*
        {
            return (this._elements[0]);
        }

        public function get(_arg_1:int):*
        {
            return (this._elements[_arg_1]);
        }

        public function getElementAt(_arg_1:int):*
        {
            return (this._elements[_arg_1]);
        }

        public function getSize():int
        {
            return (this.size());
        }

        public function indexOf(_arg_1:*):int
        {
            var _local_2:int;
            while (_local_2 < this._elements.length)
            {
                if (this._elements[_local_2] == _arg_1)
                {
                    return (_local_2);
                };
                _local_2++;
            };
            return (-1);
        }

        public function insertElementAt(_arg_1:*, _arg_2:int):void
        {
            this.append(_arg_1, _arg_2);
        }

        public function isEmpty():Boolean
        {
            return (this._elements.length <= 0);
        }

        public function last():*
        {
            return (this._elements[(this._elements.length - 1)]);
        }

        public function pop():*
        {
            if (this.size() > 0)
            {
                return (this.removeAt((this.size() - 1)));
            };
            return (null);
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

        public function removeAt(_arg_1:int):*
        {
            if (((_arg_1 < 0) || (_arg_1 >= this.size())))
            {
                return (null);
            };
            var _local_2:* = this._elements[_arg_1];
            this._elements.splice(_arg_1, 1);
            fireIntervalRemoved(this, _arg_1, _arg_1, [_local_2]);
            return (_local_2);
        }

        public function removeElementAt(_arg_1:int):void
        {
            this.removeAt(_arg_1);
        }

        public function removeRange(_arg_1:int, _arg_2:int):Array
        {
            var _local_3:Array;
            if (this._elements.length > 0)
            {
                _arg_1 = Math.max(0, _arg_1);
                _arg_2 = Math.min(_arg_2, (this._elements.length - 1));
                if (_arg_1 > _arg_2)
                {
                    return ([]);
                };
                _local_3 = this._elements.splice(_arg_1, ((_arg_2 - _arg_1) + 1));
                fireIntervalRemoved(this, _arg_1, _arg_2, _local_3);
                return (_local_3);
            };
            return ([]);
        }

        public function replaceAt(_arg_1:int, _arg_2:*):*
        {
            if (((_arg_1 < 0) || (_arg_1 >= this.size())))
            {
                return (null);
            };
            var _local_3:* = this._elements[_arg_1];
            this._elements[_arg_1] = _arg_2;
            fireContentsChanged(this, _arg_1, _arg_1, [_local_3]);
            return (_local_3);
        }

        public function shift():*
        {
            if (this.size() > 0)
            {
                return (this.removeAt(0));
            };
            return (null);
        }

        public function size():int
        {
            return (this._elements.length);
        }

        public function sort(_arg_1:Object, _arg_2:int):Array
        {
            var _local_3:Array = this._elements.sort(_arg_1, _arg_2);
            fireContentsChanged(this, 0, (this._elements.length - 1), []);
            return (_local_3);
        }

        public function sortOn(_arg_1:Object, _arg_2:int):Array
        {
            var _local_3:Array = this._elements.sortOn(_arg_1, _arg_2);
            fireContentsChanged(this, 0, (this._elements.length - 1), []);
            return (_local_3);
        }

        public function subArray(_arg_1:int, _arg_2:int):Array
        {
            if (((this.size() == 0) || (_arg_2 <= 0)))
            {
                return (new Array());
            };
            return (this._elements.slice(_arg_1, Math.min((_arg_1 + _arg_2), this.size())));
        }

        public function toArray():Array
        {
            return (this._elements.concat());
        }

        public function toString():String
        {
            return ("VectorListModel : " + this._elements.toString());
        }

        public function valueChanged(_arg_1:*):void
        {
            this.valueChangedAt(this.indexOf(_arg_1));
        }

        public function valueChangedAt(_arg_1:int):void
        {
            if (((_arg_1 >= 0) && (_arg_1 < this._elements.length)))
            {
                fireContentsChanged(this, _arg_1, _arg_1, []);
            };
        }

        public function valueChangedRange(_arg_1:int, _arg_2:int):void
        {
            fireContentsChanged(this, _arg_1, _arg_2, []);
        }

        public function get elements():Array
        {
            return (this._elements);
        }

        public function getCellPosFromIndex(_arg_1:int):Number
        {
            var _local_5:INotSameHeightListCellData;
            var _local_2:Number = 0;
            var _local_3:int = this.size();
            if (_arg_1 > _local_3)
            {
                _arg_1 = _local_3;
            };
            var _local_4:int;
            while (_local_4 < _arg_1)
            {
                if (_local_4 == _arg_1) break;
                _local_5 = this.get(_local_4);
                _local_2 = (_local_2 + _local_5.getCellHeight());
                _local_4++;
            };
            return (_local_2);
        }

        public function getAllCellHeight():Number
        {
            var _local_4:INotSameHeightListCellData;
            var _local_1:Number = 0;
            var _local_2:int = this.size();
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = this.get(_local_3);
                _local_1 = (_local_1 + _local_4.getCellHeight());
                _local_3++;
            };
            return (_local_1);
        }

        public function getStartIndexByPosY(_arg_1:Number):int
        {
            var _local_6:INotSameHeightListCellData;
            var _local_2:int;
            var _local_3:int = this.size();
            var _local_4:Number = 0;
            var _local_5:int;
            while (_local_5 < _local_3)
            {
                _local_6 = this.get(_local_5);
                _local_4 = (_local_4 + _local_6.getCellHeight());
                if (_local_4 >= _arg_1)
                {
                    _local_2 = _local_5;
                    break;
                };
                _local_5++;
            };
            return (_local_2);
        }


    }
}//package com.pickgliss.ui.controls.list

