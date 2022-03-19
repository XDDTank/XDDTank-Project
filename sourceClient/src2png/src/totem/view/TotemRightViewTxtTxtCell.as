// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemRightViewTxtTxtCell

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import totem.TotemManager;
    import ddt.manager.PlayerManager;
    import totem.data.TotemAddInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class TotemRightViewTxtTxtCell extends Sprite implements Disposeable 
    {

        private var _upTxt:FilterFrameText;
        private var _downTxt:FilterFrameText;
        private var _txtArray:Array;
        private var _type:int;

        public function TotemRightViewTxtTxtCell()
        {
            this._upTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.txtCell.upTxt");
            this._downTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.txtCell.downTxt");
            var _local_1:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
            this._txtArray = _local_1.split(",");
            addChild(this._upTxt);
            addChild(this._downTxt);
        }

        public function show(_arg_1:int):void
        {
            this._upTxt.text = this._txtArray[(_arg_1 - 1)];
            this._type = _arg_1;
            this.refresh();
        }

        public function refresh():void
        {
            var _local_1:TotemAddInfo = TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId));
            switch (this._type)
            {
                case 1:
                    this._downTxt.text = _local_1.Attack.toString();
                    return;
                case 2:
                    this._downTxt.text = _local_1.Defence.toString();
                    return;
                case 3:
                    this._downTxt.text = _local_1.Agility.toString();
                    return;
                case 4:
                    this._downTxt.text = _local_1.Luck.toString();
                    return;
                case 5:
                    this._downTxt.text = _local_1.Blood.toString();
                    return;
                case 6:
                    this._downTxt.text = _local_1.Damage.toString();
                    return;
                case 7:
                    this._downTxt.text = _local_1.Guard.toString();
                    return;
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._upTxt = null;
            this._downTxt = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

