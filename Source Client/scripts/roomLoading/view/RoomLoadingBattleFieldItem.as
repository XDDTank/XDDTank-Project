package roomLoading.view
{
   import SingleDungeon.SingleDungeonManager;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import game.GameManager;
   import game.model.GameModeType;
   import room.RoomManager;
   
   public class RoomLoadingBattleFieldItem extends Sprite implements Disposeable
   {
       
      
      private var _mapId:int;
      
      private var _bg:Bitmap;
      
      private var _mapLoader:DisplayLoader;
      
      private var _fieldNameLoader:DisplayLoader;
      
      private var _map:Bitmap;
      
      private var _fieldName:Bitmap;
      
      public function RoomLoadingBattleFieldItem(param1:int = -1)
      {
         var mapId:int = param1;
         super();
         if(RoomManager.Instance.current.mapId > 0)
         {
            mapId = RoomManager.Instance.current.mapId;
         }
         this._mapId = mapId;
         try
         {
            this.init();
         }
         catch(error:Error)
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__onScaleBitmapLoaded);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTCORESCALEBITMAP);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEWCORESCALEBITMAP);
         }
      }
      
      private function __onScaleBitmapLoaded(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTCORESCALEBITMAP)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onScaleBitmapLoaded);
            this.init();
         }
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.BattleFieldBg");
         addChild(this._bg);
         this._mapLoader = LoadResourceManager.instance.createLoader(this.solveMapPath(1),BaseLoader.BITMAP_LOADER);
         this._mapLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoadResourceManager.instance.startLoad(this._mapLoader);
         this._fieldNameLoader = LoadResourceManager.instance.createLoader(this.solveMapPath(2),BaseLoader.BITMAP_LOADER);
         this._fieldNameLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         if(GameManager.Instance.Current.gameMode != GameModeType.SINGLE_DUNGOEN)
         {
            LoadResourceManager.instance.startLoad(this._fieldNameLoader);
         }
      }
      
      private function __onLoadComplete(param1:LoaderEvent) : void
      {
         if(param1.currentTarget.isSuccess)
         {
            if(param1.currentTarget == this._mapLoader)
            {
               this._map = PositionUtils.setPos(Bitmap(this._mapLoader.content),"roomLoading.BattleFieldItemMapPos");
               this._map = Bitmap(this._mapLoader.content);
            }
            else if(param1.currentTarget == this._fieldNameLoader)
            {
               this._fieldName = PositionUtils.setPos(Bitmap(this._fieldNameLoader.content),"roomLoading.BattleFieldItemNamePos");
               this._fieldName = Bitmap(this._fieldNameLoader.content);
            }
         }
         if(this._map)
         {
            addChild(this._map);
         }
         if(this._fieldName)
         {
            addChild(this._fieldName);
         }
      }
      
      private function solveMapPath(param1:int) : String
      {
         var _loc2_:String = "samll_map";
         if(param1 == 2)
         {
            _loc2_ = "icon";
         }
         else if(GameManager.Instance.Current && GameManager.Instance.Current.gameMode == GameModeType.SINGLE_DUNGOEN)
         {
            _loc2_ = "1";
         }
         var _loc3_:String = PathManager.SITE_MAIN + "image/map/";
         var _loc4_:String = PathManager.SITE_MAIN + "image/world/missionselect/dungeon/";
         if(GameManager.Instance.Current && GameManager.Instance.Current.gameMode == 8)
         {
            return _loc3_ + ("1133/" + _loc2_ + ".png");
         }
         if(GameManager.Instance.Current && GameManager.Instance.Current.gameMode == GameModeType.SINGLE_DUNGOEN)
         {
            _loc4_ += SingleDungeonManager.Instance._singleDungeonWalkMapModel._mapSceneModel.Path;
            return _loc4_ + ("/" + _loc2_ + ".png");
         }
         return _loc3_ + (this._mapId.toString() + "/" + _loc2_ + ".png");
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._mapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         this._fieldNameLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
