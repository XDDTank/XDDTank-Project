// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.QueueLoader

package com.pickgliss.loader
{
    import flash.events.EventDispatcher;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import __AS3__.vec.*;

    [Event(name="complete", type="flash.events.Event")]
    [Event(name="change", type="flash.events.Event")]
    public class QueueLoader extends EventDispatcher implements Disposeable 
    {

        private var _loaders:Vector.<BaseLoader>;

        public function QueueLoader()
        {
            this._loaders = new Vector.<BaseLoader>();
        }

        public function addLoader(_arg_1:BaseLoader):void
        {
            this._loaders.push(_arg_1);
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
                this._loaders[_local_1].removeEventListener(LoaderEvent.COMPLETE, this.__loadNext);
                _local_1++;
            };
        }

        public function isAllComplete():Boolean
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

        public function isLoading():Boolean
        {
            var _local_1:int;
            while (_local_1 < this._loaders.length)
            {
                if (this._loaders[_local_1].isLoading)
                {
                    return (true);
                };
                _local_1++;
            };
            return (false);
        }

        public function get completeCount():int
        {
            var _local_1:int;
            var _local_2:int;
            while (_local_2 < this._loaders.length)
            {
                if (this._loaders[_local_2].isComplete)
                {
                    _local_1++;
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function get length():int
        {
            return (this._loaders.length);
        }

        public function get loaders():Vector.<BaseLoader>
        {
            return (this._loaders);
        }

        public function start():void
        {
            this.tryLoadNext();
        }

        private function __loadNext(_arg_1:LoaderEvent):void
        {
            var _local_2:BaseLoader = (_arg_1.loader as BaseLoader);
            _local_2.removeEventListener(LoaderEvent.COMPLETE, this.__loadNext);
            dispatchEvent(new Event(Event.CHANGE));
            this.tryLoadNext();
        }

        private function tryLoadNext():void
        {
            if (this._loaders == null)
            {
                return;
            };
            var _local_1:int = this._loaders.length;
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                if ((!(this._loaders[_local_2].isComplete)))
                {
                    this._loaders[_local_2].addEventListener(LoaderEvent.COMPLETE, this.__loadNext);
                    LoadResourceManager.instance.startLoad(this._loaders[_local_2]);
                    return;
                };
                _local_2++;
            };
            dispatchEvent(new Event(Event.COMPLETE));
        }


    }
}//package com.pickgliss.loader

