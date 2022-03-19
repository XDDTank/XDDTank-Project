// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.RechargeAlertTxt

package vip.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class RechargeAlertTxt extends Sprite implements Disposeable 
    {

        private var _bg:Scale9CornerImage;
        private var _title:FilterFrameText;
        private var _content:FilterFrameText;

        public function RechargeAlertTxt()
        {
            this.initView();
        }

        private function initView():void
        {
            this._title = ComponentFactory.Instance.creat("VipRechargeLV.titleTxt");
            addChild(this._title);
            this._content = ComponentFactory.Instance.creat("VipRechargeLV.contentTxt");
            addChild(this._content);
        }

        public function set AlertContent(_arg_1:int):void
        {
            this._title.text = this.getAlertTitle(_arg_1);
            this._content.text = this.getAlertTxt(_arg_1);
        }

        private function getAlertTxt(_arg_1:int):String
        {
            var _local_2:String = "";
            switch (_arg_1)
            {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                    _local_2 = (_local_2 + (("1、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param0"))) + "\n"));
                    _local_2 = (_local_2 + (("2、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2Param"))) + "\n"));
                    _local_2 = (_local_2 + (("3、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param"))) + "\n"));
                    _local_2 = (_local_2 + (("4、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4Param0"))) + "\n"));
                    _local_2 = (_local_2 + (("5、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param0"))) + "\n"));
                    _local_2 = (_local_2 + (("6、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7Param0"))) + "\n"));
                    _local_2 = (_local_2 + (("7、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8")) + "\n"));
                    _local_2 = (_local_2 + (("8、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent9")) + "\n"));
                    _local_2 = (_local_2 + (("9、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent10", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent10Param0"))) + "\n"));
                    _local_2 = (_local_2 + (("10、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent11", ";")) + "\n"));
                    _local_2 = (_local_2 + (("11、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param0"), LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param2"))) + "\n"));
                    _local_2 = (_local_2 + ("            " + "\n"));
                    break;
                case 7:
                case 8:
                case 9:
                case 10:
                case 11:
                case 12:
                    _local_2 = (_local_2 + (LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent13") + "\n"));
                    _local_2 = (_local_2 + (LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent14") + "\n"));
                    _local_2 = (_local_2 + (LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent15") + "\n"));
                    _local_2 = (_local_2 + (LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent16") + "\n"));
                    _local_2 = (_local_2 + (LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent17") + "\n"));
                    _local_2 = (_local_2 + (("6、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param1"))) + "\n"));
                    _local_2 = (_local_2 + (("7、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4Param1"))) + "\n"));
                    _local_2 = (_local_2 + (("8、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7Param1"))) + "\n"));
                    _local_2 = (_local_2 + (("9、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param"))) + "\n"));
                    _local_2 = (_local_2 + (("10、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2Param"))) + "\n"));
                    _local_2 = (_local_2 + (("11、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8")) + "\n"));
                    _local_2 = (_local_2 + (("12、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param1"))) + "\n"));
                    _local_2 = (_local_2 + (("13、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent11", ";")) + "\n"));
                    _local_2 = (_local_2 + (("14、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent9")) + "\n"));
                    _local_2 = (_local_2 + (("15、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent10", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent10Param1"))) + "\n"));
                    _local_2 = (_local_2 + (("16、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12", LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param1"), LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param3"))) + "\n"));
                    _local_2 = (_local_2 + ("            " + "\n"));
                    break;
            };
            return (_local_2);
        }

        private function getAlertTitle(_arg_1:int):String
        {
            var _local_2:String = "";
            switch (_arg_1)
            {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                    _local_2 = LanguageMgr.GetTranslation("tank.vip.rechargeAlertTitle", 6);
                    break;
                case 7:
                case 8:
                case 9:
                case 10:
                case 11:
                case 12:
                    _local_2 = LanguageMgr.GetTranslation("tank.vip.rechargeAlertEndTitle", 12);
                    break;
            };
            return (_local_2);
        }

        public function dispose():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg = null;
            };
            if (this._title)
            {
                ObjectUtils.disposeObject(this._title);
                this._title = null;
            };
            if (this._content)
            {
                ObjectUtils.disposeObject(this._content);
                this._content = null;
            };
        }


    }
}//package vip.view

