// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.data.PreviewInfoII

package store.data
{
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import flash.utils.getTimer;

    public class PreviewInfoII 
    {

        private var _info:InventoryItemInfo;
        private var _rate:int;

        public function PreviewInfoII()
        {
            this._info = new InventoryItemInfo();
        }

        public function data(_arg_1:int, _arg_2:Number=7):void
        {
            this._info.TemplateID = _arg_1;
            ItemManager.fill(this._info);
            this._info.BeginDate = String(getTimer());
            this._info.ValidDate = _arg_2;
            this._info.IsJudge = true;
        }

        public function setComposeProperty(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            this._info.AgilityCompose = _arg_1;
            this._info.AttackCompose = _arg_2;
            this._info.DefendCompose = _arg_3;
            this._info.LuckCompose = _arg_4;
        }

        public function get info():InventoryItemInfo
        {
            return (this._info);
        }

        public function set rate(_arg_1:int):void
        {
            this._rate = _arg_1;
        }

        public function get rate():int
        {
            return (this._rate);
        }


    }
}//package store.data

