package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import totem.TotemManager;
   
   public class TotemIcon extends Sprite implements ITipedDisplay, Disposeable
   {
       
      
      private var _iconBitmap:Bitmap;
      
      private var _levelTxt:FilterFrameText;
      
      private var _tipDictions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _playerInfo:PlayerInfo;
      
      private var _tipData:Object;
      
      private var _Level:int;
      
      public function TotemIcon()
      {
         super();
         this._iconBitmap = ComponentFactory.Instance.creatBitmap("asset.ddtbagAndInfo.TotemIcon");
         addChild(this._iconBitmap);
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.TotemIcon.text");
         addChild(this._levelTxt);
         this._tipStyle = "core.TotemIconTips";
         this._tipGapH = 5;
         this._tipGapV = 5;
         this._tipDictions = "2,1,0";
         mouseChildren = true;
         mouseEnabled = true;
         ShowTipManager.Instance.addTip(this);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         if(this._iconBitmap)
         {
            ObjectUtils.disposeObject(this._iconBitmap);
            this._iconBitmap = null;
         }
         if(this._levelTxt)
         {
            ObjectUtils.disposeObject(this._levelTxt);
            this._levelTxt = null;
         }
         this._playerInfo = null;
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
         var _loc2_:int = TotemManager.instance.getTotemPointLevel(this._playerInfo.totemId);
         this._Level = TotemManager.instance.getCurrentLv(_loc2_);
         this._levelTxt.text = this._Level.toString();
         if(this._Level == 0)
         {
            this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this.tipData = "当前没有全部激活整页图腾";
            this._levelTxt.visible = false;
         }
         else
         {
            this.filters = null;
            this.tipData = this._playerInfo;
            this._levelTxt.visible = true;
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
   }
}
