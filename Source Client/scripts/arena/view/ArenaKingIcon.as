package arena.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ArenaKingIcon extends Sprite implements ITipedDisplay, Disposeable
   {
       
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _tipData:String;
      
      private var _size:int;
      
      private var _iconM:MovieClip;
      
      private var _iconF:MovieClip;
      
      private var _info:PlayerInfo;
      
      public function ArenaKingIcon(param1:PlayerInfo)
      {
         super();
         this._info = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         if(this._info.Sex)
         {
            this._iconM = ComponentFactory.Instance.creat("movieclip.ddtarena.kingiocnM") as MovieClip;
            addChild(this._iconM);
         }
         else
         {
            this._iconF = ComponentFactory.Instance.creat("movieclip.ddtarena.kingiocnF") as MovieClip;
            addChild(this._iconF);
         }
         this._tipStyle = "ddt.view.tips.OneLineTip";
         this._tipGapV = 10;
         this._tipGapH = 10;
         this._tipDirctions = "7,4,6,5";
         this.tipData = LanguageMgr.GetTranslation("ddt.arena.arena.kingiconTips");
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1 as String;
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return null;
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._iconM);
         this._iconM = null;
         ObjectUtils.disposeObject(this._iconF);
         this._iconF = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
