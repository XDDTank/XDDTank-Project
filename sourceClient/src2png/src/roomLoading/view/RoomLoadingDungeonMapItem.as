// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomLoading.view.RoomLoadingDungeonMapItem

package roomLoading.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import com.pickgliss.loader.DisplayLoader;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import room.RoomManager;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import flash.events.Event;
    import ddt.manager.PathManager;
    import game.GameManager;
    import com.pickgliss.utils.ObjectUtils;

    public class RoomLoadingDungeonMapItem extends Sprite implements Disposeable 
    {

        private var _displayMc:MovieClip;
        private var _itemFrame:DisplayObject;
        private var _item:Sprite;
        private var _mapLoader:DisplayLoader;

        public function RoomLoadingDungeonMapItem()
        {
            this.init();
        }

        private function init():void
        {
            this._item = new Sprite();
            this._itemFrame = ComponentFactory.Instance.creat("asset.roomLoading.DungeonMapFrame");
            this._displayMc = ComponentFactory.Instance.creat("asset.roomloading.displayMC");
            this._mapLoader = LoadResourceManager.instance.createLoader(this.solveMapPath(), BaseLoader.MODULE_LOADER);
            this._mapLoader.addEventListener(LoaderEvent.COMPLETE, this.__onLoadComplete);
            LoadResourceManager.instance.startLoad(this._mapLoader);
        }

        private function __onLoadComplete(_arg_1:Event):void
        {
            var _local_2:String;
            var _local_3:Object;
            var _local_4:MovieClip;
            if (this._mapLoader.isSuccess)
            {
                this._mapLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onLoadComplete);
                _local_2 = RoomManager.Instance.current.pic;
                _local_3 = (ClassUtils.getDefinition(("game.show." + _local_2)) as Class);
                _local_4 = (new (_local_3)() as MovieClip);
                _local_4.stop();
                addChild(_local_4);
                PositionUtils.setPos(this._displayMc, "asset.roomLoading.DungeonMapLoaderPos");
                this._displayMc.scaleX = (this._item.scaleX = -1);
                this._displayMc["character"].addChild(this._item);
                this._displayMc.gotoAndPlay("appear1");
                addChild(this._displayMc);
            };
        }

        private function solveMapPath():String
        {
            var _local_1:String = (PathManager.SITE_MAIN + "image/game/living");
            if (GameManager.Instance.Current.gameMode == 8)
            {
                return (_local_1 + "1133/show.jpg");
            };
            var _local_2:String = RoomManager.Instance.current.pic;
            var _local_3:String = _local_2.toLocaleLowerCase();
            return (_local_1 + (("/" + _local_3) + ".swf"));
        }

        public function disappear():void
        {
            this._displayMc.gotoAndPlay("disappear1");
        }

        public function dispose():void
        {
            this._mapLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onLoadComplete);
            ObjectUtils.disposeAllChildren(this);
            this._mapLoader = null;
            this._displayMc = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package roomLoading.view

