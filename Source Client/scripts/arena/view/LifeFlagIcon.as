package arena.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class LifeFlagIcon extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _tipData:String;
      
      private var _lifeFlag:Bitmap;
      
      public function LifeFlagIcon()
      {
         super();
         this._tipStyle = "ddt.view.tips.OneLineTip";
         this._tipGapV = 10;
         this._tipGapH = 10;
         this._tipDirctions = "7,4,6,5";
         buttonMode = true;
         this._lifeFlag = ComponentFactory.Instance.creatBitmap("bitmap.ddtarena.lifeflag");
         addChild(this._lifeFlag);
         ShowTipManager.Instance.addTip(this);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._lifeFlag);
         this._lifeFlag = null;
      }
      
      public function get tipData() : Object
      {
         return LanguageMgr.GetTranslation("ddt.arena.LifeFlagIconTips");
      }
      
      public function set tipData(param1:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return null;
      }
   }
}
