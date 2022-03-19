// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.BuffItem

package worldboss.view
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.BitmapLoader;
    import com.pickgliss.loader.LoaderEvent;
    import flash.display.Bitmap;
    import worldboss.WorldBossManager;
    import worldboss.model.WorldBossBuffInfo;
    import ddt.manager.LanguageMgr;

    public class BuffItem extends Component 
    {

        private var _buffId:int;

        public function BuffItem(_arg_1:int)
        {
            this._buffId = _arg_1;
            this.initView();
        }

        private function initView():void
        {
            var _local_1:BitmapLoader = LoadResourceManager.instance.createLoader(WorldBossRoomView.getImagePath(this._buffId), BaseLoader.BITMAP_LOADER);
            _local_1.addEventListener(LoaderEvent.COMPLETE, this.__buffIconComplete);
            LoadResourceManager.instance.startLoad(_local_1);
        }

        private function __buffIconComplete(_arg_1:LoaderEvent):void
        {
            var _local_3:Bitmap;
            if (_arg_1.loader.isSuccess)
            {
                _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__buffIconComplete);
                _local_3 = (_arg_1.loader.content as Bitmap);
                _local_3.width = 50;
                _local_3.height = 50;
                addChild(_local_3);
            };
            tipStyle = "ddt.view.tips.OneLineTip";
            tipDirctions = "5,1";
            var _local_2:WorldBossBuffInfo = WorldBossManager.Instance.bossInfo.getbuffInfoByID(this._buffId);
            tipData = ((((_local_2.name + ":") + LanguageMgr.GetTranslation("worldboss.buff.limit")) + "\n") + _local_2.decription);
        }


    }
}//package worldboss.view

