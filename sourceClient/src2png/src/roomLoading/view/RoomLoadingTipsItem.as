// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomLoading.view.RoomLoadingTipsItem

package roomLoading.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class RoomLoadingTipsItem extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _txtField:FilterFrameText;

        public function RoomLoadingTipsItem()
        {
            this.init();
        }

        public function init():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.TipsItemBg");
            this._txtField = ComponentFactory.Instance.creatComponentByStylename("roomLoading.TipsItemContentTxt");
            this._txtField.text = LanguageMgr.GetTranslation(("ddt.roomLoading.tips" + String(int((Math.random() * 2)))));
            this._txtField.x = (((this._bg.width - this._txtField.textWidth) / 2) - 4);
            this._txtField.y = (((this._bg.height - this._txtField.textHeight) / 2) + 7);
            addChild(this._bg);
            addChild(this._txtField);
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package roomLoading.view

