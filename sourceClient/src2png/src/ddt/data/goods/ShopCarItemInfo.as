// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.goods.ShopCarItemInfo

package ddt.data.goods
{
    import flash.events.Event;

    public class ShopCarItemInfo extends ShopItemInfo 
    {

        private var _currentBuyType:int = 1;
        private var _color:String = "";
        public var dressing:Boolean;
        public var ModelSex:Boolean;
        public var colorValue:String = "";
        public var place:int;
        public var skin:String = "";

        public function ShopCarItemInfo(_arg_1:int, _arg_2:int, _arg_3:int=0)
        {
            super(_arg_1, _arg_2);
            this.currentBuyType = 1;
            if (_arg_3 == 14)
            {
                this.currentBuyType = 2;
            };
            this.dressing = false;
        }

        public function set Property8(_arg_1:String):void
        {
            super.TemplateInfo.Property8 = _arg_1;
            var _local_2:int;
            while (_local_2 < (_arg_1.length - 1))
            {
                this._color = (this._color + "|");
                _local_2++;
            };
        }

        public function get Property8():String
        {
            return (super.TemplateInfo.Property8);
        }

        public function get CategoryID():int
        {
            return (TemplateInfo.CategoryID);
        }

        public function get Color():String
        {
            return (this._color);
        }

        public function set Color(_arg_1:String):void
        {
            if (this._color != _arg_1)
            {
                this._color = _arg_1;
                dispatchEvent(new Event(Event.CHANGE));
            };
        }

        public function set currentBuyType(_arg_1:int):void
        {
            this._currentBuyType = _arg_1;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get currentBuyType():int
        {
            return (this._currentBuyType);
        }

        public function getCurrentPrice():ItemPrice
        {
            return (getItemPrice(this._currentBuyType));
        }


    }
}//package ddt.data.goods

