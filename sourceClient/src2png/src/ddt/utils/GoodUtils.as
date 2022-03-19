// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.GoodUtils

package ddt.utils
{
    import ddt.data.goods.InventoryItemInfo;
    import road7th.utils.DateUtils;
    import ddt.manager.TimeManager;
    import road7th.data.DictionaryData;

    public class GoodUtils 
    {


        public static function getOverdueItemsFrom(_arg_1:DictionaryData):Array
        {
            var _local_4:Date;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:InventoryItemInfo;
            var _local_2:Array = [];
            var _local_3:Array = [];
            for each (_local_7 in _arg_1)
            {
                if (!(!(_local_7)))
                {
                    if (!(!(_local_7.IsUsed)))
                    {
                        if (_local_7.ValidDate != 0)
                        {
                            _local_4 = DateUtils.getDateByStr(_local_7.BeginDate);
                            _local_5 = TimeManager.Instance.TotalDaysToNow(_local_4);
                            _local_6 = ((_local_7.ValidDate - _local_5) * 24);
                            if (((_local_6 < 24) && (_local_6 > 0)))
                            {
                                _local_2.push(_local_7);
                            }
                            else
                            {
                                if (_local_6 <= 0)
                                {
                                    _local_3.push(_local_7);
                                };
                            };
                        };
                    };
                };
            };
            return ([_local_2, _local_3]);
        }


    }
}//package ddt.utils

