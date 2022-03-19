﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.goods.ShopItemInfo

package ddt.data.goods
{
    import flash.events.EventDispatcher;
    import ddt.manager.LanguageMgr;
    import ddt.manager.TimeManager;
    import ddt.manager.ItemManager;
    import flash.events.Event;
    import road7th.utils.DateUtils;

    public class ShopItemInfo extends EventDispatcher 
    {

        public static const DAY:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
        public static const AMOUNT:String = LanguageMgr.GetTranslation("ge");
        public static const FOREVER:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.forever");

        public var ID:int;
        public var ShopID:int;
        public var GoodsID:int;
        public var TemplateID:int;
        public var BuyType:int;
        public var Sort:int;
        public var IsBind:int;
        public var Label:int;
        public var IsCheap:Boolean;
        public var Beat:Number = 1;
        public var AUnit:int;
        public var APrice1:int;
        public var AValue1:int;
        public var APrice2:int;
        public var AValue2:int;
        public var APrice3:int;
        public var AValue3:int;
        public var AValue4:int;
        public var BUnit:int;
        public var BPrice1:int;
        public var BValue1:int;
        public var BPrice2:int;
        public var BValue2:int;
        public var BPrice3:int;
        public var BValue3:int;
        public var IsContinue:Boolean;
        public var CUnit:int;
        public var CPrice1:int;
        public var CValue1:int;
        public var CPrice2:int;
        public var CValue2:int;
        public var CPrice3:int;
        public var CValue3:int;
        private var startDate:String;
        private var endDate:String;
        private var startData_D:Date;
        private var endDate_D:Date;
        private var _templateInfo:ItemTemplateInfo;
        private var _itemPrice:ItemPrice;
        private var _count:int = -1;
        private var _limitGrade:int;
        public var isDiscount:int = 1;
        private var _isBuy:Boolean = false;

        public function ShopItemInfo(_arg_1:int, _arg_2:int)
        {
            this.GoodsID = _arg_1;
            this.TemplateID = _arg_2;
        }

        public function get LimitGrade():int
        {
            return (this._limitGrade);
        }

        public function set LimitGrade(_arg_1:int):void
        {
            this._limitGrade = _arg_1;
        }

        public function get isValid():Boolean
        {
            if (((TimeManager.Instance.Now().time < this.endDate_D.time) && (TimeManager.Instance.Now().time >= this.startData_D.time)))
            {
                return (true);
            };
            return (false);
        }

        public function set TemplateInfo(_arg_1:ItemTemplateInfo):void
        {
            this._templateInfo = _arg_1;
        }

        public function get TemplateInfo():ItemTemplateInfo
        {
            if (this._templateInfo == null)
            {
                return (ItemManager.Instance.getTemplateById(this.TemplateID));
            };
            return (this._templateInfo);
        }

        public function getItemPrice(_arg_1:int):ItemPrice
        {
            switch (_arg_1)
            {
                case 1:
                    return (new ItemPrice(((this.AUnit == -1) ? null : new Price((this.AValue1 * this.Beat), this.APrice1)), ((this.AUnit == -1) ? null : new Price((this.AValue2 * this.Beat), this.APrice2)), ((this.AUnit == -1) ? null : new Price((this.AValue3 * this.Beat), this.APrice3))));
                case 2:
                    return (new ItemPrice(((this.BUnit == -1) ? null : new Price((this.BValue1 * this.Beat), this.BPrice1)), ((this.BUnit == -1) ? null : new Price((this.BValue2 * this.Beat), this.BPrice2)), ((this.BUnit == -1) ? null : new Price((this.BValue3 * this.Beat), this.BPrice3))));
                case 3:
                    return (new ItemPrice(((this.CUnit == -1) ? null : new Price((this.CValue1 * this.Beat), this.CPrice1)), ((this.CUnit == -1) ? null : new Price((this.CValue2 * this.Beat), this.CPrice2)), ((this.CUnit == -1) ? null : new Price((this.CValue3 * this.Beat), this.CPrice3))));
            };
            return (new ItemPrice(new Price(this.AValue1, this.APrice1), new Price(this.AValue2, this.APrice2), new Price(this.AValue3, this.APrice3)));
        }

        public function getTimeToString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case 1:
                    return ((this.AUnit == 0) ? FOREVER : (this.AUnit.toString() + this.buyTypeToString));
                case 2:
                    return ((this.BUnit == 0) ? FOREVER : (this.BUnit.toString() + this.buyTypeToString));
                case 3:
                    return ((this.CUnit == 0) ? FOREVER : (this.CUnit.toString() + this.buyTypeToString));
            };
            return ("");
        }

        public function get buyTypeToString():String
        {
            if (this.BuyType == 0)
            {
                return (DAY);
            };
            return (AMOUNT);
        }

        public function get LimitCount():int
        {
            return (this._count);
        }

        public function set LimitCount(_arg_1:int):void
        {
            if (this._count == _arg_1)
            {
                return;
            };
            this._count = _arg_1;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get StartDate():String
        {
            return (this.startDate);
        }

        public function set StartDate(_arg_1:String):void
        {
            this.startDate = _arg_1;
            this.startData_D = DateUtils.dealWithStringDate(this.startDate.replace("T", " "));
        }

        public function get EndDate():String
        {
            return (this.endDate);
        }

        public function set EndDate(_arg_1:String):void
        {
            this.endDate = _arg_1;
            this.endDate_D = DateUtils.dealWithStringDate(this.endDate.replace("T", " "));
        }

        public function set isBuy(_arg_1:Boolean):void
        {
            this._isBuy = _arg_1;
        }

        public function get isBuy():Boolean
        {
            return (this._isBuy);
        }


    }
}//package ddt.data.goods

