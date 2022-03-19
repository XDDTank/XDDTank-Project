// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.ActionManager

package game.actions
{
    import flash.utils.getQualifiedClassName;

    public class ActionManager 
    {

        private var _queue:Array;

        public function ActionManager()
        {
            this._queue = new Array();
        }

        public function act(_arg_1:BaseAction):void
        {
            var _local_3:BaseAction;
            var _local_2:int;
            while (_local_2 < this._queue.length)
            {
                _local_3 = this._queue[_local_2];
                if (_local_3.connect(_arg_1))
                {
                    return;
                };
                if (_local_3.canReplace(_arg_1))
                {
                    _arg_1.prepare();
                    this._queue[_local_2] = _arg_1;
                    return;
                };
                _local_2++;
            };
            this._queue.push(_arg_1);
            if (this._queue.length == 1)
            {
                _arg_1.prepare();
            };
        }

        public function execute():void
        {
            var _local_1:BaseAction;
            if (this._queue.length > 0)
            {
                _local_1 = this._queue[0];
                if ((!(_local_1.isFinished)))
                {
                    _local_1.execute();
                }
                else
                {
                    this._queue.shift();
                    if (this._queue.length > 0)
                    {
                        this._queue[0].prepare();
                    };
                };
            };
        }

        public function traceAllRemainAction():void
        {
            var _local_1:BaseAction;
            var _local_2:String;
            for each (_local_1 in this._queue)
            {
                _local_2 = getQualifiedClassName(_local_1);
            };
        }

        public function get actionCount():int
        {
            return (this._queue.length);
        }

        public function executeAtOnce():void
        {
            var _local_1:BaseAction;
            for each (_local_1 in this._queue)
            {
                _local_1.executeAtOnce();
            };
        }

        public function clear():void
        {
            var _local_1:BaseAction;
            for each (_local_1 in this._queue)
            {
                _local_1.cancel();
            };
            this._queue = [];
        }


    }
}//package game.actions

