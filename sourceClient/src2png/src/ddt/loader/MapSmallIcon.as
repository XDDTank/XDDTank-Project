// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.loader.MapSmallIcon

package ddt.loader
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.loader.DisplayLoader;
    import flash.display.Bitmap;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class MapSmallIcon extends Sprite implements Disposeable 
    {

        protected var _loader:DisplayLoader;
        protected var _icon:Bitmap;
        protected var _mapID:int = 0;

        public function MapSmallIcon(_arg_1:int=9999999)
        {
            this._mapID = _arg_1;
            super();
        }

        public function startLoad():void
        {
            this.loadIcon();
        }

        protected function loadIcon():void
        {
            if (this.id == 9999999)
            {
                return;
            };
            this._loader = LoadResourceManager.instance.createLoader(PathManager.solveMapIconPath(this._mapID, 0), BaseLoader.BITMAP_LOADER);
            this._loader.addEventListener(LoaderEvent.COMPLETE, this.__complete);
            LoadResourceManager.instance.startLoad(this._loader);
        }

        private function __complete(_arg_1:LoaderEvent):void
        {
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__complete);
            if (_arg_1.loader.isSuccess)
            {
                this._icon = _arg_1.loader.content;
                if (this._icon)
                {
                    addChild(this._icon);
                };
            };
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function set id(_arg_1:int):void
        {
            this._mapID = _arg_1;
            this.loadIcon();
        }

        public function get id():int
        {
            return (this._mapID);
        }

        public function get icon():Bitmap
        {
            return (this._icon);
        }

        public function dispose():void
        {
            this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__complete);
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
            this._loader = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.loader

