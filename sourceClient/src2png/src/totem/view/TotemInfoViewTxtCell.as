// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemInfoViewTxtCell

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import totem.TotemManager;
    import totem.data.TotemAddInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class TotemInfoViewTxtCell extends Sprite implements Disposeable 
    {

        private var _nameTxt:FilterFrameText;
        private var _valueTxt:FilterFrameText;
        private var _txtArray:Array;
        private var _bg:Bitmap;

        public function TotemInfoViewTxtCell()
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.infoView.txtCellBg");
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.infoView.propertyName.txt");
            this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.infoView.propertyValue.txt");
            var _local_1:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
            this._txtArray = _local_1.split(",");
            addChild(this._bg);
            addChild(this._nameTxt);
            addChild(this._valueTxt);
        }

        public function show(_arg_1:int, _arg_2:int):void
        {
            this._nameTxt.text = this._txtArray[(_arg_1 - 1)];
            var _local_3:TotemAddInfo = TotemManager.instance.getAddInfo(_arg_2);
            switch (_arg_1)
            {
                case 1:
                    this._valueTxt.text = _local_3.Attack.toString();
                    return;
                case 2:
                    this._valueTxt.text = _local_3.Defence.toString();
                    return;
                case 3:
                    this._valueTxt.text = _local_3.Agility.toString();
                    return;
                case 4:
                    this._valueTxt.text = _local_3.Luck.toString();
                    return;
                case 5:
                    this._valueTxt.text = _local_3.Blood.toString();
                    return;
                case 6:
                    this._valueTxt.text = _local_3.Damage.toString();
                    return;
                case 7:
                    this._valueTxt.text = _local_3.Guard.toString();
                    return;
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._nameTxt = null;
            this._valueTxt = null;
            this._bg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

