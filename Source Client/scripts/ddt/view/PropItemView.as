package ddt.view
{
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.PropInfo;
   import ddt.manager.BitmapManager;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Dictionary;
   
   public class PropItemView extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static const OVER:String = "over";
      
      public static const OUT:String = "out";
      
      public static var _prop:Dictionary;
       
      
      private var _info:PropInfo;
      
      private var _asset:Bitmap;
      
      private var _isExist:Boolean;
      
      private var _tipStyle:String;
      
      private var _tipData:Object;
      
      private var _tipDirctions:String;
      
      private var _tipGapV:int;
      
      private var _tipGapH:int;
      
      public function PropItemView(param1:PropInfo, param2:Boolean = true, param3:Boolean = true, param4:int = 1)
      {
         var info:PropInfo = param1;
         var $isExist:Boolean = param2;
         var $showPrice:Boolean = param3;
         var $count:int = param4;
         super();
         mouseEnabled = true;
         this._info = info;
         this._isExist = $isExist;
         if(!this._isExist)
         {
            filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
         try
         {
            this._asset = createView(this._info.Template.Pic,38,38);
            this._asset.x = 1;
            this._asset.y = 1;
            addChild(this._asset);
         }
         catch(err:Error)
         {
            BitmapManager.LoadPic(loadPicComplete,info.Template);
         }
         this.tipStyle = "core.ToolPropTips";
         this.tipDirctions = "2,7,5,1,6,4";
         this.tipGapV = this.tipGapH = 20;
         var tipInfo:ToolPropInfo = new ToolPropInfo();
         tipInfo.info = info.Template;
         tipInfo.count = $count;
         tipInfo.showTurn = $showPrice;
         tipInfo.showThew = true;
         tipInfo.showCount = true;
         this.tipData = tipInfo;
         ShowTipManager.Instance.addTip(this);
         addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         addEventListener(MouseEvent.MOUSE_OUT,this.__out);
      }
      
      public static function createView(param1:String, param2:int = 62, param3:int = 62, param4:Boolean = true) : Bitmap
      {
         var t:Bitmap = null;
         var wishBtn:Bitmap = null;
         var id:String = param1;
         var width:int = param2;
         var height:int = param3;
         var smoothing:Boolean = param4;
         if(id != "wish")
         {
            try
            {
               t = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop" + id.toString() + "Asset");
            }
            catch(err:Error)
            {
               t = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop32Asset");
            }
            t.smoothing = smoothing;
            t.width = width;
            t.height = height;
            return t;
         }
         wishBtn = ComponentFactory.Instance.creatBitmap("asset.game.wishBtn");
         wishBtn.smoothing = smoothing;
         wishBtn.width = width;
         wishBtn.height = height;
         return wishBtn;
      }
      
      public function get info() : PropInfo
      {
         return this._info;
      }
      
      private function loadPicComplete(param1:LoaderEvent) : void
      {
         this._asset = param1.loader.content as Bitmap;
         this._asset.width = this._asset.height = 38;
         this._asset.x = 1;
         this._asset.y = 1;
         addChild(this._asset);
      }
      
      private function __out(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(PropItemView.OUT));
      }
      
      private function __over(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(PropItemView.OVER));
      }
      
      public function get isExist() : Boolean
      {
         return this._isExist;
      }
      
      public function dispose() : void
      {
         if(this._asset && this._asset.parent)
         {
            this._asset.parent.removeChild(this._asset);
         }
         this._asset.bitmapData.dispose();
         this._asset = null;
         this._info = null;
         ShowTipManager.Instance.removeTip(this);
         if(parent)
         {
            parent.removeChild(this);
         }
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
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(param1:String) : void
      {
         if(this._tipStyle == param1)
         {
            return;
         }
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         if(this._tipData == param1)
         {
            return;
         }
         this._tipData = param1;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         if(this._tipDirctions == param1)
         {
            return;
         }
         this._tipDirctions = param1;
      }
      
      public function set tipGapV(param1:int) : void
      {
         if(this._tipGapV == param1)
         {
            return;
         }
         this._tipGapV = param1;
      }
      
      public function set tipGapH(param1:int) : void
      {
         if(this._tipGapH == param1)
         {
            return;
         }
         this._tipGapH = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
