// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.StateLayer

package ddt.view.character
{
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BitmapLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import flash.events.Event;

    public class StateLayer extends BaseLayer 
    {

        private var _stateType:int;
        private var _sex:Boolean;

        public function StateLayer(_arg_1:ItemTemplateInfo, _arg_2:Boolean, _arg_3:String, _arg_4:int=1)
        {
            this._stateType = _arg_4;
            this._sex = _arg_2;
            super(_arg_1, _arg_3);
        }

        override protected function getUrl(_arg_1:int):String
        {
            return ((((((PathManager.SITE_MAIN + "image/equip/effects/state/") + ((this._sex) ? "m/" : "f/")) + this._stateType) + "/show") + _arg_1) + ".png");
        }

        override protected function initLoaders():void
        {
            var _local_2:String;
            var _local_3:BitmapLoader;
            var _local_1:int;
            while (_local_1 < 3)
            {
                _local_2 = this.getUrl((_local_1 + 1));
                _local_3 = LoadResourceManager.instance.createLoader(_local_2, BaseLoader.BITMAP_LOADER);
                _queueLoader.addLoader(_local_3);
                _local_1++;
            };
            _defaultLayer = 0;
            _currentEdit = _queueLoader.length;
        }

        override protected function __loadComplete(_arg_1:Event):void
        {
            reSetBitmap();
            _queueLoader.removeEventListener(Event.COMPLETE, this.__loadComplete);
            _queueLoader.removeEvent();
            initColors(_color);
            loadCompleteCallBack();
        }


    }
}//package ddt.view.character

