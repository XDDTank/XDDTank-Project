// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.data.DictionaryData

package road7th.data
{
    import flash.utils.Dictionary;
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;

    [Event(name="add", type="DictionaryEvent")]
    [Event(name="update", type="DictionaryEvent")]
    [Event(name="remove", type="DictionaryEvent")]
    [Event(name="clear", type="DictionaryEvent")]
    public dynamic class DictionaryData extends Dictionary implements IEventDispatcher 
    {

        private var _dispatcher:EventDispatcher;
        private var _array:Array;
        private var _fName:String;
        private var _value:Object;

        public function DictionaryData(_arg_1:Boolean=false)
        {
            super(_arg_1);
            this._dispatcher = new EventDispatcher(this);
            this._array = [];
        }

        public function get length():int
        {
            return (this._array.length);
        }

        public function get list():Array
        {
            return (this._array);
        }

        public function filter(_arg_1:String, _arg_2:Object):Array
        {
            this._fName = _arg_1;
            this._value = _arg_2;
            return (this._array.filter(this.filterCallBack));
        }

        private function filterCallBack(_arg_1:*, _arg_2:int, _arg_3:Array):Boolean
        {
            return (_arg_1[this._fName] == this._value);
        }

        public function add(_arg_1:*, _arg_2:Object):void
        {
            var _local_3:Object;
            var _local_4:int;
            if (this[_arg_1] == null)
            {
                this[_arg_1] = _arg_2;
                this._array.push(_arg_2);
                this.dispatchEvent(new DictionaryEvent(DictionaryEvent.ADD, _arg_2));
            }
            else
            {
                _local_3 = this[_arg_1];
                this[_arg_1] = _arg_2;
                _local_4 = this._array.indexOf(_local_3);
                if (_local_4 > -1)
                {
                    this._array.splice(_local_4, 1);
                };
                this._array.push(_arg_2);
                this.dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE, _arg_2));
            };
        }

        public function hasKey(_arg_1:*):Boolean
        {
            return (!(this[_arg_1] == null));
        }

        public function remove(_arg_1:*):void
        {
            var _local_3:int;
            var _local_2:Object = this[_arg_1];
            if (_local_2 != null)
            {
                this[_arg_1] = null;
                delete this[_arg_1];
                _local_3 = this._array.indexOf(_local_2);
                if (_local_3 > -1)
                {
                    this._array.splice(_local_3, 1);
                };
                this.dispatchEvent(new DictionaryEvent(DictionaryEvent.REMOVE, _local_2));
            };
        }

        public function setData(_arg_1:DictionaryData):void
        {
            var _local_2:String;
            this.cleardata();
            for (_local_2 in _arg_1)
            {
                this[_local_2] = _arg_1[_local_2];
                this._array.push(_arg_1[_local_2]);
            };
        }

        public function clear():void
        {
            this.cleardata();
            this.dispatchEvent(new DictionaryEvent(DictionaryEvent.CLEAR));
        }

        public function slice(_arg_1:int=0, _arg_2:int=166777215):Array
        {
            return (this._array.slice(_arg_1, _arg_2));
        }

        public function concat(_arg_1:Array):Array
        {
            return (this._array.concat(_arg_1));
        }

        private function cleardata():void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_1:Array = [];
            for (_local_2 in this)
            {
                _local_1.push(_local_2);
            };
            for each (_local_3 in _local_1)
            {
                this[_local_3] = null;
                delete this[_local_3];
            };
            this._array = [];
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._dispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._dispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._dispatcher.dispatchEvent(_arg_1));
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._dispatcher.hasEventListener(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._dispatcher.willTrigger(_arg_1));
        }


    }
}//package road7th.data

