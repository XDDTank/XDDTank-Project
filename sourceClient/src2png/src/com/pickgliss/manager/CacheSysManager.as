// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.manager.CacheSysManager

package com.pickgliss.manager
{
    import flash.utils.Dictionary;
    import com.pickgliss.action.TickOrderQueueAction;
    import com.pickgliss.action.IAction;

    public class CacheSysManager 
    {

        private static var instance:CacheSysManager;
        private static var _lockDic:Dictionary = new Dictionary();

        private var _cacheDic:Dictionary;

        public function CacheSysManager()
        {
            this._cacheDic = new Dictionary();
            _lockDic = new Dictionary();
        }

        public static function getInstance():CacheSysManager
        {
            if (instance == null)
            {
                instance = new (CacheSysManager)();
            };
            return (instance);
        }

        private static function getReleaseAction(_arg_1:Array, _arg_2:uint=0):IAction
        {
            return (new TickOrderQueueAction(_arg_1, 100, _arg_2));
        }

        public static function lock(_arg_1:String):void
        {
            _lockDic[_arg_1] = true;
        }

        public static function unlock(_arg_1:String):void
        {
            delete _lockDic[_arg_1];
        }

        public static function isLock(_arg_1:String):Boolean
        {
            return ((_lockDic[_arg_1]) ? true : false);
        }


        public function cache(_arg_1:String, _arg_2:IAction):void
        {
            if ((!(this._cacheDic[_arg_1])))
            {
                this._cacheDic[_arg_1] = new Array();
            };
            this._cacheDic[_arg_1].push(_arg_2);
        }

        public function release(_arg_1:String, _arg_2:uint=0):void
        {
            var _local_3:IAction;
            if (this._cacheDic[_arg_1])
            {
                _local_3 = getReleaseAction((this._cacheDic[_arg_1] as Array), _arg_2);
                _local_3.act();
                delete this._cacheDic[_arg_1];
            };
        }

        public function singleRelease(_arg_1:String):void
        {
            var _local_2:IAction;
            var _local_3:Array;
            if (this._cacheDic[_arg_1])
            {
                _local_3 = this._cacheDic[_arg_1];
                if (_local_3[0])
                {
                    (_local_3[0] as IAction).act();
                };
                _local_3.shift();
            };
        }

        public function cacheFunction(_arg_1:String, _arg_2:IAction):void
        {
            if ((!(this._cacheDic[_arg_1])))
            {
                this._cacheDic[_arg_1] = new Array();
            };
            this._cacheDic[_arg_1].push(_arg_2);
        }


    }
}//package com.pickgliss.manager

