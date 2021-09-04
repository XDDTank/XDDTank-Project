package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class SuidIcon extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static const MAX_EQUIP:int = 6;
      
      private static const SUID_ICON_BITMAP:String = "asset.SuitIcon.Level_";
       
      
      private var _SuidLevelBitmaps:Dictionary;
      
      private var _tipDictions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _bmContainer:Sprite;
      
      private var _playerInfo:PlayerInfo;
      
      private var _tipData:Object;
      
      private var _suidLevel:int;
      
      public function SuidIcon()
      {
         super();
         this._SuidLevelBitmaps = new Dictionary();
         this._tipStyle = "core.SuidTips";
         this._tipGapH = 5;
         this._tipGapV = 5;
         this._tipDictions = "2";
         mouseChildren = true;
         mouseEnabled = false;
         this._bmContainer = new Sprite();
         this._bmContainer.buttonMode = false;
         addChild(this._bmContainer);
         ShowTipManager.Instance.addTip(this);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         var _loc2_:Bitmap = null;
         ShowTipManager.Instance.removeTip(this);
         this.clearnDisplay();
         for(_loc1_ in this._SuidLevelBitmaps)
         {
            _loc2_ = this._SuidLevelBitmaps[_loc1_];
            _loc2_.bitmapData.dispose();
            delete this._SuidLevelBitmaps[_loc1_];
         }
         this._SuidLevelBitmaps = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function setInfo(param1:PlayerInfo) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._playerInfo = param1;
         this.updateLevle();
         this.updateView();
      }
      
      private function updateLevle() : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc7_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc4_:int = int.MAX_VALUE;
         var _loc5_:int = 10;
         while(_loc5_ < 16)
         {
            _loc3_ = this._playerInfo.Bag.getItemAt(_loc5_);
            if(_loc3_ != null)
            {
               _loc1_.push(_loc3_);
            }
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc1_.length)
         {
            _loc2_.push(_loc1_[_loc6_].StrengthenLevel);
            _loc6_++;
         }
         for each(_loc7_ in _loc2_)
         {
            _loc4_ = _loc7_ > _loc4_ ? int(_loc4_) : int(_loc7_);
         }
         if(MAX_EQUIP > _loc1_.length)
         {
            this._suidLevel = 10;
            this._playerInfo.EquipNum = _loc1_.length;
            this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else if(_loc4_ >= 10 && _loc4_ < 20)
         {
            this._playerInfo.EquipNum = 6;
            this._suidLevel = 10;
            this.filters = null;
         }
         else if(_loc4_ >= 20 && _loc4_ < 30)
         {
            this._playerInfo.EquipNum = 6;
            this._suidLevel = 20;
            this.filters = null;
         }
         else if(_loc4_ >= 30 && _loc4_ < 35)
         {
            this._playerInfo.EquipNum = 6;
            this._suidLevel = 30;
            this.filters = null;
         }
         else if(_loc4_ >= 35 && _loc4_ < 40)
         {
            this._playerInfo.EquipNum = 6;
            this._suidLevel = 35;
            this.filters = null;
         }
         else if(_loc4_ >= 40 && _loc4_ < 45)
         {
            this._playerInfo.EquipNum = 6;
            this._suidLevel = 40;
            this.filters = null;
         }
         else if(_loc4_ >= 45 && _loc4_ < 50)
         {
            this._playerInfo.EquipNum = 6;
            this._suidLevel = 45;
            this.filters = null;
         }
         else if(_loc4_ >= 50 && _loc4_ < 55)
         {
            this._playerInfo.EquipNum = 6;
            this._suidLevel = 50;
            this.filters = null;
         }
         else if(_loc4_ >= 55)
         {
            this._playerInfo.EquipNum = 6;
            this._suidLevel = 55;
            this.filters = null;
         }
         else
         {
            this._suidLevel = 10;
            this._playerInfo.EquipNum = 1;
            this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         this._playerInfo.SuidLevel = this._suidLevel;
         this.tipData = this._playerInfo;
      }
      
      private function updateView() : void
      {
         this.clearnDisplay();
         this.addSuitLevelBitmap();
      }
      
      private function clearnDisplay() : void
      {
         while(this._bmContainer.numChildren > 0)
         {
            this._bmContainer.removeChildAt(0);
         }
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDictions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDictions = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      private function addSuitLevelBitmap() : void
      {
         addChild(this._bmContainer);
         this._bmContainer.addChild(this.creatSuitBitmap(this._suidLevel));
      }
      
      private function creatSuitBitmap(param1:int) : Bitmap
      {
         if(this._SuidLevelBitmaps[param1])
         {
            return this._SuidLevelBitmaps[param1];
         }
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap(SUID_ICON_BITMAP + param1.toString());
         _loc2_.smoothing = true;
         this._SuidLevelBitmaps[param1] = _loc2_;
         return _loc2_;
      }
   }
}
