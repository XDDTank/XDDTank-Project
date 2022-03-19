// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestConditionView

package quest
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import ddt.data.quest.QuestCondition;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class QuestConditionView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _cond:QuestCondition;
        private var conditionText:FilterFrameText;
        private var statusText:FilterFrameText;

        public function QuestConditionView(_arg_1:QuestCondition)
        {
            this._bg = ComponentFactory.Instance.creat("asset.core.quest.QuestConditionBGHighlight");
            addChild(this._bg);
            this.conditionText = ComponentFactory.Instance.creat("core.quest.QuestConditionText");
            addChild(this.conditionText);
            this.statusText = ComponentFactory.Instance.creat("core.quest.QuestConditionStatus");
            addChild(this.statusText);
            this._cond = _arg_1;
            this.text = this._cond.description;
        }

        public function set status(_arg_1:String):void
        {
            this.statusText.text = _arg_1;
        }

        public function set text(_arg_1:String):void
        {
            this.conditionText.text = _arg_1;
            if (this.conditionText.width > 330)
            {
                this.statusText.x = this.conditionText.x;
                this.statusText.y = (this.conditionText.y + this.conditionText.textHeight);
            }
            else
            {
                this.statusText.x = (this.conditionText.x + this.conditionText.width);
            };
        }

        public function set isComplete(_arg_1:Boolean):void
        {
            if (_arg_1 == true)
            {
            };
        }

        override public function get height():Number
        {
            return (35);
        }

        public function dispose():void
        {
            this._cond = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this.conditionText)
            {
                ObjectUtils.disposeObject(this.conditionText);
            };
            this.conditionText = null;
            if (this.statusText)
            {
                ObjectUtils.disposeObject(this.statusText);
            };
            this.statusText = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package quest

