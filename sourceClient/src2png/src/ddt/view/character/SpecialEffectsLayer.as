// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.SpecialEffectsLayer

package ddt.view.character
{
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.BitmapLoader;

    public class SpecialEffectsLayer extends BaseLayer 
    {

        private var _specialType:int;

        public function SpecialEffectsLayer(_arg_1:int=1)
        {
            this._specialType = _arg_1;
            super(new ItemTemplateInfo());
        }

        override protected function getUrl(_arg_1:int):String
        {
            return (((PathManager.SITE_MAIN + "image/equip/effects/specialEffect/effect_") + _arg_1) + ".png");
        }

        override protected function initLoaders():void
        {
            var _local_1:String = this.getUrl(this._specialType);
            var _local_2:BitmapLoader = LoadResourceManager.instance.createLoader(_local_1, BaseLoader.BITMAP_LOADER);
            _queueLoader.addLoader(_local_2);
        }


    }
}//package ddt.view.character

