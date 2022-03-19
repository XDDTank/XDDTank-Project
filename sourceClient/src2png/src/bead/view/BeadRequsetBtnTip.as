// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadRequsetBtnTip

package bead.view
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import bead.BeadManager;
    import com.pickgliss.utils.ObjectUtils;

    public class BeadRequsetBtnTip extends BaseTip 
    {

        private var _bg:ScaleBitmapImage;
        private var _nameTxt:FilterFrameText;
        private var _discTxt:FilterFrameText;
        private var _beadTipData:Object;
        private var _nameList:Array;
        private var _moneyList:Array;

        public function BeadRequsetBtnTip()
        {
            this.initView();
            this.initData();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.bg");
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.name");
            this._discTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.disc");
            addChild(this._bg);
            addChild(this._nameTxt);
            addChild(this._discTxt);
        }

        private function initData():void
        {
            var _local_1:String = LanguageMgr.GetTranslation("beadSystem.requestBtn.tip.nameList");
            this._nameList = _local_1.split(",");
            this._moneyList = BeadManager.instance.beadConfig.GemGold.split("|");
        }

        override public function get tipData():Object
        {
            return (this._beadTipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            var _local_3:String;
            var _local_4:int;
            this._beadTipData = _arg_1;
            var _local_2:int = int(_arg_1);
            if (((_local_2 >= 1) && (_local_2 <= 4)))
            {
                _local_3 = this._nameList[(_local_2 - 1)];
                _local_4 = this._moneyList[(_local_2 - 1)];
            }
            else
            {
                _local_3 = "";
                _local_4 = 0;
            };
            this._nameTxt.text = _local_3;
            this._discTxt.text = LanguageMgr.GetTranslation("beadSystem.requestBtn.tip.discStr", _local_4.toString());
            this.updateSize();
        }

        private function updateSize():void
        {
            this._bg.width = ((this._discTxt.x + this._discTxt.width) + 15);
            this._bg.height = ((this._discTxt.y + this._discTxt.height) + 10);
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            this._beadTipData = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._nameTxt)
            {
                ObjectUtils.disposeObject(this._nameTxt);
            };
            this._nameTxt = null;
            if (this._discTxt)
            {
                ObjectUtils.disposeObject(this._discTxt);
            };
            this._discTxt = null;
            super.dispose();
        }


    }
}//package bead.view

