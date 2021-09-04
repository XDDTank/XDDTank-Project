package room.view.smallMapInfoPanel
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.RoomEvent;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import room.model.RoomInfo;
   
   public class BaseSmallMapInfoPanel extends Sprite implements Disposeable
   {
      
      protected static const DEFAULT_MAP_ID:String = "10000";
       
      
      protected var _info:RoomInfo;
      
      private var _smallMapIcon:Bitmap;
      
      private var _smallMapContainer:Sprite;
      
      private var _loader:DisplayLoader;
      
      private var _rect:Rectangle;
      
      private var _maskShape:Shape;
      
      protected var _overBg:Bitmap;
      
      private var _rectOver:Rectangle;
      
      protected var _btnAsset:Bitmap;
      
      public function BaseSmallMapInfoPanel()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this._smallMapContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.smallMapInfoPanel.smallMapContainer");
         addChild(this._smallMapContainer);
         this._loader = LoadResourceManager.instance.createLoader(this.solvePath(),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         LoadResourceManager.instance.startLoad(this._loader);
         this._rect = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.smallInfoPanel.imageRect");
         this._maskShape = new Shape();
         this._maskShape.graphics.beginFill(0,0);
         this._maskShape.graphics.drawRect(this._rect.x,this._rect.y,this._rect.width,this._rect.height);
         this._maskShape.graphics.endFill();
         addChild(this._maskShape);
         this._maskShape.x = -1;
         this._btnAsset = ComponentFactory.Instance.creatBitmap("asset.ddtroom.mapBtnAsset");
         addChild(this._btnAsset);
         this._rectOver = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.OverimageRect");
         this._overBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.OverimageAsset");
         this._overBg.width = this._rectOver.width;
         this._overBg.height = this._rectOver.height;
         this._overBg.x = this._rectOver.x;
         this._overBg.y = this._rectOver.y;
         this._overBg.visible = false;
         addChild(this._overBg);
      }
      
      protected function solvePath() : String
      {
         if(this._info && this._info.mapId > 0)
         {
            return PathManager.SITE_MAIN + "image/map/" + this._info.mapId.toString() + "/samll_map.png";
         }
         return PathManager.SITE_MAIN + "image/map/" + DEFAULT_MAP_ID + "/samll_map.png";
      }
      
      protected function __completeHandler(param1:LoaderEvent) : void
      {
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         }
         if(this._loader.isSuccess)
         {
            ObjectUtils.disposeAllChildren(this._smallMapContainer);
            this._smallMapIcon = this._loader.content as Bitmap;
            this._smallMapIcon.mask = this._maskShape;
            this._smallMapContainer.addChild(this._smallMapIcon);
         }
      }
      
      public function set info(param1:RoomInfo) : void
      {
         this._info = param1;
         this._info.addEventListener(RoomEvent.MAP_CHANGED,this.__update);
         this._info.addEventListener(RoomEvent.MAP_TIME_CHANGED,this.__update);
         this._info.addEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__update);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         this.updateView();
      }
      
      protected function __mouseOver(param1:MouseEvent) : void
      {
         if(this._overBg)
         {
            this._overBg.visible = true;
         }
      }
      
      protected function __mouseOut(param1:MouseEvent) : void
      {
         if(this._overBg)
         {
            this._overBg.visible = false;
         }
      }
      
      private function __update(param1:Event) : void
      {
         this.updateView();
      }
      
      protected function updateView() : void
      {
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
            this._loader = null;
         }
         ObjectUtils.disposeAllChildren(this._smallMapContainer);
         this._loader = LoadResourceManager.instance.createLoader(this.solvePath(),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         LoadResourceManager.instance.startLoad(this._loader);
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         this._info.removeEventListener(RoomEvent.MAP_CHANGED,this.__update);
         this._info.removeEventListener(RoomEvent.MAP_TIME_CHANGED,this.__update);
         this._info.removeEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__update);
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         }
         ObjectUtils.disposeObject(this._btnAsset);
         this._btnAsset = null;
         ObjectUtils.disposeObject(this._overBg);
         this._overBg = null;
         this._smallMapIcon = null;
         ObjectUtils.disposeAllChildren(this._smallMapContainer);
         removeChild(this._smallMapContainer);
         this._smallMapContainer = null;
         this._info = null;
         this._loader = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
