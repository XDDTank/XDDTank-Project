package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import fightToolBox.FightToolBoxController;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class FightToolBoxIcon extends Sprite implements Disposeable, ITipedDisplay
   {
      
      public static const ICON_BITMAP:String = "asset.FightToolBoxIcon.Level_";
       
      
      private var _bitmapDic:DictionaryData;
      
      private var _tipDictions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _bmContainer:Sprite;
      
      private var _tipData:Object;
      
      private var _clickEnable:Boolean = true;
      
      private var _playerInfo:PlayerInfo;
      
      public function FightToolBoxIcon()
      {
         super();
         this._bitmapDic = new DictionaryData();
         this._tipStyle = "core.FightToolBoxTips";
         this._tipGapH = 5;
         this._tipGapV = 5;
         this._tipDictions = "2,1,0";
         mouseChildren = true;
         mouseEnabled = false;
         this._bmContainer = new Sprite();
         this._bmContainer.buttonMode = true;
         addChild(this._bmContainer);
         ShowTipManager.Instance.addTip(this);
         addEventListener(MouseEvent.CLICK,this.__showVipFrame);
      }
      
      public function setClick(param1:Boolean) : void
      {
         this._bmContainer.buttonMode = param1;
         this._clickEnable = param1;
      }
      
      override public function get height() : Number
      {
         return this._bmContainer.height;
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         var _loc2_:Bitmap = null;
         removeEventListener(MouseEvent.CLICK,this.__showVipFrame);
         ShowTipManager.Instance.removeTip(this);
         this.clearnDisplay();
         for(_loc1_ in this._bitmapDic)
         {
            _loc2_ = this._bitmapDic[_loc1_];
            _loc2_.bitmapData.dispose();
            delete this._bitmapDic[_loc1_];
         }
         this._bitmapDic = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function setInfo(param1:PlayerInfo) : void
      {
         if(param1 == null || PlayerManager.Instance.Self.ID != param1.ID && param1.isFightVip == false)
         {
            return;
         }
         this._playerInfo = param1;
         this.tipData = this._playerInfo;
         this.updateView();
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
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function updateView() : void
      {
         this.clearnDisplay();
         this.addBitmap();
      }
      
      private function addBitmap() : void
      {
         this._bmContainer.addChild(this.creatTexpBitmap());
         addChild(this._bmContainer);
      }
      
      private function creatTexpBitmap() : Bitmap
      {
         var _loc1_:int = 3;
         _loc1_ = _loc1_ == 0 ? int(1) : int(_loc1_);
         if(this._bitmapDic[_loc1_])
         {
            return this._bitmapDic[_loc1_];
         }
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap(ICON_BITMAP + _loc1_.toString());
         _loc2_.smoothing = true;
         this._bitmapDic[_loc1_] = _loc2_;
         return _loc2_;
      }
      
      private function __showVipFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._clickEnable)
         {
            FightToolBoxController.instance.show();
         }
      }
      
      private function clearnDisplay() : void
      {
         while(this._bmContainer.numChildren > 0)
         {
            this._bmContainer.removeChildAt(0);
         }
      }
   }
}
