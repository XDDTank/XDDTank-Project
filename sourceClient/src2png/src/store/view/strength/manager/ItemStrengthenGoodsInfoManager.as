// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.manager.ItemStrengthenGoodsInfoManager

package store.view.strength.manager
{
    import flash.utils.Dictionary;
    import store.view.strength.analyzer.ItemStrengthenGoodsInfoAnalyzer;
    import store.view.strength.vo.ItemStrengthenGoodsInfo;

    public class ItemStrengthenGoodsInfoManager 
    {

        private static var _lists:Dictionary;


        public static function setup(_arg_1:ItemStrengthenGoodsInfoAnalyzer):void
        {
            _lists = _arg_1.list;
        }

        public static function findItemStrengthenGoodsInfo(_arg_1:int, _arg_2:int):ItemStrengthenGoodsInfo
        {
            if (_lists)
            {
                return (_lists[((_arg_1 + ",") + _arg_2)]);
            };
            return (null);
        }


    }
}//package store.view.strength.manager

