// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.MagicTip

package petsBag.view
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import pet.date.PetInfo;
    import ddt.manager.PetInfoManager;
    import com.pickgliss.utils.StringUtils;
    import __AS3__.vec.*;

    public class MagicTip extends BaseTip 
    {

        private var _bg:ScaleBitmapImage;
        private var _nameTxt:FilterFrameText;
        private var _splitImg1:ScaleBitmapImage;
        private var _description:FilterFrameText;
        private var _splitImg2:ScaleBitmapImage;
        private var _resultTxt:FilterFrameText;
        private var _container:SimpleTileList;
        private var _list:Vector.<FilterFrameText>;


        override protected function init():void
        {
            var _local_1:FilterFrameText;
            super.init();
            this._bg = ComponentFactory.Instance.creat("petsBag.view.magicTip.bg");
            _width = this._bg.width;
            _height = this._bg.height;
            addChild(this._bg);
            this._nameTxt = ComponentFactory.Instance.creat("petsBag.view.magicTip.nametxt");
            this._nameTxt.text = LanguageMgr.GetTranslation("petsbag.tips.magicTip.name");
            addChild(this._nameTxt);
            this._splitImg1 = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.magicTip.splitImg1");
            addChild(this._splitImg1);
            this._description = ComponentFactory.Instance.creat("petsBag.view.infoView.descriptionTxt");
            this._description.text = LanguageMgr.GetTranslation("petsbag.tips.magicTip.description");
            addChild(this._description);
            this._splitImg2 = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.magicTip.splitImg2");
            addChild(this._splitImg2);
            this._resultTxt = ComponentFactory.Instance.creat("petsBag.view.infoView.resultTxt");
            this._resultTxt.text = LanguageMgr.GetTranslation("petsbag.tips.magicTip.result");
            addChild(this._resultTxt);
            this._container = ComponentFactory.Instance.creat("petsBag.view.magicTip.listView", [2]);
            this._list = new Vector.<FilterFrameText>();
            this._container.beginChanges();
            var _local_2:int;
            while (_local_2 < 3)
            {
                _local_1 = ComponentFactory.Instance.creat("petsBag.view.infoView.propertyTxt");
                this._list.push(_local_1);
                this._container.addChild(_local_1);
                _local_2++;
            };
            this._container.commitChanges();
            addChild(this._container);
        }

        override public function set tipData(_arg_1:Object):void
        {
            var _local_3:PetInfo;
            var _local_4:PetInfo;
            super.tipData = _arg_1;
            var _local_2:PetInfo = (_arg_1 as PetInfo);
            if (_local_2)
            {
                _local_3 = PetInfoManager.instance.getPetInfoByTemplateID(_local_2.TemplateID);
                _local_4 = PetInfoManager.instance.getPetInfoByTemplateID(_local_2.MagicId);
                this._list[0].text = LanguageMgr.GetTranslation("petsBag.view.MagicTip.property0", StringUtils.ljust(String(int(((_local_4.Blood - _local_3.Blood) / 100))), 4), StringUtils.ljust(String(int(((_local_4.Attack - _local_3.Attack) / 100))), 4));
                this._list[1].text = LanguageMgr.GetTranslation("petsBag.view.MagicTip.property1", StringUtils.ljust(String(int(((_local_4.Defence - _local_3.Defence) / 100))), 4), StringUtils.ljust(String(int(((_local_4.Agility - _local_3.Agility) / 100))), 4));
                this._list[2].text = LanguageMgr.GetTranslation("petsBag.view.MagicTip.property2", StringUtils.ljust(String(int(((_local_4.Luck - _local_3.Luck) / 100))), 4));
                this._container.arrange();
            };
        }


    }
}//package petsBag.view

