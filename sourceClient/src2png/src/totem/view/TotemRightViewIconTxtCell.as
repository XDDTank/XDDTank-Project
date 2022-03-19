// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemRightViewIconTxtCell

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.Component;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.text.TextFormat;
    import com.pickgliss.utils.ObjectUtils;

    public class TotemRightViewIconTxtCell extends Sprite implements Disposeable 
    {

        private var _iconComponent:Component;
        private var _icon:Bitmap;
        private var _txt:FilterFrameText;

        public function TotemRightViewIconTxtCell()
        {
            this._txt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.iconCell.txt");
            this._iconComponent = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.iconComponent");
        }

        public function show(_arg_1:int):void
        {
            if (((_arg_1 == 1) || (_arg_1 == 3)))
            {
                this._icon = ComponentFactory.Instance.creatBitmap("asset.totem.rightView.exp");
                this._iconComponent.tipData = LanguageMgr.GetTranslation(((_arg_1 == 3) ? "ddt.totem.rightView.expTipTxt" : "ddt.totem.rightView.needExpTipTxt"));
            }
            else
            {
                if (((_arg_1 == 2) || (_arg_1 == 4)))
                {
                    this._icon = ComponentFactory.Instance.creatBitmap("asset.totem.rightView.honor");
                    this._txt.y = (this._txt.y + 6);
                    this._iconComponent.tipData = LanguageMgr.GetTranslation(((_arg_1 == 4) ? "ddt.totem.rightView.honorTipTxt" : "ddt.totem.rightView.needHonorTipTxt"));
                };
            };
            this._iconComponent.addChild(this._icon);
            addChild(this._iconComponent);
            addChild(this._txt);
        }

        public function refresh(_arg_1:int, _arg_2:Boolean=false):void
        {
            this._txt.text = _arg_1.toString();
            if (_arg_2)
            {
                this._txt.setTextFormat(new TextFormat(null, null, 0xFF0000));
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._iconComponent = null;
            this._icon = null;
            this._txt = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

