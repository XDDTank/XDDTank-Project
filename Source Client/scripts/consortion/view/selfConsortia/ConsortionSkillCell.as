package consortion.view.selfConsortia
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortionNewSkillInfo;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ConsortionSkillCell extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _info:ConsortionNewSkillInfo;
      
      private var _tipData:Object;
      
      private var _bg:Bitmap;
      
      private var _titleLoader:DisplayLoader;
      
      public function ConsortionSkillCell()
      {
         super();
         buttonMode = true;
         ShowTipManager.Instance.addTip(this);
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set info(param1:ConsortionNewSkillInfo) : void
      {
         this._info = param1;
         if(this._titleLoader)
         {
            this._titleLoader = null;
         }
         this._titleLoader = LoadResourceManager.instance.createLoader(this.path(),BaseLoader.BITMAP_LOADER);
         this._titleLoader.addEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         LoadResourceManager.instance.startLoad(this._titleLoader);
         this.tipData = this._info;
      }
      
      private function __completeHandler(param1:LoaderEvent) : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(param1.loader.isSuccess)
         {
            param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
            this._bg = param1.loader.content as Bitmap;
            PositionUtils.setPos(this._bg,"asset.consortion.skillIcon.pos");
            this.contentRect(54,54);
            addChild(this._bg);
            this._bg.smoothing = true;
         }
      }
      
      private function path() : String
      {
         return PathManager.SITE_MAIN + "/image/" + this._info.Pic + "/icon.png";
      }
      
      public function get info() : ConsortionNewSkillInfo
      {
         return this._info;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function isLearn(param1:Boolean) : void
      {
         if(param1)
         {
            this.filters = null;
         }
         else
         {
            this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function contentRect(param1:int, param2:int) : void
      {
         this._bg.width = param1;
         this._bg.height = param2;
      }
      
      public function setGray(param1:Boolean) : void
      {
         if(!param1)
         {
            this.filters = null;
         }
      }
      
      public function get tipDirctions() : String
      {
         return "0,1,2";
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "ddt.view.tips.SkillTipPanel";
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function get tipWidth() : int
      {
         return 200;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function get tipHeight() : int
      {
         return -1;
      }
      
      public function set tipHeight(param1:int) : void
      {
      }
   }
}
