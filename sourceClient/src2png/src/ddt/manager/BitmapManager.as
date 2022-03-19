// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.BitmapManager

package ddt.manager
{
    import com.pickgliss.ui.core.Disposeable;
    import flash.geom.Point;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.display.BitmapObject;
    import ddt.display.BitmapShape;
    import flash.geom.Matrix;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.IBitmapDrawable;

    public class BitmapManager implements Disposeable 
    {

        public static const GameView:String = "GameView";
        private static const destPoint:Point = new Point();
        private static var _mgrPool:Object = new Object();

        private var _bitmapPool:Object;
        private var _len:int;
        public var name:String = "BitmapManager";
        public var linkCount:int = 0;

        public function BitmapManager()
        {
            this._bitmapPool = new Object();
        }

        public static function hasMgr(_arg_1:String):Boolean
        {
            return (_mgrPool.hasOwnProperty(_arg_1));
        }

        private static function registerMgr(_arg_1:String, _arg_2:BitmapManager):void
        {
            _mgrPool[_arg_1] = _arg_2;
        }

        private static function removeMgr(_arg_1:String):void
        {
            if (hasMgr(_arg_1))
            {
                delete _mgrPool[_arg_1];
            };
        }

        public static function getBitmapMgr(_arg_1:String):BitmapManager
        {
            var _local_2:BitmapManager;
            if (hasMgr(_arg_1))
            {
                _local_2 = _mgrPool[_arg_1];
                _local_2.linkCount++;
                return (_local_2);
            };
            _local_2 = new (BitmapManager)();
            _local_2.name = _arg_1;
            _local_2.linkCount++;
            registerMgr(_arg_1, _local_2);
            return (_local_2);
        }

        public static function LoadPic(_arg_1:Function, _arg_2:ItemTemplateInfo):void
        {
            var _local_3:BaseLoader;
            _local_3 = LoadResourceManager.instance.createLoader(PathManager.solveGoodsPath(_arg_2, _arg_2.Pic, (_arg_2.NeedSex == 1)), BaseLoader.BITMAP_LOADER);
            _local_3.addEventListener(LoaderEvent.COMPLETE, _arg_1);
            LoadResourceManager.instance.startLoad(_local_3);
        }


        public function dispose():void
        {
            this.linkCount--;
            if (this.linkCount <= 0)
            {
                this.destory();
            };
        }

        private function destory():void
        {
            var _local_1:String;
            var _local_2:BitmapObject;
            removeMgr(this.name);
            for (_local_1 in this._bitmapPool)
            {
                _local_2 = this._bitmapPool[_local_1];
                _local_2.destory();
                delete this._bitmapPool[_local_1];
            };
            this._bitmapPool = null;
        }

        public function creatBitmapShape(_arg_1:String, _arg_2:Matrix=null, _arg_3:Boolean=true, _arg_4:Boolean=false):BitmapShape
        {
            return (new BitmapShape(this.getBitmap(_arg_1), _arg_2, _arg_3, _arg_4));
        }

        public function hasBitmap(_arg_1:String):Boolean
        {
            return (this._bitmapPool.hasOwnProperty(_arg_1));
        }

        public function getBitmap(_arg_1:String):BitmapObject
        {
            var _local_2:BitmapObject;
            if (this.hasBitmap(_arg_1))
            {
                _local_2 = this._bitmapPool[_arg_1];
                _local_2.linkCount++;
                return (_local_2);
            };
            _local_2 = this.createBitmap(_arg_1);
            _local_2.manager = this;
            _local_2.linkCount++;
            return (_local_2);
        }

        private function createBitmap(_arg_1:String):BitmapObject
        {
            var _local_3:BitmapObject;
            var _local_2:* = ComponentFactory.Instance.creat(_arg_1);
            if ((_local_2 is BitmapData))
            {
                _local_3 = new BitmapObject(_local_2.width, _local_2.height, true, 0);
                _local_3.copyPixels(_local_2, _local_2.rect, destPoint);
                _local_3.linkName = _arg_1;
                this.addBitmap(_local_3);
                return (_local_3);
            };
            if ((_local_2 is Bitmap))
            {
                _local_3 = new BitmapObject(_local_2.bitmapData.width, _local_2.bitmapData.height, true, 0);
                _local_3.copyPixels(_local_2.bitmapData, _local_2.bitmapData.rect, destPoint);
                _local_3.linkName = _arg_1;
                this.addBitmap(_local_3);
                return (_local_3);
            };
            if ((_local_2 is DisplayObject))
            {
                _local_3 = new BitmapObject(_local_2.width, _local_2.height, true, 0);
                _local_3.draw((_local_2 as IBitmapDrawable));
                _local_3.linkName = _arg_1;
                this.addBitmap(_local_3);
                return (_local_3);
            };
            return (null);
        }

        private function addBitmap(_arg_1:BitmapObject):void
        {
            if ((!(this.hasBitmap(_arg_1.linkName))))
            {
                this._len++;
            };
            _arg_1.linkCount = 0;
            _arg_1.manager = this;
            this._bitmapPool[_arg_1.linkName] = _arg_1;
        }

        private function removeBitmap(_arg_1:BitmapObject):void
        {
            if (this.hasBitmap(_arg_1.linkName))
            {
                this._len--;
            };
            delete this._bitmapPool[_arg_1.linkName];
        }


    }
}//package ddt.manager

