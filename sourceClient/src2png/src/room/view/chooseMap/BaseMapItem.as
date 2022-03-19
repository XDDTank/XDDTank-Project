// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.chooseMap.BaseMapItem

package room.view.chooseMap
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.loader.DisplayLoader;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.PathManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.map.DungeonInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.MapManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import flash.events.Event;

    public class BaseMapItem extends Sprite implements Disposeable 
    {

        protected var _mapId:int = -1;
        protected var _selected:Boolean;
        protected var _bg:Bitmap;
        protected var _mapIconContaioner:Sprite;
        protected var _selectedBg:Scale9CornerImage;
        protected var _loader:DisplayLoader;

        public function BaseMapItem()
        {
            this.initView();
            this.initEvents();
        }

        override public function get height():Number
        {
            return (Math.max(this._bg.height, this._selectedBg.height));
        }

        override public function get width():Number
        {
            return (Math.max(this._bg.width, this._selectedBg.width));
        }

        protected function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.room.mapItemBgAsset");
            addChild(this._bg);
            this._mapIconContaioner = new Sprite();
            addChild(this._mapIconContaioner);
            this._selectedBg = ComponentFactory.Instance.creatComponentByStylename("asset.room.mapItemSelectedAsset");
            addChild(this._selectedBg);
            this._selectedBg.visible = false;
        }

        protected function initEvents():void
        {
            addEventListener(MouseEvent.CLICK, this.__onClick);
        }

        protected function removeEvents():void
        {
            removeEventListener(MouseEvent.CLICK, this.__onClick);
        }

        protected function updateMapIcon():void
        {
            if (this._loader != null)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__onComplete);
            };
            this._loader = LoadResourceManager.instance.createLoader(this.solvePath(), BaseLoader.BITMAP_LOADER);
            this._loader.addEventListener(LoaderEvent.COMPLETE, this.__onComplete);
            LoadResourceManager.instance.startLoad(this._loader);
        }

        protected function solvePath():String
        {
            return (((PathManager.SITE_MAIN + "image/map/") + this._mapId.toString()) + "/samll_map_s.jpg");
        }

        protected function __onComplete(_arg_1:LoaderEvent):void
        {
            var _local_2:Bitmap;
            ObjectUtils.disposeAllChildren(this._mapIconContaioner);
            this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__onComplete);
            this._loader = null;
            if (BaseLoader(_arg_1.loader).isSuccess)
            {
                _local_2 = Bitmap(_arg_1.loader.content);
                _local_2.width = this._bg.width;
                _local_2.height = this._bg.height;
                this._mapIconContaioner.addChild(_local_2);
            };
        }

        protected function updateSelectState():void
        {
            this._selectedBg.visible = this._selected;
        }

        private function __onClick(_arg_1:MouseEvent):void
        {
            var _local_2:DungeonInfo;
            if (this._mapId > -1)
            {
                SoundManager.instance.play("045");
                _local_2 = (MapManager.getDungeonInfo(this._mapId) as DungeonInfo);
                if (((_local_2) && (_local_2.LevelLimits > PlayerManager.Instance.Self.Grade)))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomMapSetPanelDuplicate.clew", _local_2.LevelLimits));
                    return;
                };
                this.selected = true;
            };
        }

        public function dispose():void
        {
            this.removeEvents();
            removeChild(this._bg);
            this._bg.bitmapData.dispose();
            this._bg = null;
            ObjectUtils.disposeAllChildren(this._mapIconContaioner);
            removeChild(this._mapIconContaioner);
            this._mapIconContaioner = null;
            if (this._selectedBg)
            {
                if (this._selectedBg.parent != null)
                {
                    this._selectedBg.parent.removeChild(this._selectedBg);
                };
                this._selectedBg.dispose();
            };
            this._selectedBg = null;
            if (this._loader != null)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__onComplete);
            };
            this._loader = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._selected == _arg_1)
            {
                return;
            };
            this._selected = _arg_1;
            this.updateSelectState();
            if (this._selected)
            {
                dispatchEvent(new Event(Event.SELECT));
            };
        }

        public function get mapId():int
        {
            return (this._mapId);
        }

        public function set mapId(_arg_1:int):void
        {
            this._mapId = _arg_1;
            this.updateMapIcon();
            buttonMode = (!(this.mapId == 10000));
        }


    }
}//package room.view.chooseMap

