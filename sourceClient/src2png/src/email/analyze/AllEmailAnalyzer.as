// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.analyze.AllEmailAnalyzer

package email.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import email.data.EmailInfo;
    import ddt.data.goods.InventoryItemInfo;
    import flash.utils.describeType;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.ItemManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.SharedManager;

    public class AllEmailAnalyzer extends DataAnalyzer 
    {

        private var _list:Array;

        public function AllEmailAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:XML;
            var _local_5:XML;
            var _local_6:int;
            var _local_7:EmailInfo;
            var _local_8:XMLList;
            var _local_9:int;
            var _local_10:InventoryItemInfo;
            this._list = new Array();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2.Item;
                _local_4 = describeType(new EmailInfo());
                _local_5 = describeType(new InventoryItemInfo());
                _local_6 = 0;
                while (_local_6 < _local_3.length())
                {
                    _local_7 = new EmailInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_7, _local_3[_local_6]);
                    _local_8 = _local_3[_local_6].Item;
                    _local_9 = 0;
                    while (_local_9 < _local_8.length())
                    {
                        _local_10 = new InventoryItemInfo();
                        _local_10.TemplateID = _local_8[_local_9].@TemplateID;
                        _local_10.beadExp = _local_8[_local_9].@Hole6Exp;
                        ItemManager.fill(_local_10);
                        ObjectUtils.copyPorpertiesByXML(_local_10, _local_8[_local_9]);
                        _local_7[("Annex" + this.getAnnexPos(_local_7, _local_10))] = _local_10;
                        _local_10.isGold = ((_local_8[_local_9].@IsGold == "true") ? true : false);
                        _local_10.goldBeginTime = String(_local_8[_local_9].@GoldBeginTime);
                        _local_10.goldValidDate = int(_local_8[_local_9].@GoldVaild);
                        _local_7.UserID = _local_10.UserID;
                        _local_9++;
                    };
                    if (((!(SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID])) || (SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID].indexOf(_local_7.ID) < 0)))
                    {
                        this._list.push(_local_7);
                    };
                    _local_6++;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }

        public function get list():Array
        {
            this._list.reverse();
            return (this._list);
        }

        private function getAnnexPos(_arg_1:EmailInfo, _arg_2:InventoryItemInfo):int
        {
            var _local_3:uint = 1;
            while (_local_3 <= 5)
            {
                if (_arg_1[(("Annex" + _local_3) + "ID")] == _arg_2.ItemID)
                {
                    return (_local_3);
                };
                _local_3++;
            };
            return (1);
        }


    }
}//package email.analyze

