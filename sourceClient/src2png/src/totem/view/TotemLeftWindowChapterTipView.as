// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemLeftWindowChapterTipView

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import totem.TotemManager;
    import totem.data.TotemAddInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class TotemLeftWindowChapterTipView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _titleTxt:FilterFrameText;
        private var _nameTxt:FilterFrameText;
        private var _valueTxtList:Vector.<FilterFrameText>;
        private var _titleTxtList:Array;
        private var _numTxtList:Array;
        private var _propertyTxtList:Array;

        public function TotemLeftWindowChapterTipView()
        {
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this._titleTxtList = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.titleListTxt").split(",");
            this._numTxtList = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.numListTxt").split(",");
            this._propertyTxtList = LanguageMgr.GetTranslation("ddt.totem.sevenProperty").split(",");
            this.initView();
        }

        private function initView():void
        {
            var _local_2:FilterFrameText;
            this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.chapterTip.bg");
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemChapterTip.titleTxt");
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemChapterTip.nameTxt");
            addChild(this._bg);
            addChild(this._titleTxt);
            addChild(this._nameTxt);
            this._valueTxtList = new Vector.<FilterFrameText>();
            var _local_1:int;
            while (_local_1 < 7)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("totem.totemChapterTip.valueTxt");
                _local_2.y = (_local_2.y + (_local_1 * 20));
                addChild(_local_2);
                this._valueTxtList.push(_local_2);
                _local_1++;
            };
        }

        public function show(_arg_1:int):void
        {
            var _local_2:int = (_arg_1 - 1);
            this._titleTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.titleTxt", this._numTxtList[_local_2], this._titleTxtList[_local_2]);
            this._nameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.nameTxt", this._numTxtList[_local_2]);
            var _local_3:TotemAddInfo = TotemManager.instance.getAddInfo((_arg_1 * 70), (((_arg_1 - 1) * 70) + 1));
            var _local_4:int;
            while (_local_4 < 7)
            {
                this._valueTxtList[_local_4].text = ((this._propertyTxtList[_local_4] + "+") + TotemManager.instance.getAddValue((_local_4 + 1), _local_3));
                _local_4++;
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._bg = null;
            this._titleTxt = null;
            this._nameTxt = null;
            this._valueTxtList = null;
            this._titleTxtList = null;
            this._numTxtList = null;
            this._propertyTxtList = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

