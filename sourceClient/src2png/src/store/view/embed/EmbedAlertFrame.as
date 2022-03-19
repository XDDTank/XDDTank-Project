// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.embed.EmbedAlertFrame

package store.view.embed
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import flash.display.DisplayObject;

    public class EmbedAlertFrame extends BaseAlerFrame 
    {

        public static const ADDFrameHeight:int = 60;


        public function show(_arg_1:DisplayObject):void
        {
            var _local_2:AlertInfo = new AlertInfo();
            _local_2.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _local_2.submitLabel = LanguageMgr.GetTranslation("ok");
            _local_2.cancelLabel = LanguageMgr.GetTranslation("cancel");
            _local_2.data = _arg_1;
            info = _local_2;
            addToContent(_arg_1);
            width = (_arg_1.width + (_containerX * 2));
            height = ((_arg_1.height + _containerY) + ADDFrameHeight);
            moveEnable = false;
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package store.view.embed

