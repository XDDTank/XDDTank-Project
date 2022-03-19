// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestinfoDescriptionItemView

package quest
{
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class QuestinfoDescriptionItemView extends QuestInfoItemView 
    {

        private var _discriptionTxt:FilterFrameText;


        override protected function initView():void
        {
            super.initView();
            _titleImg = ComponentFactory.Instance.creatComponentByStylename("asset.core.quest.QuestInfoDescTitleImg");
            addChild(_titleImg);
            this._discriptionTxt = ComponentFactory.Instance.creatComponentByStylename("core.quest.QuestInfoDescription");
            _content.addChild(this._discriptionTxt);
        }

        override public function set info(_arg_1:QuestInfo):void
        {
            _info = _arg_1;
            this._discriptionTxt.htmlText = (("   " + QuestDescTextAnalyz.start(_info.Detail)) + "<br/><br/>");
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._discriptionTxt);
            this._discriptionTxt = null;
            super.dispose();
        }


    }
}//package quest

