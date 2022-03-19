// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.BaseAction

package game.actions
{
    public class BaseAction 
    {

        protected var _isFinished:Boolean;
        protected var _isPrepare:Boolean;

        public function BaseAction()
        {
            this._isFinished = false;
        }

        public function connect(_arg_1:BaseAction):Boolean
        {
            return (false);
        }

        public function canReplace(_arg_1:BaseAction):Boolean
        {
            return (false);
        }

        public function get isFinished():Boolean
        {
            return (this._isFinished);
        }

        public function prepare():void
        {
            if (this._isPrepare)
            {
                return;
            };
            this._isPrepare = true;
        }

        public function execute():void
        {
            this.executeAtOnce();
            this._isFinished = true;
        }

        public function executeAtOnce():void
        {
            this.prepare();
            this._isFinished = true;
        }

        public function cancel():void
        {
        }


    }
}//package game.actions

