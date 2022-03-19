// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.RoomLayer

package ddt.view.character
{
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BitmapLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;

    public class RoomLayer extends BaseLayer 
    {

        private var _clothType:int = 0;
        private var _sex:Boolean;

        public function RoomLayer(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:Boolean=false, _arg_4:int=1, _arg_5:String=null, _arg_6:int=0)
        {
            this._clothType = _arg_6;
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        override protected function getUrl(_arg_1:int):String
        {
            if (this._clothType == 0)
            {
                return (PathManager.solveGoodsPath(_info, _pic, (_info.NeedSex == 1), SHOW, _hairType, String(_arg_1), _info.Level, _gunBack, int(_info.Property1)));
            };
            return ("normal.png");
        }

        override protected function initLoaders():void
        {
            var _local_1:String;
            var _local_2:BitmapLoader;
            if (_info)
            {
                _local_1 = this.getUrl(0);
                _local_2 = LoadResourceManager.instance.createLoader(_local_1, BaseLoader.BITMAP_LOADER);
                _queueLoader.addLoader(_local_2);
            };
        }

        override public function reSetBitmap():void
        {
            var _local_1:int;
            clearBitmap();
            _local_1 = 0;
            while (_local_1 < _queueLoader.loaders.length)
            {
                _bitmaps.push(_queueLoader.loaders[_local_1].content);
                if (_bitmaps[_local_1])
                {
                    _bitmaps[_local_1].smoothing = true;
                    _bitmaps[_local_1].visible = false;
                    addChild(_bitmaps[_local_1]);
                };
                _local_1++;
            };
        }


    }
}//package ddt.view.character

