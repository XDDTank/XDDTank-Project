// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.display.BitmapLoaderProxy

package ddt.display
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.loader.BitmapLoader;
    import flash.display.Bitmap;
    import flash.geom.Rectangle;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import flash.events.Event;

    public class BitmapLoaderProxy extends Sprite implements Disposeable 
    {

        public static const LOADING_FINISH:String = "loadingFinish";

        private var _loader:BitmapLoader;
        private var _bitmap:Bitmap;
        private var _size:Rectangle;
        private var _isSmoothing:Boolean;

        public function BitmapLoaderProxy(_arg_1:String, _arg_2:Rectangle=null, _arg_3:Boolean=false)
        {
            this._size = _arg_2;
            this._isSmoothing = _arg_3;
            this._loader = LoadResourceManager.instance.createLoader(_arg_1, BaseLoader.BITMAP_LOADER);
            this._loader.addEventListener(LoaderEvent.COMPLETE, this.onComplete);
            LoadResourceManager.instance.startLoad(this._loader);
        }

        private function onComplete(_arg_1:LoaderEvent):void
        {
            if (this._loader.isSuccess)
            {
                this._bitmap = this._loader.content;
                if (this._size)
                {
                    this._bitmap.x = this._size.x;
                    this._bitmap.y = this._size.y;
                    this._bitmap.width = this._size.width;
                    this._bitmap.height = this._size.height;
                };
                addChild(this._bitmap);
                this._bitmap.smoothing = this._isSmoothing;
                dispatchEvent(new Event(LOADING_FINISH));
            };
        }

        public function dispose():void
        {
            if (this._loader)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.onComplete);
                this._loader = null;
            };
            if (this._bitmap)
            {
                removeChild(this._bitmap);
                this._bitmap.bitmapData.dispose();
                this._bitmap = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.display

