package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.EquipTipPanel;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class VipSpreeView extends Sprite implements Disposeable
   {
      
      public static const HALF_YEAR_NUM:int = 10;
      
      public static const THREE_MONTH_NUM:int = 9;
      
      public static const ONE_MONTH_NUM:int = 9;
       
      
      private var _icon:ScaleFrameImage;
      
      private var _weaponIcon:ScaleFrameImage;
      
      private var _spreeItem:Vector.<SpreeItem>;
      
      private var type:int;
      
      private var _spreeTip:GoodTip;
      
      private var _equipTip:EquipTipPanel;
      
      private var _vipInformation:Array;
      
      private var _itemX:int;
      
      private var _rechargeItem:int;
      
      private var _ReceiveBg:Bitmap;
      
      public function VipSpreeView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._icon = ComponentFactory.Instance.creatComponentByStylename("ddtvip.SpreeIcon");
         addChild(this._icon);
         this._weaponIcon = ComponentFactory.Instance.creatComponentByStylename("ddtvip.weaponIcon");
         addChild(this._weaponIcon);
         this._spreeItem = new Vector.<SpreeItem>();
         this._spreeTip = new GoodTip();
         this._equipTip = new EquipTipPanel();
         this._vipInformation = ServerConfigManager.instance.VIPRenewalPrice;
         this._ReceiveBg = ComponentFactory.Instance.creatBitmap("asset.ddtvip.ReceiveAsset");
         PositionUtils.setPos(this._ReceiveBg,"vip.VipFrame.ReceivePos");
         addChild(this._ReceiveBg);
         this._ReceiveBg.visible = false;
         this.updateView(PlayerManager.Instance.Self.VIPLevel);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
      }
      
      private function updateView(param1:int) : void
      {
         if(PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPtype == 2 && param1 <= PlayerManager.Instance.Self.VIPLevel)
         {
            if(this._ReceiveBg)
            {
               this._ReceiveBg.visible = true;
            }
            if(this._icon)
            {
               this._icon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            if(this._weaponIcon)
            {
               this._weaponIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
         }
         else
         {
            if(this._icon)
            {
               this._icon.filters = null;
            }
            if(this._weaponIcon)
            {
               this._weaponIcon.filters = null;
            }
            if(this._ReceiveBg)
            {
               this._ReceiveBg.visible = false;
            }
         }
      }
      
      private function __upVip(param1:Event) : void
      {
         this.updateView(PlayerManager.Instance.Self.VIPLevel);
      }
      
      public function setView(param1:int) : void
      {
         this.type = param1;
         if(this.type == 6)
         {
            this._icon.setFrame(1);
            this._weaponIcon.setFrame(1);
            this.updateView(this.type - 1);
            this.creatItem(HALF_YEAR_NUM);
            this.setTip(this.type);
         }
         else if(this.type == 3)
         {
            this._icon.setFrame(2);
            this._weaponIcon.setFrame(2);
            this.updateView(this.type);
            this.creatItem(THREE_MONTH_NUM);
            this.setTip(this.type);
         }
         else if(this.type == 1)
         {
            this._icon.setFrame(3);
            this._weaponIcon.setFrame(3);
            this.updateView(this.type);
            this.creatItem(ONE_MONTH_NUM);
            this.setTip(this.type);
         }
      }
      
      private function setTip(param1:int) : void
      {
         var _loc3_:ItemTemplateInfo = null;
         var _loc4_:ItemTemplateInfo = null;
         var _loc2_:GoodTipInfo = new GoodTipInfo();
         var _loc5_:Array = this.resolveArr(param1);
         _loc3_ = ItemManager.Instance.getTemplateById(int(_loc5_[1]));
         _loc4_ = ItemManager.Instance.getTemplateById(int(_loc5_[2]));
         _loc2_.itemInfo = _loc3_;
         this._spreeTip.tipData = _loc2_;
         this._equipTip.tipData = _loc4_;
         this._spreeTip.visible = false;
         this._equipTip.visible = false;
         this._icon.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._icon.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         this._weaponIcon.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandlerI);
         this._weaponIcon.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandlerI);
      }
      
      private function __mouseOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._spreeTip)
         {
            this._spreeTip.visible = true;
            LayerManager.Instance.addToLayer(this._spreeTip,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this._icon.localToGlobal(new Point(0,0));
            this._spreeTip.x = _loc2_.x + this._icon.width;
            this._spreeTip.y = _loc2_.y;
         }
      }
      
      private function __mouseOutHandler(param1:MouseEvent) : void
      {
         if(this._spreeTip)
         {
            this._spreeTip.visible = false;
         }
      }
      
      private function __mouseOverHandlerI(param1:MouseEvent) : void
      {
         if(this._equipTip)
         {
            this._equipTip.visible = true;
            LayerManager.Instance.addToLayer(this._equipTip,LayerManager.GAME_TOP_LAYER);
            PositionUtils.setPos(this._equipTip,"vip.VipFrame.weaponTipPos");
         }
      }
      
      private function __mouseOutHandlerI(param1:MouseEvent) : void
      {
         if(this._equipTip)
         {
            this._equipTip.visible = false;
         }
      }
      
      public function VIPRechargeView(param1:int) : void
      {
         this.type = param1;
         if(this.type == 6)
         {
            this._icon.setFrame(1);
            this._weaponIcon.setFrame(1);
            this.creatRechargeItem(HALF_YEAR_NUM);
            this.setTip(this.type);
         }
         else if(this.type == 3)
         {
            this._icon.setFrame(2);
            this._weaponIcon.setFrame(2);
            this.creatRechargeItem(THREE_MONTH_NUM);
            this.setTip(this.type);
         }
         else if(this.type == 1)
         {
            this._icon.setFrame(3);
            this._weaponIcon.setFrame(3);
            this.creatRechargeItem(ONE_MONTH_NUM);
            this.setTip(this.type);
         }
      }
      
      private function creatRechargeItem(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            this._spreeItem[_loc2_] = ComponentFactory.Instance.creatCustomObject("vip.SpreeItem");
            this._spreeItem[_loc2_].setItem(_loc2_);
            if(_loc2_ < 4)
            {
               this._spreeItem[_loc2_].x = 226 + 56 * _loc2_;
               this._spreeItem[_loc2_].y = 2;
            }
            else if(_loc2_ < 10)
            {
               this._spreeItem[_loc2_].x = 1 + 57 * (_loc2_ - 4);
               this._spreeItem[_loc2_].y = 77;
            }
            else
            {
               this._spreeItem[_loc2_].x = 1 + 57 * (_loc2_ - 10);
               this._spreeItem[_loc2_].y = 152;
            }
            addChild(this._spreeItem[_loc2_]);
            _loc2_++;
         }
      }
      
      private function creatItem(param1:int) : void
      {
         this.clearItem();
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            this._spreeItem[_loc2_] = ComponentFactory.Instance.creatCustomObject("vip.SpreeItem");
            this._spreeItem[_loc2_].setItem(_loc2_);
            if(_loc2_ < 4)
            {
               this._spreeItem[_loc2_].x = 230 + 56 * _loc2_;
               this._spreeItem[_loc2_].y = 2;
            }
            else if(_loc2_ < 10)
            {
               this._spreeItem[_loc2_].x = -1 + 57 * (_loc2_ - 4);
               this._spreeItem[_loc2_].y = 76;
            }
            else
            {
               this._spreeItem[_loc2_].x = -1 + 66 * (_loc2_ - 10);
               this._spreeItem[_loc2_].y = 144;
            }
            addChild(this._spreeItem[_loc2_]);
            _loc2_++;
         }
      }
      
      private function clearItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._spreeItem.length)
         {
            if(this._spreeItem[_loc1_])
            {
               this._spreeItem[_loc1_].dispose();
               this._spreeItem[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      private function resolveArr(param1:int) : Array
      {
         var _loc2_:String = null;
         if(param1 == 6)
         {
            _loc2_ = this._vipInformation[2];
            return _loc2_.split("|");
         }
         if(param1 == 3)
         {
            _loc2_ = this._vipInformation[1];
            return _loc2_.split("|");
         }
         if(param1 == 1)
         {
            _loc2_ = this._vipInformation[0];
            return _loc2_.split("|");
         }
         return null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         var _loc1_:int = 0;
         while(_loc1_ < this._spreeItem.length)
         {
            ObjectUtils.disposeObject(this._spreeItem[_loc1_]);
            this._spreeItem[_loc1_] = null;
            _loc1_++;
         }
         this._spreeItem = null;
         ObjectUtils.disposeObject(this._ReceiveBg);
         this._ReceiveBg = null;
         if(this._icon)
         {
            this._icon.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
            this._icon.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
         if(this._weaponIcon)
         {
            this._weaponIcon.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandlerI);
            this._weaponIcon.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandlerI);
            ObjectUtils.disposeObject(this._weaponIcon);
            this._weaponIcon = null;
         }
         if(this._spreeTip)
         {
            ObjectUtils.disposeObject(this._spreeTip);
            this._spreeTip = null;
         }
         if(this._equipTip)
         {
            ObjectUtils.disposeObject(this._equipTip);
            this._equipTip = null;
         }
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
