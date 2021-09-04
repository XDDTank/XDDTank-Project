package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ExchangeGoodsFrame extends Frame
   {
       
      
      public var canDispose:Boolean;
      
      private var _view:ExchangeGoodsFrameView;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _submitButton:TextButton;
      
      private var _unitPrice:Number;
      
      private var _buyFrom:int;
      
      public function ExchangeGoodsFrame()
      {
         super();
         this.canDispose = true;
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._view = new ExchangeGoodsFrameView();
         addToContent(this._view);
         this._submitButton = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
         this._submitButton.text = LanguageMgr.GetTranslation("tank.littlegame.exchange");
         this._view.addChild(this._submitButton);
         escEnable = true;
         enterEnable = true;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.addEventListener(MouseEvent.CLICK,this.doPay);
         this._view.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function removeEvnets() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(this._submitButton)
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this.doPay);
         }
         if(this._view)
         {
            this._view.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         }
         removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function _numberClose(param1:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         this.doPay(null);
      }
      
      public function set stoneNumber(param1:int) : void
      {
         this._view.stoneNumber = param1;
      }
      
      public function set maxLimit(param1:int) : void
      {
         this._view.maxLimit = param1;
      }
      
      public function set ItemInfo(param1:ShopItemInfo) : void
      {
         this._view.shopInfo = param1;
         this._shopItemInfo = param1;
         this.perPrice();
      }
      
      private function perPrice() : void
      {
         this._unitPrice = this._shopItemInfo.AValue1;
      }
      
      private function doPay(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         if(PlayerManager.Instance.Self.damageScores < this._view.stoneNumber * this._unitPrice)
         {
            return MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.littlegame.scorelack"));
         }
         _loc2_ = new Array();
         _loc3_ = new Array();
         _loc4_ = new Array();
         _loc5_ = new Array();
         _loc6_ = new Array();
         _loc7_ = 0;
         while(_loc7_ < this._view.stoneNumber)
         {
            _loc2_.push(this._shopItemInfo.GoodsID);
            _loc3_.push(1);
            _loc4_.push("");
            _loc5_.push("");
            _loc6_.push("");
            _loc7_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
         this.dispose();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.doPay(null);
         }
         else
         {
            this.dispose();
         }
      }
      
      public function setTitleText(param1:String) : void
      {
         titleText = param1;
      }
      
      override public function dispose() : void
      {
         this.removeEvnets();
         this.canDispose = false;
         super.dispose();
         this._view = null;
         this._shopItemInfo = null;
         if(this._submitButton)
         {
            ObjectUtils.disposeObject(this._submitButton);
         }
         this._submitButton = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
