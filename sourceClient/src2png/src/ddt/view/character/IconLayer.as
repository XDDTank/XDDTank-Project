// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.IconLayer

package ddt.view.character
{
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.loader.BitmapLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.PathManager;

    public class IconLayer extends BaseLayer 
    {

        private var _sex:Boolean;

        public function IconLayer(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:Boolean=false, _arg_4:int=1)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            this.buttonMode = true;
        }

        override protected function initLoaders():void
        {
            var _local_1:String;
            var _local_2:BitmapLoader;
            if (_info != null)
            {
                _local_1 = this.getUrl(1);
                _local_2 = LoadResourceManager.instance.createLoader(_local_1, BaseLoader.BITMAP_LOADER);
                _queueLoader.addLoader(_local_2);
                _defaultLayer = 0;
                _currentEdit = ((_info.Property8 == null) ? 0 : _info.Property8.length);
            };
        }

        override protected function getUrl(_arg_1:int):String
        {
            return (PathManager.solveGoodsPath(_info, _info.Pic, (_info.NeedSex == 1), BaseLayer.ICON, _hairType, String(_arg_1), _info.Level, _gunBack, int(_info.Property1)));
        }


    }
}//package ddt.view.character

