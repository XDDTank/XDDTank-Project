// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.goods.Price

package ddt.data.goods
{
    import ddt.manager.LanguageMgr;
    import ddt.manager.ItemManager;

    public class Price 
    {

        public static const MONEY:int = -1;
        public static const DDT_MONEY:int = -2;
        public static const GOLD:int = -3;
        public static const GESTE:int = -4;
        public static const ARMY_EXPLOIT:int = -6;
        public static const MATCH_MEDAL:int = -10;
        public static const OFFER:int = -9;
        public static const MONEYTOSTRING:String = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
        public static const DDTMONEYTOSTRING:String = LanguageMgr.GetTranslation("ddtMoney");
        public static const GOLDTOSTRING:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold");
        public static const ARMY_EXPLOITTOSTRING:String = LanguageMgr.GetTranslation("exploit");
        public static const CONSORTIONOFF:String = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText6");

        private var _value:int;
        private var _unit:int;

        public function Price(_arg_1:int, _arg_2:int)
        {
            this._value = _arg_1;
            this._unit = _arg_2;
        }

        public function clone():Price
        {
            return (new Price(this._value, this._unit));
        }

        public function get Value():int
        {
            return (this._value);
        }

        public function get Unit():int
        {
            return (this._unit);
        }

        public function get frameIndex():int
        {
            switch (this._unit)
            {
                case MONEY:
                    return (1);
                case DDT_MONEY:
                    return (2);
                case GOLD:
                    return (3);
                case GESTE:
                    break;
                case ARMY_EXPLOIT:
                    return (5);
                case OFFER:
                    break;
            };
            return (-1);
        }

        public function get UnitToString():String
        {
            if (((this._unit == MONEY) || (this._unit == DDT_MONEY)))
            {
                return (MONEYTOSTRING);
            };
            if (this._unit == GOLD)
            {
                return (GOLDTOSTRING);
            };
            if (this._unit == ARMY_EXPLOIT)
            {
                return (ARMY_EXPLOITTOSTRING);
            };
            if (this._unit == OFFER)
            {
                return (CONSORTIONOFF);
            };
            if (ItemManager.Instance.getTemplateById(this._unit))
            {
                return (ItemManager.Instance.getTemplateById(this._unit).Name);
            };
            return (LanguageMgr.GetTranslation("wrongUnit"));
        }


    }
}//package ddt.data.goods

