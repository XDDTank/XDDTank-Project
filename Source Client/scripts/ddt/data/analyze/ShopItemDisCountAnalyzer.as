package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class ShopItemDisCountAnalyzer extends DataAnalyzer
   {
       
      
      private var _xml:XML;
      
      private var _shoplist:XMLList;
      
      public var shopDisCountGoods:Dictionary;
      
      private var index:int = -1;
      
      private var _timer:Timer;
      
      public function ShopItemDisCountAnalyzer(param1:Function)
      {
         super(param1);
         this.shopDisCountGoods = new Dictionary();
      }
      
      override public function analyze(param1:*) : void
      {
         this._xml = new XML(param1);
         if(this._xml.@value == "true")
         {
            this._shoplist = this._xml..Item;
            this.parseShop();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
      
      private function parseShop() : void
      {
         this._timer = new Timer(30);
         this._timer.addEventListener(TimerEvent.TIMER,this.__partexceute);
         this._timer.start();
      }
      
      private function __partexceute(param1:TimerEvent) : void
      {
         var _loc3_:ShopItemInfo = null;
         if(!ShopManager.Instance.initialized)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 40)
         {
            ++this.index;
            if(this.index >= this._shoplist.length())
            {
               this._timer.removeEventListener(TimerEvent.TIMER,this.__partexceute);
               this._timer.stop();
               this._timer = null;
            }
            continue;
            onAnalyzeComplete();
            _loc3_ = new ShopItemInfo(int(this._shoplist[this.index].@ID),int(this._shoplist[this.index].@TemplateID));
            ObjectUtils.copyPorpertiesByXML(_loc3_,this._shoplist[this.index]);
            _loc3_.Label = int(this._shoplist[this.index].@LableType);
            _loc3_.AUnit = int(this._shoplist[this.index].@AUnit);
            _loc3_.APrice1 = int(this._shoplist[this.index].@APrice);
            _loc3_.AValue1 = int(this._shoplist[this.index].@AValue);
            _loc3_.BUnit = int(this._shoplist[this.index].@BUnit);
            _loc3_.BPrice1 = int(this._shoplist[this.index].@BPrice);
            _loc3_.BValue1 = int(this._shoplist[this.index].@BValue);
            _loc3_.CUnit = int(this._shoplist[this.index].@CUnit);
            _loc3_.CPrice1 = int(this._shoplist[this.index].@CPrice);
            _loc3_.CValue1 = int(this._shoplist[this.index].@CValue);
            _loc3_.isDiscount = 2;
            _loc3_.APrice2 = _loc3_.APrice3 = _loc3_.APrice1;
            _loc3_.BPrice2 = _loc3_.BPrice3 = _loc3_.BPrice1;
            _loc3_.CPrice2 = _loc3_.CPrice3 = _loc3_.CPrice1;
            this.addList(Math.abs(_loc3_.APrice1),_loc3_);
            _loc2_++;
            return;
         }
      }
      
      private function converMoneyType(param1:ShopItemInfo) : void
      {
         switch(Math.abs(param1.APrice1))
         {
            case 3:
               param1.APrice1 = -1;
               break;
            case 4:
               param1.APrice1 = -2;
         }
         switch(Math.abs(param1.BPrice1))
         {
            case 3:
               param1.BPrice1 = -1;
               break;
            case 4:
               param1.BPrice1 = -2;
               break;
            default:
               param1.BPrice1 = param1.APrice1;
         }
         switch(Math.abs(param1.CPrice1))
         {
            case 3:
               param1.CPrice1 = -1;
               break;
            case 4:
               param1.CPrice1 = -2;
               break;
            default:
               param1.CPrice1 = param1.APrice1;
         }
         param1.APrice2 = param1.APrice3 = param1.APrice1;
         param1.BPrice2 = param1.BPrice3 = param1.BPrice1;
         param1.CPrice2 = param1.CPrice3 = param1.CPrice1;
      }
      
      private function addList(param1:int, param2:ShopItemInfo) : void
      {
         var _loc3_:DictionaryData = this.shopDisCountGoods[param1];
         if(!_loc3_)
         {
            _loc3_ = new DictionaryData();
            this.shopDisCountGoods[param1] = _loc3_;
         }
         _loc3_.add(param2.GoodsID,param2);
      }
   }
}
