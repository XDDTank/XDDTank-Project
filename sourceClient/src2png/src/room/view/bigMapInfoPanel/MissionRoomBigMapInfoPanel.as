// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.bigMapInfoPanel.MissionRoomBigMapInfoPanel

package room.view.bigMapInfoPanel
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.geom.Point;
    import room.model.RoomInfo;
    import com.pickgliss.loader.DisplayLoader;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.events.RoomEvent;
    import com.pickgliss.ui.ComponentFactory;
    import room.RoomManager;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.MapManager;
    import ddt.data.map.DungeonInfo;
    import flash.events.Event;
    import ddt.manager.PathManager;
    import game.GameManager;

    public class MissionRoomBigMapInfoPanel extends Sprite implements Disposeable 
    {

        protected var _dropList:DropList;
        protected var _pos1:Point;
        protected var _pos2:Point;
        protected var _info:RoomInfo;
        private var _loader:DisplayLoader;
        protected var _initDungeonTemplateIds:String = "420900,420901,420902,420903,420904,420905,420107,11604,15005,11402,11905";

        public function MissionRoomBigMapInfoPanel()
        {
            this.initView();
            this.initEvents();
        }

        protected function initEvents():void
        {
            this._dropList.addEventListener(DropList.LARGE, this.__dropListLarge);
            this._dropList.addEventListener(DropList.SMALL, this.__dropListSmall);
        }

        protected function removeEvents():void
        {
            this._dropList.removeEventListener(DropList.LARGE, this.__dropListLarge);
            this._dropList.removeEventListener(DropList.SMALL, this.__dropListSmall);
            this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__showMap);
            this._info.removeEventListener(RoomEvent.MAP_CHANGED, this.__onMapChanged);
            this._info.removeEventListener(RoomEvent.HARD_LEVEL_CHANGED, this.__updateHard);
        }

        protected function initView():void
        {
            this._pos1 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropListPos1");
            this._pos2 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropListPos2");
            this._dropList = new DropList();
            this._dropList.x = this._pos1.x;
            this._dropList.y = this._pos1.y;
            addChild(this._dropList);
            this._dropList.visible = false;
            this._info = RoomManager.Instance.current;
            if (this._info)
            {
                this._info.addEventListener(RoomEvent.MAP_CHANGED, this.__onMapChanged);
                this._info.addEventListener(RoomEvent.HARD_LEVEL_CHANGED, this.__updateHard);
                this.updateMap();
                this.updateDropList();
            };
        }

        protected function __onMapChanged(_arg_1:RoomEvent):void
        {
            this.updateMap();
            this.updateDropList();
        }

        protected function __updateHard(_arg_1:RoomEvent):void
        {
            this.updateDropList();
        }

        protected function updateMap():void
        {
            if (this._loader)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__showMap);
            };
            this._loader = LoadResourceManager.instance.createLoader(this.solvePath(), BaseLoader.BITMAP_LOADER);
            this._loader.addEventListener(LoaderEvent.COMPLETE, this.__showMap);
            LoadResourceManager.instance.startLoad(this._loader);
        }

        private function __showMap(_arg_1:LoaderEvent):void
        {
            if (_arg_1.loader.isSuccess)
            {
                _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__showMap);
            };
        }

        protected function updateDropList():void
        {
            var _local_1:DungeonInfo = MapManager.getDungeonInfo(this._info.mapId);
            if (((!(this._info.mapId == 0)) && (!(this._info.mapId == 10000))))
            {
                switch (this._info.hardLevel)
                {
                    case RoomInfo.EASY:
                        this._dropList.info = _local_1.SimpleTemplateIds.split(",");
                        break;
                    case RoomInfo.NORMAL:
                        this._dropList.info = _local_1.NormalTemplateIds.split(",");
                        break;
                    case RoomInfo.HARD:
                        this._dropList.info = _local_1.HardTemplateIds.split(",");
                        break;
                    case RoomInfo.HERO:
                        this._dropList.info = _local_1.TerrorTemplateIds.split(",");
                        break;
                };
                this._dropList.visible = true;
            }
            else
            {
                this._dropList.info = this._initDungeonTemplateIds.split(",");
                this._dropList.visible = true;
            };
        }

        private function __dropListLarge(_arg_1:Event):void
        {
            this._dropList.x = this._pos2.x;
            this._dropList.y = this._pos2.y;
        }

        private function __dropListSmall(_arg_1:Event):void
        {
            this._dropList.x = this._pos1.x;
            this._dropList.y = this._pos1.y;
        }

        protected function solvePath():String
        {
            var _local_1:String = "";
            if (RoomManager.Instance.current.isOpenBoss)
            {
                _local_1 = ((((PathManager.SITE_MAIN + "image/map/") + this._info.mapId) + "/") + RoomManager.Instance.current.pic);
            }
            else
            {
                _local_1 = ((((PathManager.SITE_MAIN + "image/map/") + this._info.mapId) + "/") + GameManager.Instance.Current.missionInfo.pic);
            };
            return (_local_1);
        }

        public function dispose():void
        {
            this.removeEvents();
            if (this._dropList != null)
            {
                this._dropList.dispose();
            };
            this._dropList = null;
            if (this._loader != null)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__showMap);
            };
            this._loader = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view.bigMapInfoPanel

