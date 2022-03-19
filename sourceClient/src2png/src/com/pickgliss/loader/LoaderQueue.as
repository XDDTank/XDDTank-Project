// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.LoaderQueue

package com.pickgliss.loader
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class LoaderQueue extends EventDispatcher 
    {

        private var _loaders:Vector.<BaseLoader>;

        public function LoaderQueue()
        {
            this._loaders = new Vector.<BaseLoader>();
        }

        public function addLoader(_arg_1:BaseLoader):void
        {
            this._loaders.push(_arg_1);
        }

        public function start():void
        {
            var _local_1:int = this._loaders.length;
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                if (this._loaders == null)
                {
                    return;
                };
                this._loaders[_local_2].addEventListener(LoaderEvent.COMPLETE, this.__loadComplete);
                LoadResourceManager.instance.startLoad(this._loaders[_local_2]);
                _local_2++;
            };
            if (_local_1 == 0)
            {
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            this._loaders = null;
        }

        public function removeEvent():void
        {
            var _local_1:int;
            while (_local_1 < this._loaders.length)
            {
                this._loaders[_local_1].removeEventListener(LoaderEvent.COMPLETE, this.__loadComplete);
                _local_1++;
            };
        }

        public function get length():int
        {
            return (this._loaders.length);
        }

        public function get loaders():Vector.<BaseLoader>
        {
            return (this._loaders);
        }

        private function __loadComplete(_arg_1:LoaderEvent):void
        {
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__loadComplete);
            if (this.isComplete)
            {
                this.removeEvent();
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }

        public function get isComplete():Boolean
        {
            var _local_1:int;
            while (_local_1 < this._loaders.length)
            {
                if ((!(this._loaders[_local_1].isComplete)))
                {
                    return (false);
                };
                _local_1++;
            };
            return (true);
        }


    }
}//package com.pickgliss.loader

