// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.action.OrderQueueAction

package com.pickgliss.action
{
    public class OrderQueueAction extends BaseAction 
    {

        protected var _actList:Array;
        protected var _count:int;

        public function OrderQueueAction(_arg_1:Array, _arg_2:uint=0)
        {
            this._actList = _arg_1;
            super(_arg_2);
        }

        override public function act():void
        {
            this.cancel();
            this.startAct();
            super.act();
        }

        private function startAct():void
        {
            this._count = 0;
            if (this._actList.length > 0)
            {
                this.actOne();
            };
        }

        protected function actOne():void
        {
            var _local_1:IAction = (this._actList[this._count] as IAction);
            _local_1.setCompleteFun(this.actOneComplete);
            _local_1.act();
        }

        private function actOneComplete(_arg_1:IAction):void
        {
            this.actNext();
        }

        protected function actNext():void
        {
            this._count++;
            if (this._count < this._actList.length)
            {
                this.actOne();
            }
            else
            {
                execComplete();
            };
        }

        override public function cancel():void
        {
            var _local_1:IAction;
            if (_acting)
            {
                _local_1 = (this._actList[this._count] as IAction);
                if (_local_1)
                {
                    _local_1.setCompleteFun(null);
                    _local_1.cancel();
                };
            };
            super.cancel();
        }

        public function getActions():Array
        {
            return (this._actList);
        }


    }
}//package com.pickgliss.action

