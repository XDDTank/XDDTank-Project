// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.MultiShootAction

package game.actions
{
    import __AS3__.vec.Vector;
    import game.view.map.MapView;
    import game.model.GameInfo;

    public class MultiShootAction extends BaseAction 
    {

        private var _actionList:Vector.<ShootBombAction>;
        private var _map:MapView;
        private var _needBombComplete:Boolean;
        private var _completeCount:int;
        private var _totalCount:int;
        private var _gameInfo:GameInfo;

        public function MultiShootAction(_arg_1:Vector.<ShootBombAction>, _arg_2:MapView, _arg_3:GameInfo, _arg_4:Boolean=false)
        {
            this._actionList = _arg_1;
            this._map = _arg_2;
            this._gameInfo = _arg_3;
            this._needBombComplete = _arg_4;
            this._totalCount = this._actionList.length;
        }

        override public function prepare():void
        {
            if ((!(this._actionList)))
            {
                this.finish();
                return;
            };
            var _local_1:int;
            while (_local_1 < this._actionList.length)
            {
                this._actionList[_local_1].completeCall = this.checkComplete;
                this._actionList[_local_1].prepare();
                _local_1++;
            };
        }

        private function checkComplete():void
        {
            this._completeCount++;
        }

        override public function execute():void
        {
            var _local_1:int;
            if (this.checkFinished())
            {
                if (((!(this._needBombComplete)) || (this._completeCount == this._totalCount)))
                {
                    this.finish();
                };
            }
            else
            {
                _local_1 = 0;
                while (_local_1 < this._actionList.length)
                {
                    this._actionList[_local_1].execute();
                    _local_1++;
                };
            };
        }

        private function checkFinished():Boolean
        {
            var _local_1:Boolean = true;
            var _local_2:int;
            while (_local_2 < this._actionList.length)
            {
                _local_1 = ((_local_1) && (this._actionList[_local_2].isFinished));
                _local_2++;
            };
            return (_local_1);
        }

        private function finish():void
        {
            if (((this._gameInfo) && (this._needBombComplete)))
            {
                this._gameInfo.bombComplete();
            };
            this._gameInfo = null;
            _isFinished = true;
            if (this._actionList)
            {
                this._actionList.length = 0;
            };
            this._actionList = null;
        }

        override public function executeAtOnce():void
        {
            var _local_1:int;
            if (this._actionList)
            {
                _local_1 = 0;
                while (_local_1 < this._actionList.length)
                {
                    this._actionList[_local_1].executeAtOnce();
                    _local_1++;
                };
            };
            super.executeAtOnce();
        }


    }
}//package game.actions

