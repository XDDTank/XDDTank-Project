// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.ShowLayer

package ddt.view.character
{
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;

    public class ShowLayer extends BaseLayer 
    {

        private var _sex:Boolean;

        public function ShowLayer(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:Boolean=false, _arg_4:int=1, _arg_5:String=null)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        override protected function getUrl(_arg_1:int):String
        {
            return (PathManager.solveGoodsPath(_info, _pic, (_info.NeedSex == 1), SHOW, _hairType, String(_arg_1), _info.Level, _gunBack, int(_info.Property1)));
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

