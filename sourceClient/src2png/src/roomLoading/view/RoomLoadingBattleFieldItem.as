// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomLoading.view.RoomLoadingBattleFieldItem

package roomLoading.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.loader.DisplayLoader;
    import room.RoomManager;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import game.GameManager;
    import game.model.GameModeType;
    import ddt.utils.PositionUtils;
    import ddt.manager.PathManager;
    import SingleDungeon.SingleDungeonManager;
    import com.pickgliss.utils.ObjectUtils;

    public class RoomLoadingBattleFieldItem extends Sprite implements Disposeable 
    {

        private var _mapId:int;
        private var _bg:Bitmap;
        private var _mapLoader:DisplayLoader;
        private var _fieldNameLoader:DisplayLoader;
        private var _map:Bitmap;
        private var _fieldName:Bitmap;

        public function RoomLoadingBattleFieldItem(mapId:int=-1)
        {
            super();
            if (RoomManager.Instance.current.mapId > 0)
            {
                mapId = RoomManager.Instance.current.mapId;
            };
            this._mapId = mapId;
            try
            {
                this.init();
            }
            catch(error:Error)
            {
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, __onScaleBitmapLoaded);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTCORESCALEBITMAP);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEWCORESCALEBITMAP);
            };
        }

        private function __onScaleBitmapLoaded(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTCORESCALEBITMAP)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onScaleBitmapLoaded);
                this.init();
            };
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.BattleFieldBg");
            addChild(this._bg);
            this._mapLoader = LoadResourceManager.instance.createLoader(this.solveMapPath(1), BaseLoader.BITMAP_LOADER);
            this._mapLoader.addEventListener(LoaderEvent.COMPLETE, this.__onLoadComplete);
            LoadResourceManager.instance.startLoad(this._mapLoader);
            this._fieldNameLoader = LoadResourceManager.instance.createLoader(this.solveMapPath(2), BaseLoader.BITMAP_LOADER);
            this._fieldNameLoader.addEventListener(LoaderEvent.COMPLETE, this.__onLoadComplete);
            if (GameManager.Instance.Current.gameMode != GameModeType.SINGLE_DUNGOEN)
            {
                LoadResourceManager.instance.startLoad(this._fieldNameLoader);
            };
        }

        private function __onLoadComplete(_arg_1:LoaderEvent):void
        {
            if (_arg_1.currentTarget.isSuccess)
            {
                if (_arg_1.currentTarget == this._mapLoader)
                {
                    this._map = PositionUtils.setPos(Bitmap(this._mapLoader.content), "roomLoading.BattleFieldItemMapPos");
                    this._map = Bitmap(this._mapLoader.content);
                }
                else
                {
                    if (_arg_1.currentTarget == this._fieldNameLoader)
                    {
                        this._fieldName = PositionUtils.setPos(Bitmap(this._fieldNameLoader.content), "roomLoading.BattleFieldItemNamePos");
                        this._fieldName = Bitmap(this._fieldNameLoader.content);
                    };
                };
            };
            if (this._map)
            {
                addChild(this._map);
            };
            if (this._fieldName)
            {
                addChild(this._fieldName);
            };
        }

        private function solveMapPath(_arg_1:int):String
        {
            var _local_2:String = "samll_map";
            if (_arg_1 == 2)
            {
                _local_2 = "icon";
            }
            else
            {
                if (((GameManager.Instance.Current) && (GameManager.Instance.Current.gameMode == GameModeType.SINGLE_DUNGOEN)))
                {
                    _local_2 = "1";
                };
            };
            var _local_3:String = (PathManager.SITE_MAIN + "image/map/");
            var _local_4:String = (PathManager.SITE_MAIN + "image/world/missionselect/dungeon/");
            if (((GameManager.Instance.Current) && (GameManager.Instance.Current.gameMode == 8)))
            {
                return (_local_3 + (("1133/" + _local_2) + ".png"));
            };
            if (((GameManager.Instance.Current) && (GameManager.Instance.Current.gameMode == GameModeType.SINGLE_DUNGOEN)))
            {
                _local_4 = (_local_4 + SingleDungeonManager.Instance._singleDungeonWalkMapModel._mapSceneModel.Path);
                return (_local_4 + (("/" + _local_2) + ".png"));
            };
            return (_local_3 + (((this._mapId.toString() + "/") + _local_2) + ".png"));
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._mapLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onLoadComplete);
            this._fieldNameLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onLoadComplete);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package roomLoading.view

