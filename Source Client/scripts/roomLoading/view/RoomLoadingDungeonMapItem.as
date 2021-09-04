package roomLoading.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.GameManager;
   import room.RoomManager;
   
   public class RoomLoadingDungeonMapItem extends Sprite implements Disposeable
   {
       
      
      private var _displayMc:MovieClip;
      
      private var _itemFrame:DisplayObject;
      
      private var _item:Sprite;
      
      private var _mapLoader:DisplayLoader;
      
      public function RoomLoadingDungeonMapItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._item = new Sprite();
         this._itemFrame = ComponentFactory.Instance.creat("asset.roomLoading.DungeonMapFrame");
         this._displayMc = ComponentFactory.Instance.creat("asset.roomloading.displayMC");
         this._mapLoader = LoadResourceManager.instance.createLoader(this.solveMapPath(),BaseLoader.MODULE_LOADER);
         this._mapLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoadResourceManager.instance.startLoad(this._mapLoader);
      }
      
      private function __onLoadComplete(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:MovieClip = null;
         if(this._mapLoader.isSuccess)
         {
            this._mapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
            _loc2_ = RoomManager.Instance.current.pic;
            _loc3_ = ClassUtils.getDefinition("game.show." + _loc2_) as Class;
            _loc4_ = new _loc3_() as MovieClip;
            _loc4_.stop();
            addChild(_loc4_);
            PositionUtils.setPos(this._displayMc,"asset.roomLoading.DungeonMapLoaderPos");
            this._displayMc.scaleX = this._item.scaleX = -1;
            this._displayMc["character"].addChild(this._item);
            this._displayMc.gotoAndPlay("appear1");
            addChild(this._displayMc);
         }
      }
      
      private function solveMapPath() : String
      {
         var _loc1_:String = PathManager.SITE_MAIN + "image/game/living";
         if(GameManager.Instance.Current.gameMode == 8)
         {
            return _loc1_ + "1133/show.jpg";
         }
         var _loc2_:String = RoomManager.Instance.current.pic;
         var _loc3_:String = _loc2_.toLocaleLowerCase();
         return _loc1_ + ("/" + _loc3_ + ".swf");
      }
      
      public function disappear() : void
      {
         this._displayMc.gotoAndPlay("disappear1");
      }
      
      public function dispose() : void
      {
         this._mapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         ObjectUtils.disposeAllChildren(this);
         this._mapLoader = null;
         this._displayMc = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
