// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.UpdateStateAction

package game.actions
{
    import game.model.Living;

    public class UpdateStateAction extends BaseAction 
    {

        private var _info:Living;
        private var _propertys:Object;
        private var _isExecute:Boolean;

        public function UpdateStateAction(_arg_1:Living, _arg_2:Object)
        {
            this._info = _arg_1;
            this._propertys = _arg_2;
        }

        override public function prepare():void
        {
            if (_isPrepare)
            {
                return;
            };
            this.updateProperties();
            _isPrepare = true;
        }

        private function updateProperties():void
        {
            var _local_1:String;
            if (((this._info) && (this._propertys)))
            {
                for (_local_1 in this._propertys)
                {
                    if (this._info.hasOwnProperty(_local_1))
                    {
                        this._info[_local_1] = this._propertys[_local_1];
                    };
                };
            };
            this._info = null;
            this._propertys = null;
        }

        override public function executeAtOnce():void
        {
            super.executeAtOnce();
        }

        override public function cancel():void
        {
            this.prepare();
        }


    }
}//package game.actions

